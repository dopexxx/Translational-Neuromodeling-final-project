load('/Users/jannisborn/Dropbox/GitHub/TNM_project/data/behav_analyzed/subject_8.mat')

x = subject.behav.css.input;
y = subject.behav.css.response_neutral;
pi_llh = 1;
pi_prior = 3;
mu_prior = 0.5;

[e,alphas] = optimize_alpha(x,y,pi_llh,pi_prior,mu_prior);

[grad, ind] = min(abs(e))
alpha = alphas(ind)

invalid = find(isnan(y));
y(invalid)=[];
x(invalid)=[];
errors = zeros(length(alphas),1);

for a = 1:length(alphas)
    alpha = alphas(a);
    mus = alpha_model(alpha, x, pi_prior, pi_llh, mu_prior);
    errors(a) = sum((mus - y).^2);
end
[e, ind] = min(errors)
alpha = alphas(ind)

