%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (A) DATA ORGANIZATION
%% Make directories
manage_directories();

%% Reorganize data structures
reorganize();

%% Encode cue-stimulus-contingencies
css_encoding();

%% Reject subjects with too many invalid trials
count_irrs()

%% (B) PERFORMANCE ANALYSIS
%% Perform block performance analysis
get_block_performance();

%% Plot block performance
plot_blockperformance();

%% Calculate and plot average block responses
avg_block_performance(); % ToDo: make merged histograms


%% (C) HGF ANALYSIS
%% Fit HGFs and simulate HGF traces; store all data for later analysis
default_config = 2; % only fix omega3 (var = 0)
hgf_all(default_config);
%hgf_all(0);

%% Analysis and plot of parameter fit
parameter_plot(default_config);

%% Manual trace assessment
plot_traces_all(default_config);

%% Plot neutral, aversive, and BO mu_2 traces for all subjects
plot_neutral_aversive_bo_all(default_config);

%% Plot distribution of differences in mu_2 traces aversive-neutral
plot_diff_distribution(default_config);

%% Extract HGF input sequence
load(all(1).name); HGF_input_seq = subject.behav.css.input;

%% (D) GSR Analysis
%gsr_analysis();



%% (E) Alpha model% not pretty yet. 
%% Easy exploration: HGF vs Alpha sigm(mu_2) = mu_1 plot
% Specify: [subject_folder_id, prior for alphamodel, alpha for alphamodel)
k = 7; prior = 7.5; alpha_param = 0.68; 
figure; plot_hgf_vs_alphamodel(default_config, k, prior, 0.5, alpha_param);

%% Synthetic data

load('subject_11.mat')
HGF_input_seq =  subject.behav.css.input;
sim_testing = tapas_simModel(HGF_input_seq,... % data
                     'tapas_hgf_binary',... % perceptual model
                     [NaN 0 1 NaN 1 1 NaN 0 0 1 1 NaN -3 -6],... % NaN, -2.5, -6 = omegas
                     'tapas_unitsq_sgm',... % response model: unit square sigmoid
                     5); % zeta parameter   
                 
                 
                 
                 

%% Manual optimization experiment: modelling subjects
if default_config
    fol_name = 'data/behav_analyzed_hgf';
else
    fol_name = 'data/behav_analyzed_hgf_newpriors';
end
all = dir(strcat(fol_name,'/*.mat'));
k = 5;
load(strcat(fol_name,'/',all(k).name));
    
optim_surface = zeros(96,96);
p_c = 0;
subj_response_neutral = subject.behav.css.response_neutral;
for prior = linspace(1,4,96) % prior
        p_c = p_c+1;
        l_c = 0; 
    for l = linspace(0.01,2,96) % alpha
        l_c = l_c+1;
        a = simulate_learning( HGF_input_seq, prior, l);
        optim_surface(p_c,l_c) = 150- sum(subj_response_neutral'==round(a));
    end
end                 
                                
%%
plot(sigm(sim_testing.traj.mu(:,2)));
ylim([0 1]);
optim_surface = zeros(96,96);
hold on
for prior = [6.2105]
    for l = [0.7268]
        a = simulate_learning( HGF_input_seq, prior, 0.5, l);
        plot(a);
    hold on;
    end
end
hold off;
legend('HGF','Alpha')



%% ______ GOOD
figure
x = linspace(1,4,96) ;         % The range of x values.
y = linspace(0.01,2,96)         % The range of y values.
[X,Y] = meshgrid (x,y); % This generates the actual grid of x and y values
Z=optim_surface            % The function we're plotting.
% Remember to use the correct vector notation for all operations (such as
% using the '.^' operator to do piecewise powers).
surf(X,Y,Z)             % The surface plotting function.

[min_val,idx]=min(optim_surface(:))
[row,col]=ind2sub(size(optim_surface),idx)

optim_surface(row,col);
x(row)
y(col)



%% Alpha model with non-constant alpha
%plot(sigm(sim_neutral.traj.mu(:,2)));
%optim_surface = zeros(96,96);
%hold on;
%p_c = 0;
%for m = linspace(-.01,.01,96) %m
%        disp(p_c)
%        p_c = p_c+1;
%        l_c = 0; 
%    for alphahere = linspace(0.01,0.5, 96) %alpha
%        l_c = l_c+1;
%        a = simulate_learning_m( HGF_input_seq, 1.27, alphahere, m);
%        a = a(2:end);
%        optim_surface(p_c,l_c) = sum((sigm(sim_neutral.traj.mu(:,2))'-a).^2);
%    end
%end%
