%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script contains the code for the preparation of the
% 'natural-aversive conditioning' experiment. 
%
% This includes:
%   - Reading in the visual and specifying auditory stimuli
%   - Generating cue, ITI and stimuli sequences from the choosen PD
%   - Binding all content together into a struct.

metadata = struct();

% Experiment specific hyperparameter
metadata.trials = 150;
metadata.trials_per_pd = 30;
metadata.pds = [0.9, 0.1, 0.5, 0.7, 0.3];


% Reading in cues
circle = imread('data/cues/circle.png'); % Cue for sound (neutral or aversive)
square = imread('data/cues/square.png'); % Cue for no sound
metadata.cue_images = {square; circle}; % Position 1 = cue for no sound, 2 for sound

% Neutral sound parameters
metadata.neutral_sound = playtone(200,1);

% Aversive sound parameters
metadata.aversive_sound_dur = 1;

% Read in parameter for neutral sound
metadata.stimuli_duration = 100; % tone is played for 100ms
metadata.stimuli_frequency = 20; % frequency of natural stimulus


% Generate inter-trial-intervals
metadata.ITI = (rand(metadata.trials,1)-0.5)*1000 + 1000;

% Generate cue-sequence
% 0 denotes cue for no sound, 1 for sound (neutral or aversive)
metadata.cues = randi([0 1],metadata.trials,1); 

% Generate stimuli sequence. Again, 0 -> no sound, 1 -> sound
metadata.stimuli = zeros(metadata.trials,1);
for k = 1:length(metadata.stimuli)
    
    prob_for_sound = metadata.pds(ceil(k/metadata.trials_per_pd)); % retrieve PD
    r = rand();
    
    if r <= prob_for_sound
        metadata.stimuli(k) = 1;
    else
        metadata.stimuli(k) = 0;
    end
      
end

save('data/metadata.mat','metadata')





