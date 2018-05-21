function out = read_SCR(port)

% Serial send read request to Arduino
fprintf(port,'G');  
% Read value returned via Serial communication 
out = fscanf(port,'%f');

end
