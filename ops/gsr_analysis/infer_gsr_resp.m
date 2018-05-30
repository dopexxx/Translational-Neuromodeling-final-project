function gsr_resp = infer_gsr_resp(ID,can_corr,can_wrong)
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



gsr_resp = zeros(300,1);
gsr_index = 1;

if ID == 12
    trial_onset = 8;
    gsr_resp(1:7) = subject.behav.raw.responses(1,1:7);
else
    trial_onset = 1;
end



for trial_ind = trial_onset:300
    trial_onset = data.event(gsr_index).time; % ms precise sound onset

    % index of the nearest SCR sample
    sample_ind_onset = find(round(data.time*sf)/sf==...
        round(trial_onset*sf)/sf);
    bin_on = sample_ind_onset + sf*resp_onset; 
    bin_off = sample_ind_onset + sf*resp_offset;

    trial_resp = analysis.phasicData(bin_on:bin_off);
    
    ind = mod(trial_ind,150);
    if ind == 0 
        ind = 150;
    end
    
    if dot(trial_resp,can_corr) > dot(trial_resp, can_wrong)
        
        gsr_resp(trial_ind) = metadata.stimuli(ind);
    else
        gsr_resp(trial_ind) = ~metadata.stimuli(ind);
        
    end
    
    gsr_index = gsr_index + 1;

end

gsr_resp = reshape(gsr_resp,2,150);

end

