%% DATA PLOTTING ON GRAPHS (2D & 3D)

% Save the table information in two dataset, each for a year
% selecting only the data I’m interested viewing
dsYear1=readtable('../Dataset/gasITAday.xlsx', 'Range', 'A3:C367');
dsYear2=readtable('../Dataset/gasITAday.xlsx', 'Range', 'A368:C732');

% Change the coloumn's name in the different datasets
dsYear1.Properties.VariableNames{1}='DayOfTheYear';
dsYear1.Properties.VariableNames{2}='DayOfTheWeek';
dsYear1.Properties.VariableNames{3}='GasConsumption';

dsYear2.Properties.VariableNames{1}='DayOfTheYear';
dsYear2.Properties.VariableNames{2}='DayOfTheWeek';
dsYear2.Properties.VariableNames{3}='GasConsumption';

% PLOTTING DATASET ON 2D GRAPHS, for each year (more easy to be "read")
fprintf('PLOTTING DATASET ON 2D & 3D GRAPHS');
figure(1)
%Year 1
subplot(2,1,1)
plot(dsYear1.DayOfTheYear,dsYear1.GasConsumption, '-o');
title('GAS CONSUMPTION IN ITALY (2D) -- Year 1');
xlabel('Days of Year 1');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:12
       xline(i*30, 'm--');
end
%Year 2
subplot(2,1,2)
plot(dsYear2.DayOfTheYear,dsYear2.GasConsumption, 'r-o');
title('GAS CONSUMPTION IN ITALY (2D) -- Year 2');
xlabel('Days of Year 2');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:12
       xline(i*30, 'm--');
end

% FIRST (EASY) OBSERVATIONS:
% From the diagrams we can already notice that the gas consumption decreases 
% in the hottest months of the year, more specifically in the days that go 
% from the 120th (April) to the 290th (September).
% So we can say that this trend are both seasonal, with a periodicity 
% of about 6 months.

% WHY THIS HAPPENS (QUITE OBVIOUS)? 
% Natural gas consumption has two seasonal peaks, largely reflecting
% weather-related fluctuations in energy demand. 
% In the winter months, cold weather leads to more demand for heating in 
% the residential and commercial sectors. 
% In the summer months, warm weather leads to more demand for air conditioning 
% and, in turn, more demand for electricity.

% ANOTHER OBSERVATION:
% Considered a specific weekly window (7 days), we can see that during the 
% weekends the gas consumption is lower than the other 5 days of that same
% week.

% SOME MATHEMATICAL OBSERVATIONS:
% From the 2D graph of the two signals (gas consumption, depending on the day 
% of the year and the day of the week), we can also notice that it is a discrete
% time stationary signal.
% Stationary as if we took two sufficiently distant windows we can see that 
% the trend seems to be similar (except for small oscillations due to noise),
% more specifically if we consider windows spaced 6 months concatenating the
% two years (taking December of year 1 and chaining it with January of year 2).
% Discrete time because the realizations have been taken only once a day for
% a year and not for every moment of time of every day of a year (reasonable 
% enough because we do not care to know the gas consumption per second, but 
% in a whole day). 
% We can also notice that the signal sign stay positive (January-April)
% then falls (April-September), then goes higher (Semptember-April_Year 2).
% Finally we can say that its autocovariance function will be centered around
% an average value (average gas consumption in a year, which corresponds to 
% the sum of daily gas consumption in a year / the number of days in a year), 
% and will have a fairly slow decline (because it remains positive for 6 
% months, then it goes down). 
% So its Fourier transform (of the autocovariance) will be a fairly "fat"
% and "low" Gaussian (slow decay and always centered around the average value 
% previously mentioned).


% PLOTTING DATASET ON 3D GRAPHS, for each year
figure(2)
%Year 1
subplot(2,1,1)
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek,dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
%Year 2
subplot(2,1,2)
plot3(dsYear2.DayOfTheYear,dsYear2.DayOfTheWeek,dsYear2.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 2');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');


% Stopping code to show only the plotting graphs
pause
% Close all the figure shown before
close all;
clc;
