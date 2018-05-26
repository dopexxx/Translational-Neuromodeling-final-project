function maxamp = findmaxamp(duration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Presents increasingly loud white noise stimuli until the user interrupts.
% Returns a max_amplitude, a value relative to the current speaker
% settings.
% 
% Moritz Gruber, May 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 0.5; % initial intensity

while(1)
    play_aversive(i,duration);
    choice = menu('Go further?','Yes','No');
    if choice==2 || choice==0
       break
    end
    i=i+0.25; % increment amplitude by 0.25
end

maxamp = round(i,1);
fprintf('The maximum amplitude is %d.',maxamp);
end