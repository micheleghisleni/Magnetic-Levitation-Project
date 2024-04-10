function [fitresult, gof] = createfit3D(x, y, z, method, span, view_set)

%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.


[xData, yData, zData] = prepareSurfaceData(x, y, z);

%Set up fittype and options.
ft = fittype( 'lowess' );
opts = fitoptions( 'Method', method );
opts.Normalize = 'on';
if  ~strcmp(method,'None')
    opts.Span = span;
end

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% Plot fit with data.
figure( 'Name', inputname(3));
h = plot( fitresult, [xData, yData], zData );


legend_string = convertCharsToStrings(['Main: ',inputname(3),' vs ',inputname(1),', ',inputname(2)]);

legend( h, inputname(3), legend_string, 'Location', 'NorthEast', 'Interpreter', 'none' );

% Label axes
xlabel( inputname(1), 'Interpreter', 'none' );
ylabel( inputname(2), 'Interpreter', 'none' );
zlabel( inputname(3), 'Interpreter', 'none' );

grid on

view(view_set(1),view_set(2));
end

