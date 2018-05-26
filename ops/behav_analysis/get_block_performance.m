fol_name = 'data/behav';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    single_subject_analysis(fol_name,all(k).name);
end