function hgf_all(default_config)

fol_name = 'data/behav_analyzed_perf';
all = dir(strcat(fol_name,'/*.mat'));

for k = 1:length(all)
   single_subject_HGF_analysis(fol_name,all(k).name,default_config);
end
end