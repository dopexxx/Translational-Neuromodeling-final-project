function subject = gsr_pipeline(ID)
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


% subject.behav.
% subject.gsr.
% subject.stats.
% subject.hgf.


load(['data/recordings/gsr_',int2str(ID),'.mat'])
%load(['data/recordings/subject_',int2str(ID),'.mat'])
subject.gsr = struct();
subject.gsr.raw_data = gsr_data;

% Let us first synchronize the time stamps from GSR and behavioral data
% and convert timings to relative values.

% The difference between the two clocks used to record the behavioral and
% gsr data (when 2 separate machines were used)
subject.time_delta = 0;

% 1) Define 1 second before the first sound as a RELATIVE time of 0
t = squeeze(subject.stim_onsets(1,1,:))
t(3) = t(3) - 1; % baseline is 1 sec before first sound.
if t(3) < 0
    t(2) = t(2) - 1; % if second underflow, reduce minutes
    if t(2) < 0
        t(1) = t(1) - 1; % if minute underflow, reduce hours
        if t(1) < 0
            error("Houston, we have a problem, s.b. made an overnight experiment");
        end
    end 
end
subject.behav.time_onset = t;


% 2) Convert absolute into relative times
subject.behav.relative_times = zeros(size(subject.stim_onsets));
for k = 1:length(subject.relative_times)
    subject.behav.relative_times(1,k,:) = ...
        time_abs_to_rel(squeeze(subject.stim_onsets(1,k,:)), subject.time_onset);
    
    subject.behav.relative_times(2,k,:) = ...
        time_abs_to_rel(squeeze(subject.stim_onsets(2,k,:)), subject.time_onset);
end 

% 3) 4) Convert SCR times to relative values and add timedelta
subject.gsr.raw_relative_times = zeros(length(scr_data));
for k = 1:length(scr_data)
    t = time_abs_to_rel(scr_data(3:5), subject.behav.time_onset);
    subject.gsr.raw_relative_times(k) = t+timedelta;
end



% GSR PREPROCESSING

% 1) Remove time points before the relative time 0
subject.gsr.raw_relative_times = subject.raw_relative_times(...
    subject.raw_relative_times~=-1+timedelta);
subject.gsr.values = scr_data(1,subject.raw_relative_times~=-1+timedelta);

% Linear interpolation (Nearest Neighbor) in order to have the data sampled
% equidistantly.
interp1(x,v,xq,'nearest');




% Remove tonic component in signal (median filter)
ind = 1;
while subject.gsr.relative_times(ind) < 4000
    ind = ind + 1;
end




% Step 1: Downsampling:
% The data was recorded with a sampling frequency of ca. 65 Hz
% We downsample it to 10 Hz e.g. via NN interpolation (?) %
%TODO

% Step 2: Binarize signal.
% Can be done either with raw or with preprocessed data.
subject.gsr.bin_raw = subject.gsr.raw_data(1,:) > mean(subject.gsr.raw_data(1,:));

%subject.gsr.bin = subject.gsr TODO


% Step 3: Compute PSTH
subject.gsr.psth = struct();

% The borders for the PSTH w.r.t the event and the density of the bins 
% both in ms
borders = [-1000, 3500];
bin_size = 100;
subject.gsr.psth.borders = borders;
subject.gsr.psth.bin_size = bin_size;

%% TIME CONVERSION & SYNCHRONIZATION
% 1) Define offset in relative values (t=0)
% 2) Convert behavioral timestamps
% 3) Convert SCR timesteps and discard t<0 (scr starts before behavior)
% 4) Add timedelta in order to synchronize



    

% For every trial (in both blocks) find the indices of the first relevant
% recording (1000ms prior to tone) and last one (2500ms after tone)
trial_borders_neutral = zeros(2,length(subject.responses));
trial_borders_aversive = zeros(2,length(subject.responses));
ind_n = 1;
ind_a = 1;
for k = 1:length(subject.responses)
    stim_onset_n = squeeze(subject.stim_onsets(1,k,:)); % time 0
    stim_onset_a = squeeze(subject.stim_onsets(2,k,:)); 
    
    stim_onset_n = synchronize(stim_onset_n, subject.time_delta);
    stim_onset_a = synchronize(stim_onset_a, subject.time_delta);
    
    % Neutral
    while subejct.gsr.hours(ind_n) ~= stim_onset_n(1) % Match hour 
        ind_n = ind_n + 1;
    end
    while subject.gsr.mins(ind_n) ~= stim_onset_n(2) % Match minute
        ind_n = ind_n + 1;
    end
    while subject.gsr.secs(ind_n) ~= stim_onset_n(3) % Match second
        ind_n = ind_n + 1;
    end
    
    % Aversive
    while subejct.gsr.hours(ind_a) ~= stim_onset_a(1) % Match hour 
        ind_a = ind_a + 1;
    end
    while subject.gsr.mins(ind_a) ~= stim_onset_a(2) % Match minute
        ind_a = ind_a + 1;
    end
    while subject.gsr.secs(ind_a) ~= stim_onset_a(3) % Match second
        ind_a = ind_a + 1;
    end
    
    

bins_neutral = zeros(2,length(borders(1):bin_size:borders(2)));
% First row are just the relative timings
bins_neutral(1,:) = borders(1):bin_size:borders(2); 
bins_aversive = bins_neutral;

% Compute value of every bin
for k = 1:length(bins)
    
    % Count over all trials
    for n = 1:length(subject.responses)
        
        stim_onset = squeeze(subject.stim_onsets(1,k,:)); % time 0
        
        % Find the 
        l = 1
        while 
            
        
        
        
    end
    
    
end





end



