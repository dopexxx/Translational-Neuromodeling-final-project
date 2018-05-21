%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script executes the 'natural-aversive conditioning' experiment.
% Use this script for every participant individually and once only.
%
%
% May 2018 - Jannis Born
%
%


% Load in epxerimental hyperparameter
clear; clc; close all;
global metadata
load('data/metadata');

% Alloquate workspace
global subject
subject = struct();
subject.responses = zeros(2,metadata.trials);
subject.stim_onsets = zeros(2,metadata.trials,3);


%% Calibrate the maximal stimulus amplitude
subject.aversive_sound = calibrate_stim();
disp(' ')
pause(2)

%% Start experiment (neutral stimuli)

prompt = ['Please enter your blindfolded subject ID from the questionnaire: '];
disp(prompt);

while 1 % Check if input is within bounds 
    
   ID = str2num(input('','s')); 
   if isempty(ID)
       disp('Please insert a numerical ID. Try again:')
   elseif (ID>20 || ID<0)
       disp('Please choose a valid value 0 <= x <= 20. Try again:')
   else
       break
   end       
end

subject.ID = ID;
disp("Your ID was saved succesfully!");disp('');disp('');
pause(3);

p = ['You will now start the experiment.'];
disp(p)
pause(1.5)
p = ['Every trial starts with a cue that you will see for a few milliseconds.'];
disp(p)
pause(3)
p = ['The cue gives you a hint whether you will hear a sound or not.'];
disp(p)
pause(3)
p = ['Note, that the predictive power of the cue changes over time.'];
disp(p)
pause(5)
disp(newline)
 
disp('Now put index and middle finger on the M and N characters on the keyboard.');
pause(5)
disp('After seeing the cue, press N if you think you WILL NOT hear a sound.');
pause(3)
disp('Press M if you think you WILL hear a sound.');disp('');
pause(3)

disp('Now focus on the 2nd screen on which a fixation cross will appear.')
pause(3)


a = input('Ok. The experiment can start. Press ENTER if you are ready.');



disp("Experiment starts in 5 seconds...")
pause(2)
[fig,ax] = figure2_imshow(metadata.fixation_cross,[]);
pause(3);

for k = 1:metadata.trials
    % Show the visual cue
    if metadata.cues(k)
        set(get(ax,'Children'),'CData',metadata.cue_images{2});
    else
        set(get(ax,'Children'),'CData',metadata.cue_images{1});
    end
    pause(metadata.cue_presentation_time) % Present cue for 400ms
    
    % Show fixation cross again
    set(get(ax,'Children'),'CData',metadata.fixation_cross);
    
    % Record the prediction
    subject.responses(1,k) = record_response(); % 1 sec
    
    % Play the neutral stimulus if applicable       - 1sec
    if metadata.stimuli(k)
        stamp = present_stimulus('neutral');
        subject.stim_onsets(1,k,:) = stamp(4:end);
    else
        stamp = clock;
        subject.stim_onsets(2,k,:) = stamp(4:end);
        pause(metadata.sound_duration);
    end
    pause(metadata.ITI(k)); % 0.5 - 1.5 sec
    % per trial: 3.5 sec + code running time.
end

close all;
disp("You have reached your break");disp('');
disp("Please fill out the questionnaire and hand it over to the experimentor");


%% Second block
disp("Second block starts in 5 seconds...")
pause(1)
[fig,ax] = figure2_imshow(metadata.fixation_cross,[]);
pause(4);

for k = 1:metadata.trials
    
    % Show the visual cue
    if metadata.cues(k)
        set(get(ax,'Children'),'CData',metadata.cue_images{1});
    else
        set(get(ax,'Children'),'CData',metadata.cue_images{2});
    end
    pause(metadata.cue_presentation_time) % Present cue for 400ms
    set(get(ax,'Children'),'CData',metadata.fixation_cross);
    
    % Record the prediction
    subject.responses(2,k) = record_response(); % 1 sec
    
    % Play the neutral stimulus if applicable       - 1sec
    if metadata.stimuli(k)
        present_stimulus('aversive');
    else
        pause(metadata.sound_duration);
    end
    pause(metadata.ITI(k)); % 0.5 - 1.5 sec
    % per trial: 3.5 sec + code running time.
end

close all;
disp("You have reached the end of the experiment.");disp('');
disp("Pick up your well deserved sweeeeeets");


%% Helper methods (do not execute)


function ax = present_cue(cue,ax)
    % Subroutine is called every trial during the experiment and displays the
    % cue image full size on 2nd screen.
    %
    % Parameters:
    % ----------------
    % CUE       {0,1} binary number indicating the cue to present. (0 for
    %               no-sound-cue (square), 1 for sound-cue (circle))
    % AX        Axes handle for figure of second screen
    %
    % Returns:
    % ----------------
    % AX         Updated axes handle from figure on second screen.
    
    global metadata
   
    if cue == 0
        tic
        set(get(ax,'Children'),'CData',metadata.cue_images{1});
    elseif cue == 1
        tic
        set(get(ax,'Children'),'CData',metadata.cue_images{2});
    else
        error("Unknown cue requested.");
    end
    
    pause(metadata.cue_presentation_time)
    set(get(ax,'Children'),'CData',metadata.fixation_cross);
        

