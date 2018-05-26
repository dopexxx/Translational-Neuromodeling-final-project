function corr_plot(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Draws a scatterplot of x and y, computes the correlation and shows a 
% linear fit.
%
end

if nargin < 3
    legend = []
else 
    legend = varargin{3}
end

c = round(corr(x,y),2);

figure
scatter(x,y)

coeffs = polyfit(x,y,1);
x = 0:0.01:;
y = polyval(coeffs,x);