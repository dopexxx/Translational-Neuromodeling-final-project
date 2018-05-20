function [tone,sf] = playtone(frequency,duration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates and plays a sine wave stimulus of specified duration and 
% frequency. The onset is windowed.
% 
% Moritz Gruber, May 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Unpack inputs, set constants
% -------------------------------------------------------------------------
d = duration;
f = frequency;
sf = 44100;
nsamples = sf*d;
time = 0:1/sf:d;

% Generate sine wave, and window
% -------------------------------------------------------------------------

tone = sin(2*pi*f*time);
win_1 = hamming(nsamples)';
win_2 = ones(1,nsamples);
win = [win_1(1:nsamples/2) win_2(nsamples/2:end)];

% Apply window, play sound
% -------------------------------------------------------------------------

tone = win.*tone;
%tone = [tone  flip(tone)];
%tone = flip(mean(tone)-tone);

sound(tone,sf);
end
