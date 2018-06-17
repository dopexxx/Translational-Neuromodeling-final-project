load('/Users/jannisborn/Dropbox/GitHub/TNM_project/data/behav_analyzed_hgf_newpriors/subject_18.mat')

x = subject.behav.css.input; % cue-stimulus-contingency
%y = subject.behav.css.response_aversive;
%HGF_input_seq = sigm(subject.hgf.sim_neutral.traj.mu(:,2));
%y = HGF_input_seq;
y=sigm(sim_2.traj.mu(:,2));

%%
clc
pi_llh = 1;
pi_prior = 15;
mu_prior = 0.5;

dec = @(x) exp(x)./(exp(x)+1);
diff = @(x) dec(x).*(1-dec(x));

[alphas, first] = optimize_alpha(x,y,pi_llh,pi_prior,mu_prior,dec,diff);

[grad, ind] = min(abs(first))
alpha_j = alphas(ind)
invalid = find(isnan(y));
y(invalid)=[];
x(invalid)=[];

% for a = 1:length(alphas)
%     alpha = alphas(a);
%     mus = alpha_model(alpha, x, pi_prior, pi_llh, mu_prior);
%     errors(a) = sum((mus - y).^2);
% end
% [err, ind] = min(errors)
% alpha = alphas(ind)
%%
pi_prior = 2:0.02:15;

alphas = 0.001:0.01:1;
errors = zeros(length(alphas),length(pi_prior));
for p = 1:length(pi_prior)
    p
    prior = pi_prior(p);
    for a = 1:length(alphas)
        alpha = alphas(a);
        mus = simulate_learning(x, prior, mu_prior, alpha);
        errors(a,p) = sum((mus - y').^2);
    end
end
[err, ind] = min(errors(:))
[r,c] = ind2sub(size(errors),ind);
alpha = alphas(r)
prior = pi_prior(c)

%% 

[X,Y] = ndgrid(pi_prior,alphas);
figure
mesh(X,Y,errors')
xlabel('pi_prior'); ylabel('alphas');


%%
figure
fill3([0,1,2],[18.5,19.5,20],[0,0,0],'-r'); hold on;
plot3(alphas,errors,e);
xlabel('Alphas'); ylabel('Forward model absolute error'); zlabel('Gradient');

%% 
alpha_opt = alpha;
alpha_dev = alpha_j;

mu_a_opt_l = alpha_model(alpha_opt,x, prior, pi_llh, mu_prior);
%mu_a_opt_j = alpha_model(alpha_dev,x, pi_prior, pi_llh, mu_prior);
%%
figure
plot(sigm(sim_2.traj.mu(:,2))); hold on;
plot(sigm(sim_3.traj.mu(:,2)));
%plot(mu_a_opt_l)
plot(sigm(sim_3.traj.mu(:,3)))

legend('2 layer','3layer','3rd level');

%%
close all
plot(y); hold on;
plot(mu_a_opt_l);
plot(mu_a_opt_j);
legend('HGF','L_opt','J_opt')

%%
figure
plot(alphas,errors); hold on;
plot(alphas, first);

legend('Errors','First Derivative');
