function playstim(amplitude,duration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plays a white noise stimulus of specified duration and amplitude. 
% Note that the amplitude is relative to current speaker settings.
% 
% Moritz Gruber, May 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set constants, generate values, normalize
% -------------------------------------------------------------------------
sf = 44100; 
d = duration;
n = sf * d;
y = randn(n,1);
y = y/max(abs(y));

% Play sound
% -------------------------------------------------------------------------
sound(y*amplitude,sf);

end