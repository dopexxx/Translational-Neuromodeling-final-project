function stim_onset_syn = synchronize(stim_onset, delta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synchronizes GSR and behavioral data
%
%   Parameters:
%   -------------
%   STIM_ONSET      {double} [3,1] with stimulus onset time in [h,min,sec]
%   DELTA           {double} [1,1] time delta of system clocks (in ms!)
%
%
%   Returns:
%   -------------
%   STIM_ONSET_SYN  {double} [3,1] corrected time in same format like
%                       original

raw_sec = stim_onset(3) + delta; % Uncorrected (may be > 60)
sec = mod(raw_sec, 60); % second overflow
raw_min = stim_onset(2) + floor(raw_sec/60);
min = mod(raw_min , 60);
raw_hour = stim_onset(1) + floor(raw_min/60);
hour = mod(raw_hour , 24);

stim_onset_syn = [hour;min;sec];