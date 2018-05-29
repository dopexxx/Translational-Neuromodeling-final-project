%function subject = gsr_pipeline(ID)
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
%
%       Jannis Born, May 2018

clear;
% subject.behav.
% subject.gsr.
% subject.stats.
% subject.hgf.
ID = 12;

load(['data/recordings/gsr_',int2str(ID),'.mat'])
load(['data/behav_analyzed_hgf/subject_',int2str(ID),'.mat'])
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

% 1) Define 10 second before the first sound as a RELATIVE time of 0
t = squeeze(subject.behav.raw.stim_onsets(1,1,:));
t(3) = t(3) - 10; % baseline is 1 sec before first sound.
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


% 2) Convert absolute into relative times
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

% 2) Remove the times from 20 sec after the last sound
time_offset = subject.behav.relative_times(end,end) + 20;
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
window_size = subject.gsr.filter_window/sample_dist; % 
subject.gsr.values = zeros(length(values)-window_size,1);
for k = 1:length(subject.gsr.values)
    subject.gsr.values(k) = median(values(k:k+window_size));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Now the analysis can begin.
% We look at 
%   1) The mean median-filtered SCR response for both blocks (neutral/aversive)
%   2) The PSTH of both blocks

% defines window of interest for 1) and 2)
resp_onset = 1;  % 1000ms before stimulus
resp_offset = 3.5; % to 3500ms after stimulus

% 1) Collect all response windows and average
neutral_resp = zeros(length(subject.behav.raw.stim_onsets),...
    length(-1*resp_onset:sample_dist:resp_offset));
aversive_resp = zeros(size(neutral_resp));

for k = 1:length(subject.behav.raw.stim_onsets)
    [t,neutral_ind] = min(abs(subject.behav.relative_times(1,k) - ...
        subject.gsr.timings));
    [t,aversive_ind] = min(abs(subject.behav.relative_times(2,k) - ...
        subject.gsr.timings));
    neutral_resp(k,:) = subject.gsr.values(neutral_ind-resp_onset ...
        /sample_dist : neutral_ind+resp_offset/sample_dist);
    aversive_resp(k,:) = subject.gsr.values(aversive_ind-resp_onset ...
        /sample_dist : aversive_ind+resp_offset/sample_dist);
end
%subject.gsr.neutral_sound_resp = mean(neutral_resp,1);
%subject.gsr.aversive_sound_resp = mean(aversive_resp,1);
rat_stim = mean(metadata.stimuli);
subject.gsr.neutral_sound_resp = 1/rat_stim * mean(neutral_resp.*metadata.stimuli,1);
subject.gsr.aversive_sound_resp = 1/rat_stim * mean(aversive_resp.*metadata.stimuli,1);
subject.gsr.neutral_no_sound_resp = 1/(1-rat_stim) * mean(neutral_resp.*~metadata.stimuli,1);
subject.gsr.aversive_no_sound_resp = 1/(1-rat_stim) * mean(aversive_resp.*~metadata.stimuli,1);



% 2) Compute PSTH, i.e. binarize signal
subject.gsr.psth = struct();
subject.gsr.bin_values = subject.gsr.values > mean(subject.gsr.values);


% The borders for the PSTH w.r.t the event and the density of the bins 
bin_size = 0.1;
subject.gsr.psth.borders = [-1*resp_onset, resp_offset];
subject.gsr.psth.bin_size = bin_size;


bins_neutral = zeros(length(-1*resp_onset:bin_size:resp_offset),1);
bins_aversive = bins_neutral;

% Compute value of every bin
for k = 1:length(subject.behav.raw.stim_onsets)
    
    [t,neutral_ind] = min(abs(subject.behav.relative_times(1,k) - ...
        subject.gsr.timings));
    [t,aversive_ind] = min(abs(subject.behav.relative_times(2,k) - ...
        subject.gsr.timings));
    
    bins_neutral = bins_neutral + subject.gsr.bin_values(neutral_ind-...
        resp_onset/bin_size : neutral_ind+resp_offset/bin_size);
    bins_aversive = bins_aversive + subject.gsr.bin_values(aversive_ind-...
        resp_onset/bin_size : aversive_ind+resp_offset/bin_size);
end
        
subject.gsr.psth.neutral = bins_neutral/length(subject.behav.raw.responses);
subject.gsr.psth.aversive = bins_aversive/length(subject.behav.raw.responses);
%end


%% TODO:
% Think about a better way of preprocessing/filtering
% Make a more clever binarization than the current binarization
% Get one binary value PER TRIAL (by averaging over the window and > 0.5)
% -> Feed into GSR
% Look into other GSR features
% Function plotting all the results
% Rename files and delete doubles
% Mean response -> Dot product with sound vectors!

% gsr_plotting(); 