end


function prediction = record_response()
    % Subroutine called every trial. Collects the response of the
    % participant and returns it.
    %
    % Returns:
    % --------------
    % PREDICTION    {0,1,2}  0 for 'no sound', 1 for 'sound', 2 for rest.
    %
    
    global metadata
    
    %prompt = ['Please insert your response. Remember, N for no sound, ' ...
    %        'M for sound.'];
    %disp(prompt)
    raw = getkeywait(metadata.response_awaiting_time);
    
    if raw == 110 % ASCII(n) = 110
        prediction = 0;
        disp("Prediction NO SOUND recorded.");
    elseif raw == 109 % ASCII(m) = 109
        prediction = 1;
        disp("Prediction SOUND recorded.");
    else 
        prediction = 2;
        disp("No valid prediction recorded.");
    end
    

end


function stamp = present_stimulus(type)
    % Subroutine executed in all trials in which the auditory sound is to
    % be played.
    %
    % Parameters:
    % -----------------
    % TYPE           {'normal','aversive'} defining whether the neutral or 
    %                   the aversive sound is played.
    
    global metadata
    global subject
    
    if strcmp(type,'neutral')
        sound(metadata.sound_neutral, metadata.sound_sampling_rate)
        stamp = clock;
    elseif strcmp(type,'aversive')
        sound(subject.aversive_sound, metadata.sound_sampling_rate);
        stamp = clock;
    else
        error('Unknown acustic stimulus requested.');
    end
    pause(metadata.sound_duration);

end



function [fig,ax] = figure2_update(fig,ax,img)
    % Function that updates the picture presented on the second screen
    % 
    % Parameters:
    % ---------------------------
    % FIG           -  Figure Handle of the figure on the second screen
    % AX            -  Axes Handle of the figure on the second screen
    % IMG           -  {uint8, double} image to be displayed via imshow
    %
    % Returns:
    % ---------------------------
    % FIGHANDLE     -   from figure(), see 'doc figure' for details
    %
    % Jannis Born, May 2018
    
    MP = get(0, 'MonitorPositions');
    
    if size(MP, 1) == 1  % Single monitor
        error("Only one screen found. Check connection!"); 
    else                 % Multiple monitors
        % Catch creation of figure with disabled visibility: 
        posShift = MP(2, 3:4);
        
        imshow(img)
        pos      = get(fig, 'Position');
        set(fig,'color','w');  
        set(fig, 'Units', 'normalized', 'outerposition',[0 0 1 1]);
        %set(gca,'Unit','normalized','Position',[0 0 1 1]);
        set(fig, 'Position', [pos(1:2) + posShift, pos(3:4)])
        set(fig, 'Visible', 'on');
        set(fig, 'menubar','none');
        set(fig, 'NumberTitle','off');
    end
    

end


function [FigHandle,AxeH] = figure2_imshow(varargin)
    % Function that opens a new figure on the second screen (if one available)
    % and displays an image in full screen with the requirements for our TNM
    % experiment.
    % 
    % Parameters:
    % ---------------------------
    % VARARGIN      -  requirements identical to the regular figure function
    % VARARGIN(end) -  {uint8, double} image to be displayed via imshow
    %
    % Returns:
    % ---------------------------
    % FIGHANDLE     -   from figure(), see 'doc figure' for details
    %
    % Jannis Born, May 2018
    close all;
    MP = get(0, 'MonitorPositions');
    display_time = varargin{end};
    img = varargin{end-1}; % this should be a uint8 or double
    varargin = varargin(1:end-2); % this should stay a cell array

    if size(MP, 1) == 1  % Single monitor
        FigH = figure(varargin{:});
        AxeH = gca;
    else                 % Multiple monitors
        % Catch creation of figure with disabled visibility: 
        posShift = MP(2, 3:4);
        FigH     = figure(varargin{:}, 'Visible', 'off');
        AxeH = gca;
        imshow(img);
        pos      = get(FigH, 'Position');
        set(FigH,'color','w');  
        set(FigH, 'Units', 'normalized', 'outerposition',[0 0 1 1]);
        %set(gca,'Unit','normalized','Position',[0 0 1 1]);
        set(FigH, 'Position', [pos(1:2) + posShift, pos(3:4)])
        set(FigH, 'Visible', 'on');
        set(FigH, 'menubar','none');
        set(FigH, 'NumberTitle','off');

    end
    if nargout ~= 0
        FigHandle = FigH;
    end
end