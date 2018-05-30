function [mean1, mean2] = mean_comp(ID,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function computing the mean response w.r.t. some mode of our experiment.
%
% Parameters:
% -------------
%   ID          {int} ID of the subject
%   INDS        {logical} [trials x 1] indicating which
%   MODE        {'sound', 'block', 'nosound', 'PE','correct'} specifies the 
%                   criteria
%                   along which the trials are blocked. Sound returns
%                   neutral vs aversive, block returns block1 vs block2,
%                   nosound returns nosound_block1 vs nosound_block2,
%                   correct returns correct against wrong trials,
%                   PE
%                   returns trials with prediction error (wrong trials)
%                   against correct trials.
%
% Returns:
% -------------
% MEAN1        {double} [samp_per_trial x 1], i.e. mean response to first
%                    stimulus type
% MEAN2        {double} [samp_per_trial x 1], i.e. mean response to second
%                    stimulus type
%
% Jannis Born, May 2018

load(['data/gsr_ledalab/subject_',num2str(ID),'_post.mat'])
load(['data/gsr_results/subject_',num2str(ID),'.mat'])

load('data/metadata.mat');


resp_onset = 1;  % 1000ms after stimulus onset
resp_offset = 4.5; % to 4500ms after stimulus onset 
sf = 50; % sampling frequency is 50 Hz
samp_per_trial = length(resp_onset:1/sf:resp_offset);

trials = [150,150]; % trials per block
% Some trials removed in subject 12
if ID == 12
    trials(1) = trials(1) - 7;
end

%% Building the stimulus vector 
if strcmp(mode,'sound')
    % Test neutral vs aversive stimulus
    inds = zeros(sum(trials),1);
    for k = 1:length(data.event)
        if strcmp(data.event(k).name, 'neutral')
            inds(k) = 1; % neutral encoded by a 1
        elseif strcmp(data.event(k).name, 'aversive')
            inds(k) = 2;
        end
    end
elseif strcmp(mode,'block')
    % Comparing response of first vs second block
    inds = [ones(trials(1),1);2*ones(trials(2),1)];
elseif strcmp(mode,'nosound')
    inds = zeros(sum(trials),1);
    for k = 1:length(data.event)
        if strcmp(data.event(k).name, 'no_neut')
            inds(k) = 1; % no neutral sound encoded by a 1
        elseif strcmp(data.event(k).name, 'no_av')
            inds(k) = 2;
        end
    end
elseif strcmp(mode,'correct')
    % Trials with correct responses against wrong ones
    inds = subject.behav.raw.responses(1,:) == metadata.stimuli';   
    inds = [inds, subject.behav.raw.responses(1,:) == metadata.stimuli'];
    inds = inds + 1;
    
    if ID == 4
        inds(1:7) = [];
    end
end


if strcmp(mode,'block') || strcmp(mode,'sound') || strcmp(mode,'nosound') ...
        ||   strcmp(mode,'correct')
    
        
    
    trials1 = zeros(length(find(inds==1)),samp_per_trial);
    trials2 = zeros(length(find(inds==2)),samp_per_trial);
    count1 = 0;
    count2 = 0;


    for k = 1:sum(trials)
        trial_onset = data.event(k).time; % ms precise sound onset

        % index of the nearest SCR sample
        sample_ind_onset = find(round(data.time*sf)/sf==...
            round(trial_onset*sf)/sf);
        % indices to crop the stimulus specific response
        bin_on = sample_ind_onset + sf*resp_onset; 
        bin_off = sample_ind_onset + sf*resp_offset;

        if inds(k) == 1
            count1 = count1+1;
            trials1(count1,:) = analysis.phasicData(bin_on:bin_off);
        elseif inds(k) == 2
            count2 = count2+1;
            trials2(count2,:) = analysis.phasicData(bin_on:bin_off);
        end
    end
    mean1 = mean(trials1,1);
    mean2 = mean(trials2,1);
    
elseif strcmp(mode,'PE')
    % For this mode we test the hypothesis that peaks in the GSR signal
    % correspond to prediction errors. We compute the trial-wise mean and
    % compare it to the mean of all trials to get a binary value (PE or
    % not). 
    % We correlate the resulting PE-trace with the HGF-PE trace and then
    % fit a HGF based on the hypothetical responses that were given if the
    % binary signal indeed corresponded to a prediction error.
    
    % compute mean of all trials
    means = zeros(sum(trials),1);
    for k = 1:sum(trials)
        trial_onset = data.event(k).time; % ms precise sound onset
        % index of the nearest SCR sample
        sample_ind_onset = find(round(data.time*sf)/sf==...
            round(trial_onset*sf)/sf);
        % indices to crop the stimulus specific response
        bin_on = sample_ind_onset + sf*resp_onset; 
        bin_off = sample_ind_onset + sf*resp_offset;
        means(k) = mean(analysis.phasicData(bin_on:bin_off));
        
    end
    m = mean(means);
    
    PEs = zeros(sum(trials),1);
    for k = 1:sum(trials)
        trial_onset = data.event(k).time; % ms precise sound onset
        % index of the nearest SCR sample
        sample_ind_onset = find(round(data.time*sf)/sf==...
            round(trial_onset*sf)/sf);
        % indices to crop the stimulus specific response
        bin_on = sample_ind_onset + sf*resp_onset; 
        bin_off = sample_ind_onset + sf*resp_offset;
        if mean(analysis.phasicData(bin_on:bin_off)) > m
            PEs(k) = 1;       
        end
            
    end
    
    mean1 = PEs;
    mean2 = [];
end





end

