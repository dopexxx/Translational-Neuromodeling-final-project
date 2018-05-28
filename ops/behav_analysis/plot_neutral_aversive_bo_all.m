function plot_neutral_aversive_bo_all(default_config)
if default_config
    fol_name = 'data/behav_analyzed_hgf';
else
    fol_name = 'data/behav_analyzed_hgf_newpriors';
end
figure
fol_name = 'data/behav_analyzed_hgf';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_neutral.traj.mu(:,2));
    hold on;
    plot(subject.hgf.sim_aversive.traj.mu(:,2));
    hold on;
    plot(subject.hgf.sim_bo.traj.mu(:,2));
    hold off;
    legend('Neutral','Aversive','Bayes-optimal')
    title(strcat('Subject ID',num2str(subject.ID)))
    pause(2);
end
end