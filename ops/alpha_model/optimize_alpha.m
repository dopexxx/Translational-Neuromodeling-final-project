function [alphas, first_dev] = optimize_alpha(x,y,pi_llh,pi_prior,...
    mu_prior, dec_fct, diff_dec_fct)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function finds the optimal alpha value for the suboptimal Bayesian
% regression model
%
%   Parameters:
%   --------------
%       X           {double} [n x 1] stimuli (sound, no sound) encoded in the
%                       cue-stimulus-contingency space (binary string)
%       Y           {double} [n x 1] Response to fit (e.g. behavioral binary 
%                       string or HGF belief.
%       PI_LLH      {double} 1x1, likelihood precision (the same for all
%                       samples)
%       PI_PRIOR    {double} 1x1, prior precision 
%       MU_PRIOR    {double} 1x1, prior mean
%       DEC_FCT     {function handle, []} optional, a decision function for
%                       the forward model.
%       DIFF_DEC_FCT {function handle, []} optional, the differential of
%                       the decision function
%
%
%   Returns:
%   -------------
%       ALPHA     Optimal hyperparameter for the generative model
%       ERR       Absolute error w.r.t. OLS metric

if (isempty(dec_fct) && ~isempty(diff_dec_fct)) || (isempty(diff_dec_fct)...
        && ~isempty(dec_fct))
    error(['Please either hand over a decision function and its ' ...
        'derivative, or hand over no decision function at all']);
elseif isempty(dec_fct) && isempty(diff_dec_fct)
    function_mode = 0;
else
    function_mode = 1;
end
    


% Initialize some parameter
invalid = find(isnan(y));
y(invalid) = [];
x(invalid) = [];
n = length(x);           % amount of valid trials
alphas = 0.1:0.001:2;    % density of optimization grid
first_dev = zeros(length(alphas),1);

% Compute derivatives (those that do not depend on alpha)
dpi_dalph = @(k) k * pi_llh;

% For every value of alpha
for a = 1:length(alphas)
    
    alpha = alphas(a);
    
    % Compute forward model
    [mu_post, pi_post] = alpha_model(alpha,x,pi_prior,pi_llh,mu_prior);
    mu_post = [mu_prior;mu_post];
    pi_post = [pi_prior; pi_post];
    
    % Allocate derivatives
    dmuk_dalph = zeros(n+1,1);
    ddmuk_dalphalph = zeros(n+1,1);
    
%     ddmuk_dalphalph(2) = (2*pi_prior*pi_llh + 2*alpha*pi_llh^2) * pi_llh ...
%         * (x(1)-mu_post(2)) / pi_post(1)^2;
    
    for k = 2:n-length(invalid)+1
        % x is indexed at k-1 since the k-th observation is saved at
        % position k-1 in x.
        dmuk_dalph(k) = dmuk_dalph(k-1) + ((-1*k*pi_llh*(x(k-1)-...
            mu_post(k-1))) / pi_post(k)^2) - dmuk_dalph(k-1) / pi_post(k);
        
%         if k >= 3
%             ddmuk_dalphalph(k) = ddmuk_dalphalph(k-1) + (((2*pi_post(k-1)...
%                 *dpi_dalph(k-1)+2*pi_llh*pi_post(k-1)*alpha*dpi_dalph(k-1)...
%                 +2*alpha*pi_llh)*(k*-1*pi_llh)*(x(k-1)*mu_post(k-1)))/...
%                 pi_post(k)^4) + dmuk_dalph(k-1)*(k*pi_llh/pi_post(k)^2) - ...
%                 ddmuk_dalphalph(k-1)*(1/pi_post(k));
%         end
            
        
    end
    
    dmuk_dalph(1) = [];
    mu_post(1) = [];
    %ddmuk_dalphalph(1) = [];
    if function_mode
        first_dev(a) = (-2.*dmuk_dalph.*diff_dec_fct(mu_post))' * y + ...
            (2*dmuk_dalph.*diff_dec_fct(mu_post))' * mu_post;
    else
        first_dev(a) = -2.*dmuk_dalph' * y + 2*dmuk_dalph' * mu_post;
    end
    %second_dev(a) = ddmuk_dalphalph' * (y+mu_post) + dmuk_dalph'*dmuk_dalph;
    
end

% Find the minimal value
[grad, ind] = min(first_dev);
alpha = alphas(ind);


end

