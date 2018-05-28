function plot_diff_distribution(default_config)
if default_config
    fol_name = 'data/behav_analyzed_hgf';
else
    fol_name = 'data/behav_analyzed_hgf_newpriors';
end
figure;
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_aversive.traj.mu(:,2)-subject.hgf.sim_neutral.traj.mu(:,2));
    hold on;
end
title('Aversive (minus) Neutral');
end