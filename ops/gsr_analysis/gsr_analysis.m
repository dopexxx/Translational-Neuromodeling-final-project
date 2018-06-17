%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script runs the GSR preparation pipeline  for Ledalab (basically 
% data synchronization) on all subjects with valid GSR data.
%
% Jannis Born, May 2018

inds = [11,12,13,16];

for ID = inds
  
    % Run pipeline
    [subject,data] = gsr_sync(ID);
    % Save data
    save(['data/gsr_ledalab/subject_',num2str(ID),'_raw.mat'],'data');
    save(['data/gsr_raw/subject_',num2str(ID),'.mat'],'subject');

end


gsr_results();