%

fol_name = 'behav_raw';
all = dir(strcat(fol_name,'/*.mat'));

for k = 1:length(all)
    subj_data = load(strcat(fol_name,'/',all(k).name));
    om2(1,k) = subj_data.subj_data.hgfparams.params_neutral.p_prc.om(2);
end
