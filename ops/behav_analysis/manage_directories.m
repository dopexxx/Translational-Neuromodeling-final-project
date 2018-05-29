current = pwd;
if ~strcmp(current(end-10:end),'TNM_project')
    disp('Wrong directory!')
else
    folders = {'behav_w_css','behav_analyzed_perf','behav_analyzed_hgf',...
               'behav_analyzed_hgf_newpriors'};
    for i=1:4
        if ~isfolder(strcat('data/',folders{i}))
            mkdir(strcat('data/',folders{i}));
        end
    end
    disp('Directories are ready!')
end