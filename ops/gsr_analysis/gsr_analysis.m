%function a = gsr_analysis()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function runs the GSR preprocessing pipeline on all subjects with valid
% GSR data.
%
% Jannis Born, May 2018

inds = [11,12,13,16];

for ID = inds
  
    % Run pipeline
    [subject,data] = gsr_preprocessing(ID);
    % Save data
    save(['data/gsr_ledalab/subject_',num2str(ID),'_raw.mat'],'data');
    save(['data/gsr_raw/subject_',num2str(ID),'.mat'],'subject');
    
    % The final step of preprocessing was the Continuous Decomposition 
    % Analysis (CDA) which was done in the LEDALAB GUI. This generated a 
    % phasic component of identical length like the raw data. All analysis
    % is performed based on that data.
    
    % Unfortunately, we had to cut the first 7 trials from subject 12 due
    % to high noise level.

end

%end

