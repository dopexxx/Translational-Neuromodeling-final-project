function a = gsr_analysis()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function runs the GSR analysis pipeline on all subjects with valid
% GSR data.
%
% Jannis Born, May 2018

inds = [4,11,12,13,16];

for k = inds
    load(['data/recordings/gsr_',num2str(k),'.mat']);
    load(['data/behav_analyzed_hgf/subject_',int2str(ID),'.mat'])
    
    % Run pipeline
    subject = gsr_pipeline(scr_data,subject);
    % Save data
    save(['data/gsr_analyzed/subject',num2str(k),'.mat'],subject);

end

