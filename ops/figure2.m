function FigHandle = figure2(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Function that mimicks figure(), but opens the figure on the second
% screen, if one is available (one main screen otherwise).
% 
% Parameters:
% ---------------------------
% VARARGIN      -  requirements identical to the regular figure function
%
% Returns:
% ---------------------------
% no returns.
%
% Jannis Born, May 2018

MP = get(0, 'MonitorPositions');

if size(MP, 1) == 1  % Single monitor
    FigH = figure(varargin{:});
else                 % Multiple monitors
    % Catch creation of figure with disabled visibility: 
    posShift = MP(2, 3:4);
    FigH     = figure(varargin{:}, 'Visible', 'off');
    set(FigH, 'Units', 'pixels');
    pos      = get(FigH, 'Position');
    set(FigH, 'Position', [pos(1:2) + posShift, pos(3:4)])
    set(FigH, 'Visible', 'on');
end
if nargout ~= 0
    FigHandle = FigH;
end