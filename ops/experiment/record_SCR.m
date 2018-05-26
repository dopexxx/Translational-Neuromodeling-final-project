function scr_data = record_SCR(serialport,duration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Records SCR data from custom-made Arduino-based measuring device. 
%
% EXPECTS: seriallist (str) -- specifies the serial port 
% RETURNS: scr_data (array) -- recorded measurements with absolute and
%                              relative timestamps
%
% Use the MATLAB command 'seriallist' or type 'ls /dev/tty.*' in a terminal
% window to find the name of the serial port corresponding to the Arduino.
%
% Make sure your current directory is '~/TNM_project/'.
%
% Moritz Gruber, May 2018 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Open serial communication with Arduino
% -------------------------------------------------------------------------
obj = serial(serialport);
set(obj,'BaudRate',9600);
fopen(obj);                    % --> open serial communication
fprintf('Serial connection is open... Measuring will begin shortly.')

% Preparations
% -------------------------------------------------------------------------

sf = 130;                      % --> approx. sampling frequency (Hz)
scr_data=zeros(4,duration*sf); % --> placeholder for measurements

pause(5) % --> this is necessary for some weird reason

tstart = clock;                % --> get start time
timekeeper = 0;                % --> initialize timekeeper
i = 1;                         % --> iterating variable

% Recording loop
% -------------------------------------------------------------------------

figure; % --> % Open GUI to end measurements
H = uicontrol('Style', 'PushButton','String', 'Stop',...
              'Callback','delete(gcbf)');

while timekeeper < duration && ishandle(H)
    tnow = clock;                   % --> Get current time
    timekeeper = etime(tnow,tstart); % --> Compute elapsed time since start
    read = read_SCR(obj)             % --> Read current SCR value
    
    % Store absolute and relative time and measurements
    scr_data(1,i) = read;
    scr_data(2,i) = timekeeper;
    scr_data(3:5,i) = tnow(4:6);
    i = i+1; % --> Increment iterating variable
    pause(0.001)
end

close all;
fclose(obj); % --> close serial communication
clear obj;

% Crop data to nonzero entries, plot and save
% -------------------------------------------------------------------------

keep = scr_data(2,:) > 0;
scr_data = scr_data(:,keep);

fprintf('Done measuring.\nTotal time: %d seconds.\nNumber of samples: %d',...
         round(timekeeper),length(scr_data(1,:)))

plot(scr_data(2,:),scr_data(1,:))
xlabel('Time (s)')
ylabel('Skin conductance (a.u.)')
ylim([0 1100])
xlim([0 max(scr_data(2,:))])

filename = ['data/recordings/','SCR','_day_',num2str(tnow(3)),'_h_',...
    num2str(tnow(4)),'_min_',num2str(tnow(5)),'.mat'];
try 
    save(filename,'scr_data')
    fprintf('\nFile successfully saved as %s',filename)
catch
    save('recording.mat','scr_data')
    fprintf('\nFile successfully saved as recording.mat')
end


end