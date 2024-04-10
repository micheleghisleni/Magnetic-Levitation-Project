function [fitresult, gof] = createfit2D(x, y, method, start_p)

%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.


[xData, yData] = prepareCurveData(x, y);

%Set up fittype and options.
ft = fittype('exp1');
opts = fitoptions( 'Method', method );
opts.Display = 'Off';
opts.StartPoint = start_p;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', inputname(2));
h = plot( fitresult, xData, yData );


legend_string = convertCharsToStrings(['Main: ',inputname(2),' vs ',inputname(1),', ',inputname(2)]);

legend( h, inputname(3), legend_string, 'Location', 'NorthEast', 'Interpreter', 'none' );

% Label axes
xlabel( inputname(1), 'Interpreter', 'none' );
ylabel( inputname(2), 'Interpreter', 'none' );

grid on
end