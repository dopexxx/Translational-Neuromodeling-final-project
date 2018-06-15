function [subject,data] = gsr_sync(ID)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function executes an analytical pipeline for the GSR data of a 
%   participant.
%
%   Parameters:
%   ----------------
%   ID              {int} ID of the participant to be analysed
%
%   Returns:
%   ----------------
%   SUBJECT         {struct} like before with some added fields
%   DATA            {struct} in preparation for ledalab toolbox
%
%       Jannis Born, May 2018


load(['data/recordings/gsr_',int2str(ID),'.mat'])
load(['data/behav_analyzed_hgf_newpriors/subject_',int2str(ID),'.mat'])
load('data/metadata.mat')


subject.gsr = struct();
subject.gsr.raw = struct();
subject.gsr.raw.values = scr_data(1,:);
subject.gsr.raw.rel_times = scr_data(2,:);
subject.gsr.raw.abs_times = scr_data(3:5,:);

% Set some hyperparameter
% Time differences between recording machines
subject.time_delta = 0;
% GSR final frequency (in Hertz)
subject.gsr.frequency = 50; 
% Size of median filter window (to extract SCR from GSR, in ms)
subject.gsr.filter_window = 10;

% Let us first synchronize the time stamps from GSR and behavioral data
% and convert timings to relative values.

% Define the onset of the experiment
% 1) Define 20 second before the first sound as a RELATIVE time of 0
t = squeeze(subject.behav.raw.stim_onsets(1,1,:));
t(3) = t(3) - 20; % baseline is 1 sec before first sound.
if t(3) < 0
    t(2) = t(2) - 1; % if second underflow, reduce minutes
    if t(2) < 0
        t(1) = t(1) - 1; % if minute underflow, reduce hours
        if t(1) < 0
            error(['Houston, we have a problem, s.b. made an '...
                'overnight experiment']);
        end
    end 
end
subject.time_onset = t;


% 2) Convert absolute behavioral time into relative times
subject.behav.relative_times = zeros(size(subject.behav.raw.responses));
for k = 1:length(subject.behav.relative_times)
    subject.behav.relative_times(1,k) = time_abs_to_rel(squeeze(...
        subject.behav.raw.stim_onsets(1,k,:)), subject.time_onset);
    
    subject.behav.relative_times(2,k) = time_abs_to_rel(squeeze(...
        subject.behav.raw.stim_onsets(2,k,:)), subject.time_onset);
end 

% 3) 4) Convert SCR times to relative values and add timedelta
raw_rel_times = zeros(length(scr_data),1);
for k = 1:length(scr_data)
    t = time_abs_to_rel(scr_data(3:5,k), subject.time_onset);
    raw_rel_times(k) = t+subject.time_delta;
end



% GSR PREPROCESSING

% 1) Remove time points before the relative time 0
raw_rel_times = raw_rel_times(raw_rel_times~=-1+subject.time_delta);
values = scr_data(1,raw_rel_times~=-1+subject.time_delta)';

% 2) Remove the times from 14 sec after the last sound
time_offset = subject.behav.relative_times(end,end) + 14;
ind_last = 1;
while raw_rel_times(ind_last) < time_offset
    ind_last = ind_last + 1;
end
raw_rel_times(ind_last+1:end) = [];
values(ind_last+1:end) = [];

% Linear interpolation (Nearest Neighbor) in order to have the data sampled
% equidistantly. Interpolated signal will be downsampled from ca. 65 Hz to
% exactly 50 Hz
sample_dist =  (1000/subject.gsr.frequency) / 1000;
subject.gsr.timings = 0:sample_dist:raw_rel_times(end); 
values = interp1(raw_rel_times,values,subject.gsr.timings,'nearest');
values(1)=[];subject.gsr.timings(1)=[];

% Final preprocessing step:
% Remove tonic component in signal (median filter)
% window_size = subject.gsr.filter_window/sample_dist; % 
% subject.gsr.values = zeros(length(values)-window_size,1);
% for k = 1:length(subject.gsr.values)
%     subject.gsr.values(k) = median(values(k:k+window_size));
% end
subject.gsr.values = values;

%% Prepare data for LEDALAB
data = struct();
data.conductance = values;
data.time = subject.gsr.timings;
data.timeoff = 0;

trials = 300;
data.event = repmat(struct(),trials,1);
stims = cell(1,trials);
times = cell(1,trials);
for k = 1:trials/2
    times{k} = subject.behav.relative_times(1,k);
    times{k+150} = subject.behav.relative_times(2,k);
    if metadata.stimuli(k) == 1
        stims{k} = 'neutral';
        stims{k+150} = 'aversive';
    elseif metadata.stimuli(k) == 0
        stims{k} = 'no_neut';
        stims{k+150} = 'no_av';
    end
end
[data.event.name] = stims{:};
[data.event.time] = times{:};

end





function stim_onset_syn = synchronize(stim_onset, delta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synchronizes GSR and behavioral data
%
%   Parameters:
%   -------------
%   STIM_ONSET      {double} [3,1] with stimulus onset time in [h,min,sec]
%   DELTA           {double} [1,1] time delta of system clocks (in ms!)
%
%
%   Returns:
%   -------------
%   STIM_ONSET_SYN  {double} [3,1] corrected time in same format like
%                       original

raw_sec = stim_onset(3) + delta; % Uncorrected (may be > 60)
sec = mod(raw_sec, 60); % second overflow
raw_min = stim_onset(2) + floor(raw_sec/60);
min = mod(raw_min , 60);
raw_hour = stim_onset(1) + floor(raw_min/60);
hour = mod(raw_hour , 24);

stim_onset_syn = [hour;min;sec];

end

function rel_time = time_abs_to_rel(abs_time, baseline)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts an absolute time into a relative one (w.r.t. to an baseline)
% Requires that abs_time is greater (later) than baseline. 
%
%   Parameters:
%   ---------------
%   ABS_TIME        {double} [3x1], absolute time in hh,min,sec
%   BASLINE         {double} [3x1], same format, baseline time (0 in
%                       relative terms)
%
%   Returns:
%   ---------------
%   REL_TIME        {double} [1x1], relative time, in ms w.r.t baseline


if baseline(1) > abs_time(1) || ...
        (baseline(1) == abs_time(1) && baseline(2) > abs_time(2)) || ...
        (baseline(1) == abs_time(1) && baseline(2) == abs_time(2) && ...
         baseline(3) > abs_time(3))
     
     rel_time = -1; % means that abs_time is before baseline.
else

    % sec diff.
    if baseline(3) <= abs_time(3)
        rel_ms = abs_time(3) - baseline(3);
    else
        rel_ms = (60-baseline(3)) + abs_time(3);
        baseline(2) = baseline(2) + 1; % correct minutes
        if baseline(2) > 59
            baseline(3) = baseline(3) + 1; % correct hour when min overflow
            baseline(2) = 0; % reset minutes
        end
    end

    % min diff
    if baseline(2) <= abs_time(2)
        rel_min = abs_time(2) - baseline(2);
    else
        rel_min = (60-baseline(2)) + abs_time(2);
        baseline(1) = baseline(1) + 1; % correct hour  
    end

    if baseline(1) ~= abs_time(1)
        error("Did this experiment really take longer than one hour?")
    end

    rel_time = rel_min*60 + rel_ms;

end