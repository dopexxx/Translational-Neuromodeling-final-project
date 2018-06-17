function gsr_resp = infer_gsr_resp(ID,can_corr,can_wrong)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function computing the mean response w.r.t. some mode of our experiment.
%
% Parameters:
% -------------
%   ID          {int} ID of the subject
%   CAN_CORR    {double} canonical SCR response for trials without PE
%   CAN_WRONG   {double} canonical SCR response for trials with PE
%
%
% Returns:
% -------------
% GSR_RESP      {double} belief about occurrence of sound in every trial
%                   inferred from SCR data only.
%
% Jannis Born, May 2018

load(['data/gsr_ledalab/subject_',num2str(ID),'_post.mat'])
load(['data/gsr_results/subject_',num2str(ID),'.mat'])

load('data/metadata.mat');


resp_onset = 1;  % 1000ms after stimulus onset
resp_offset = 4.5; % to 4500ms after stimulus onset 
sf = 50; % sampling frequency is 50 Hz


% Array containing the binary responses inferred from SCR data.
gsr_resp = zeros(300,1);
gsr_index = 1;

% Workaround for subject 8
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
    %trial_resp = trial_resp/max(trial_resp);
    
    ind = mod(trial_ind,150);
    if ind == 0 
        ind = 150;
    end
    
    % Compare trial response to canonical response
    if sqrt(sum((trial_resp-can_corr).^2)) < sqrt(sum((trial_resp-...
            can_wrong).^2))        
        gsr_resp(trial_ind) = metadata.stimuli(ind);
    else
        gsr_resp(trial_ind) = ~metadata.stimuli(ind);
        
    end
    
    gsr_index = gsr_index + 1;

end

gsr_resp = reshape(gsr_resp,2,150);


end

