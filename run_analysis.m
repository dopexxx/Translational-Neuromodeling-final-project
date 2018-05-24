%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runs analysis. All subroutines are called from here.
%
% Lukas Vogelsang, May 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (A) DATA ORGANIZATION
%% Reorganize data structures
reorganize();

%% Encode cue-stimulus-contingencies
css_encoding();

%% Reject subjects


%% (B) PERFORMANCE ANALYSIS
%% Perform block performance analysis
get_block_performance();

%% Plot block performance
plot_blockperformance();

%% Calculate and plot average block responses
avg_block_performance();


%% (C) MODEL-BASED ANALYSIS: HGF
%% Fit HGFs and simulate HGF traces; store all data for later analysis
hgf_all();

%% Analysis and plot of parameter fit
parameter_plot();

%% Analysis of parameter correlation

%% Analysis of parameter estimation reliability

%% Analysis of traces
fol_name = 'data/behav_analyzed_hgf';
all = dir(strcat(fol_name,'/*.mat'));
k = 3

load(strcat(fol_name,'/',all(k).name));
tapas_hgf_binary_plotTraj(subject.hgf.sim_neutral);
tapas_hgf_binary_plotTraj(subject.hgf.sim_aversive);
%%
fol_name = 'data/behav_raw';
all = dir(strcat(fol_name,'/*.mat'));
k = 4
    load(strcat(fol_name,'/',all(k).name));
    subject = compute_score(subject);
    disp(subject.scores)


%% Manual trace calculation
fol_name = 'data/behav_analyzed_hgf';
all = dir(strcat(fol_name,'/*.mat'));
subplot(2,2,3);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_neutral.traj.mu(:,2));
    hold on;
end
title('\omega_2')
subplot(2,2,1);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_neutral.traj.mu(:,3));
    hold on;
end
title('\omega_3')
ylim([.99 1.01])
subplot(2,2,4);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_aversive.traj.mu(:,2));
    hold on;
end
title('\omega_2')
ylim([-1 3])
subplot(2,2,2);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_aversive.traj.mu(:,3));
    hold on;
end
title('\omega_3')
ylim([.99 1.01])
%% Both plots
fol_name = 'data/behav_analyzed_hgf';
all = dir(strcat(fol_name,'/*.mat'));
k = 3    
load(strcat(fol_name,'/',all(k).name));
plot(subject.hgf.sim_bo.traj.mu(:,2));


%%
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
    pause(3);
end

%% Difference plots
fol_name = 'data/behav_analyzed_hgf';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    plot(subject.hgf.sim_aversive.traj.mu(:,2)-subject.hgf.sim_neutral.traj.mu(:,2));
    hold on;
end
title('Aversive vs. Neutral');

%% (D) GSR ANALYSIS




