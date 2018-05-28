fol_name = 'data/behav_analyzed_hgf_concat';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_concat.traj.mu(:,2));
    hold on;
end