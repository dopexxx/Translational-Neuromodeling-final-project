function [error_change,alphas] = optimize_alpha(x,y,pi_llh,pi_prior,mu_prior)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function finds the optimal alpha value for the suboptimal Bayesian
% regression model
%
%   Parameters:
%   --------------
%       X        {double} [n x 1] stimuli (sound, no sound) encoded in the
%                   cue-stimulus-contingency space (binary string)
%       Y        {double} [n x 1] Response to fit (e.g. behavioral binary 
%                   string or HGF belief.
%       PI_LLH   {double} 1x1, likelihood precision (the same for all
%                   samples)
%       PI_PRIOR {double} 1x1, prior precision 
%       MU_PRIOR {double} 1x1, prior mean
%
%
%   Returns:
%   -------------
%       ALPHA     Optimal hyperparameter for the generative model
%       ERR       Absolute error w.r.t. OLS metric


% Initialize some parameter
invalid = find(isnan(y));
y(invalid) = [];
x(invalid) = [];
n = length(x);           % amount of valid trials
alphas = 0.1:0.001:2;    % density of optimization grid
error_change = zeros(length(alphas),1);

% Specify forward model
pi_post_fc = @(alpha) pi_prior : alpha*pi_llh : pi_prior+alpha*pi_llh*n;
mean_post_fc = @compute_mean_post;
sigmoid = @(mu) exp(mu)./(exp(mu)+1);

% Compute derivatives (those that do not depend on alpha)
dsig_dmu = @(mu) exp(mu)./(exp(mu)+1).^2;
dpi_dalph = [0:n] * pi_llh;

% For every value of alpha
for a = 1:length(alphas)
    
    alpha = alphas(a);
    pi_post = pi_post_fc(alpha);
    mean_post = mean_post_fc(mu_prior,pi_post,x);
    dmuk_dalph = zeros(n+1,1);
    
    
    for k = 2:n-invalid+1
        dmuk_dalph(k) = dmuk_dalph(k-1) - (dmuk_dalph(k-1)*pi_post(k) + ...
            dpi_dalph(k) * (x(k-1)-mean_post(k-1))) / pi_post(k)^2;
        % x is indexed at k-1 since the k-th observation is saved at
        % position k-1 in x.
    end
    
    error_change(a) = (2.*dsig_dmu(mean_post).*dmuk_dalph)' * [0;y] + ...
        (dsig_dmu(mean_post).*dmuk_dalph)' * sigmoid(mean_post) + ...
        sigmoid(mean_post)' * (dsig_dmu(mean_post).*dmuk_dalph);
    
end

% Find the minimal value
[grad, ind] = min(error_change);
alpha = alphas(ind);


function mu_k = compute_mean_post(mu_pri,pi_po,x)
   % Function to compute forward model about belief mu_k
   % I.e. a vector of mu_k for a particular alpha, prior and input
   
   n = length(x);
   mu_k = zeros(n+1,1);
   mu_k(1) = mu_pri;
   for k = 2:n+1
       mu_k(k) = mu_k(k-1) + (1/pi_po(k)) * (x(k-1) - mu_k(k-1));
   end
       
    
end

end

