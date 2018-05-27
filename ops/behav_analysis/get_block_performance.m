fol_name = 'data/behav_w_css';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    performance_analysis(fol_name,all(k).name);
    disp('ja')
end
disp('Blockwise performances written to subject structs.')