%% Script to compare 3 Level HGF and 2 Level HGF
% Take 9 for high volatility in 3rd layer
load('data/behav_analyzed_hgf_newpriors/subject_18.mat');
HGF_input_seq =  subject.behav.css.input;
HGF_output_seq_neutral = subject.behav.css.response_neutral;
config = 'tapas_hgf_binary_2level_config'; 
x = subject.behav.css.input; % cue-stimulus-contingency

%% 3level

params_3 = tapas_fitModel(HGF_output_seq_neutral,... % observations; here: empty.
                         HGF_input_seq,... % input
                         'tapas_hgf_binary_config',... % perceptual model
                         'tapas_unitsq_sgm_config',... % response model
                         'tapas_quasinewton_optim_config'); % opt. algo  

%
sim_3 = tapas_simModel(HGF_input_seq,... % data
                     'tapas_hgf_binary',... % perceptual model
                     params_3.p_prc.p,... % NaN, -2.5, -6 = omegas
                     'tapas_unitsq_sgm',... % response model: unit square sigmoid
                     5) % zeta parameter  
                 
%%                
params_2 = tapas_fitModel(HGF_output_seq_neutral,... % observations; here: empty.
                         HGF_input_seq,... % input
                         config,... % perceptual model
                         'tapas_unitsq_sgm_config',... % response model
                         'tapas_quasinewton_optim_config'); % opt. algo  


sim_2 = tapas_simModel(HGF_input_seq,... % data
                     'tapas_hgf_binary_2level',... % perceptual model
                     params_2.p_prc.p,... % NaN, -2.5, -6 = omegas
                     'tapas_unitsq_sgm',... % response model: unit square sigmoid
                     5) % zeta parameter  
                 
                 
                 
%% Fit the trajectory of the 3 Layer HGF with the alpha model
y=sigm(sim_3.traj.mu(:,2));

pi_prior = 2:0.02:15;
alphas = 0.001:0.01:1;
errors_3 = zeros(length(alphas),length(pi_prior));
for p = 1:length(pi_prior)
    p
    prior = pi_prior(p);
    for a = 1:length(alphas)
        alpha = alphas(a);
        mus = simulate_learning(x, prior, mu_prior, alpha);
        errors_3(a,p) = sum((mus - y').^2);
    end
end
[err, ind] = min(errors_3(:))
[r,c] = ind2sub(size(errors_3),ind);
alpha_3 = alphas(r)
prior_3 = pi_prior(c)

%% Fit the trajectory of the 2 Layer HGF with the alpha model
y=sigm(sim_2.traj.mu(:,2));

pi_prior = 2:0.02:15;
alphas = 0.001:0.01:1;
errors_2 = zeros(length(alphas),length(pi_prior));
for p = 1:length(pi_prior)
    p
    prior = pi_prior(p);
    for a = 1:length(alphas)
        alpha = alphas(a);
        mus = simulate_learning(x, prior, mu_prior, alpha);
        errors_2(a,p) = sum((mus - y').^2);
    end
end
[err, ind] = min(errors_2(:))
[r,c] = ind2sub(size(errors_2),ind);
alpha_2 = alphas(r)
prior_2 = pi_prior(c)

%% Plot 2 level vs 3 level HGF traces
figure
plot(sigm(sim_2.traj.mu(:,2))); hold on;
plot(sigm(sim_3.traj.mu(:,2)));
plot(sigm(sim_3.traj.mu(:,3)))

legend('2 layer','3 layer','3rd level');


%% Plotting error surfacce of alphas

[X,Y] = ndgrid(pi_prior,alphas);
figure
mesh(X,Y,errors_3')
xlabel('pi_prior'); ylabel('alphas');
title('Error function for 3 Layer HGF')

figure
mesh(X,Y,errors_2')
xlabel('pi_prior'); ylabel('alphas');
title('Error function for 2 Layer HGF')

%% Compute Alpha traces
pi_llh = 1;
mu_prior = 0.5;

mu_alpha_3 = alpha_model(alpha_3,x, prior_3, pi_llh, mu_prior);
mu_alpha_2 = alpha_model(alpha_2,x, prior_2, pi_llh, mu_prior);

%% Plot HGF vs their fits
figure
plot(sigm(sim_2.traj.mu(:,2))); hold on;
plot(sigm(sim_3.traj.mu(:,2)));
plot(mu_alpha_2);
plot(mu_alpha_3);

legend('2 layer','3 layer','Alpha-fit-2', 'Alpha-fit-3');
