%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script contains the code for the preparation of the
% 'natural-aversive conditioning' experiment. 
%
% This includes:
%   - Reading in the visual and specifying auditory stimuli
%   - Generating cue, ITI and stimuli sequences from the choosen PD
%   - Binding all content together into a struct.

clc; clear; close all;

metadata = struct();

% Experiment specific hyperparameter
metadata.trials = 150;
metadata.trials_per_pd = 30;
metadata.pds = [0.9, 0.1, 0.5, 0.7, 0.3];
metadata.cue_presentation_time = 0.4;
metadata.response_awaiting_time = 1.2;


% Make fixation cross
% Insight: Fixation cross and cues need to have the same size, otherwise
% the image update call does not work properly.
fix_cross_size = [601,601];
fix_cross = ones(fix_cross_size);
fix_cross(301,250:350) = 0;
fix_cross(250:350,301) = 0;
metadata.fixation_cross = fix_cross;

%%

% Reading in cues
circle = imread('data/cues/circle.png'); % Cue for sound (neutral or aversive)
circle = imresize(circle,fix_cross_size);
circle = double(circle(:,:,1));

square = imread('data/cues/square.png'); % Cue for no sound
square = imresize(square, fix_cross_size);
square = double(square(:,:,1));

metadata.cue_images = {square; circle}; % Position 1 = cue for no sound, 2 for sound

prompt_img = imread('data/cues/press_prompt.png');
prompt_img = double(prompt_img(:,:,1));
metadata.prompt_image = prompt_img;


% Sound parameter
metadata.sound_duration = 1;
metadata.sound_sampling_rate = 44100;

% Neutral sound
metadata.sound_neutral = play_neutral(200,metadata.sound_duration);



% Generate inter-trial-intervals
metadata.ITI = ((rand(metadata.trials,1)-0.5)*1000 + 1000)/1000;

% Generate cue-sequence
% 0 denotes cue for no sound, 1 for sound (neutral or aversive)
metadata.cues = randi([0 1],metadata.trials,1); 

% Generate stimuli sequence. Again, 0 -> no sound, 1 -> sound
metadata.stimuli = zeros(metadata.trials,1);
for k = 1:length(metadata.stimuli)
    
    if metadata.cues(k)
        prob_for_sound = metadata.pds(ceil(k/metadata.trials_per_pd)); 
    else
        prob_for_sound = 1 - metadata.pds(ceil(k/metadata.trials_per_pd));
    end
    r = rand();
    
    if r <= prob_for_sound
        metadata.stimuli(k) = 1;
    else
        metadata.stimuli(k) = 0;
    end
      
end

save('data/metadata.mat','metadata')





