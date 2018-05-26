function [tone,thresh] = calibrate_stim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes an individual calibration curve for an acoustic startle stimulus
% based on repetitive exposure to stimuli of different amplitudes and
% subsequent subjective evaluation on a scale from 0 to 100.
%
% Returns a threshold_amplitude, a value relative to the current speaker
% settings.
% 
% Moritz Gruber, May 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all;

% Loop that presents a few and records subjective evaluation
% -------------------------------------------------------------------------

d = 0.1;                 % duration
namps = 10;              % # of calibration stimuli
maxamp = findmaxamp(d)   % find max amplitude for current speaker settings
a = input('Please press enter: ');
amps = maxamp*randperm(namps)/namps; % create a random sequence of stimuli
rating = zeros(1,namps); % placeholder for ratings  

prompt = ['Rate the painfulness of this stimulus on a scale from 0 = not'...
          ' painful at all to 100 = unbearably painful'];
disp(prompt)
pause(1) 

checkval = false; % needed in loop
for i = 1:namps
    
   fprintf('\nStimulus %d of %d',i,namps);
   play_aversive(amps(i),d);
   pause(0.5)
   
   while(~checkval) % Check if input is within bounds 
       fprintf('\nPlease rate this stimulus   ');   
       current_rating=input(''); 
       if (current_rating>100 || current_rating<0)
           fprintf('\nPlease choose a valid value 0<=x<=100. Try again.')
       else 
           checkval = true;
       end       
   end
   
   rating(i) = current_rating;
   checkval = false;
end

% Plot linear fit and intrapolate 90 % of maximum.
% -------------------------------------------------------------------------
coeffs = polyfit(amps,rating,1);
thresh = (90-coeffs(2))/coeffs(1);
xlim  = ceil(thresh+5);
x = 0:0.01:xlim;
y = polyval(coeffs,x);

fig = figure;
scatter(amps,rating); hold on
plot(x,y); hold on;
plot(thresh,90,'+','MarkerEdgeColor','black','MarkerSize',10)
ylim([0 100])
xlabel('Sound amplitude (a.u.)')
ylabel('Perceived painfulness score')

% Present determined threshold
% -------------------------------------------------------------------------
fprintf('\n');
input('Press ''Enter'' to hear your threshold stimulus');
close Figure 1;

% Save output
% -------------------------------------------------------------------------
tone = play_aversive(thresh,d);
end








