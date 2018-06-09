function fig = corr_plot(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draws a scatterplot of x and y, computes the correlation and shows a 
% linear fit.
% 
% EXPECTS   x,y ........ two equally sized vectors
%           xlab,ylab .. (strings) x and y labels of the plot
% RETURNS   fig ........ a figure handle
%
% Moritz Gruber, May 2018
% =========================================================================

% Unpack
% -------------------------------------------------------------------------
if nargin < 3
    xlab = [];
    ylab = [];
elseif nargin == 4
    [xlab,ylab] = varargin{3:4};
end

[x,y] = varargin{1:2};
minx = min(x);
maxx = max(x);

% Compute fit and correlation
% -------------------------------------------------------------------------
coeffs = polyfit(x,y,1);
px = minx:0.01:maxx;
py = polyval(coeffs,px);
c = num2str(round(corr(x,y),2));

% Draw figure
% -------------------------------------------------------------------------
col1 = [41 97 69]/255;
col2 = [163,20,46]/255;

fig = figure;
scatter(x,y,'markeredgecolor',col1,'markerfacecolor',col1); hold on;
plot(px,py,'color',col2,'linewidth',2)
xlabel(xlab,'fontsize',15)
ylabel(ylab,'fontsize',15)
textpos = [min(x)+(max(x)-min(x))*0.25, min(y)+(max(y)-min(y))*0.25];
text(textpos(1),textpos(2),['\rho = ',c],'interpreter','tex','fontsize',15)
end



