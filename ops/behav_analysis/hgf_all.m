function hgf_all(default_config)

fol_name = 'data/behav_analyzed_perf';
all = dir(strcat(fol_name,'/*.mat'));
nfailed = 0;

for k = 1:length(all)
   try
    single_subject_HGF_analysis(fol_name,all(k).name,default_config);
   catch
       nfailed = nfailed + 1;
       disp('-------------------------------------------------------------')
       disp('----------------------- ERROR -------------------------------')
       disp('-------------------------------------------------------------')
       continue
   end
end

if nfailed > 0
    fprintf('\nWarning! %d model fits could not be completed.',nfailed);
else
    fprintf('\nAll model fits were completed successfully.')
end
end