function c = tapas_hgf_binary_LJM_config

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LJM HGF experiments - alternative config file 
%
%
% What we modified:
% Omega priors:    om3: sigma = -10 (log space)
%                  om2: sigma = 256 
%                  ka2: mu -100 (log space)
% 
% Why: To allow for more heterogeneity in omega2 and to fix omega3 and to
% to disentangle layers 2 and 3 (hack to make pseudo-2-layer HGF).
%  
% Omegas
% c.ommu = [NaN,  -3,  -6];
% c.omsa = [NaN, 4^5, 0];
%
% Kappas
% c.logkamu = [log(1), -100];
% c.logkasa = [     0,      0];
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Config structure
c = struct;

% Model name
c.model = 'hgf_binary';

% Number of levels (minimum: 3)
c.n_levels = 3;

% Input intervals
% If input intervals are irregular, the last column of the input
% matrix u has to contain the interval between inputs k-1 and k
% in the k-th row, and this flag has to be set to true
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
% Format: row vectors of length n_levels
% For all but the first two levels, this is usually best
% kept fixed to 1 (determines origin on x_i-scale). The 
% first level is NaN because it is determined by the second,
% and the second implies neutrality between outcomes when it
% is centered at 0.
c.mu_0mu = [NaN, 0, 1];
c.mu_0sa = [NaN, 0, 0];

c.logsa_0mu = [NaN,   log(0.1), log(1)];
c.logsa_0sa = [NaN,          0,      0];

% Rhos
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% Fix this to zero to turn off drift.
c.rhomu = [NaN, 0, 0];
c.rhosa = [NaN, 0, 0];

% Kappas
% Format: row vector of length n_levels-1.
% Fixing log(kappa1) to log(1) leads to the original HGF model.
% Higher log(kappas) should be fixed (preferably to log(1)) if the
% observation model does not use mu_i+1 (kappa then determines the
% scaling of x_i+1).
c.logkamu = [log(1), log(1)];
c.logkasa = [     0,      0];

% Omegas
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
c.ommu = [NaN,  -3,  -6];
c.omsa = [NaN, 4^2, 0];

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.rhomu,...
    c.logkamu,...
    c.ommu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.rhosa,...
    c.logkasa,...
    c.omsa,...
         ];

% Check whether we have the right number of priors
expectedLength = 3*c.n_levels+2*(c.n_levels-1)+1;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Model function handle
c.prc_fun = @tapas_hgf_binary;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_hgf_binary_transp;

return;
