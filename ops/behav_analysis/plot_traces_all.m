function plot_traces_all(default_config)
if default_config
    fol_name = 'data/behav_analyzed_hgf';
else
    fol_name = 'data/behav_analyzed_hgf_newpriors';
end
figure
all = dir(strcat(fol_name,'/*.mat'));
subplot(2,2,3);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(sigm(subject.hgf.sim_neutral.traj.mu(:,2)));
    hold on;
end
title('\mu_2 (neutral)')
subplot(2,2,1);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_neutral.traj.mu(:,3));
    hold on;
end
subplot(2,2,4);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(sigm(subject.hgf.sim_aversive.traj.mu(:,2)));
    hold on;
end
title('\mu_2 (aversive)')

subplot(2,2,2);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_aversive.traj.mu(:,3));
    hold on;
end
title('\mu_3 (aversive)')
end
