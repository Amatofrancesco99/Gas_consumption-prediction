%% AIM OF THIS CODE: 
% Identify an annual profile model for the long-term forecast of the
% time series.


%% ANNOTATION ON THE CODE


%% THEORETICAL REFERENCES


%% PRELIMINARY ACTIONS 
%(MATLAB CLEANING)
clear;
clc;
close all;


%% CORE SCRIPT
% Save the table information in two dataset, each for a year
% selecting only the data I’m interested viewing
dsYear1=readtable('./Dataset/gasITAday.xlsx', 'Range', 'A3:C367');
dsYear2=readtable('./Dataset/gasITAday.xlsx', 'Range', 'A368:C732');

% Change the coloumn's name in the different datasets
dsYear1.Properties.VariableNames{1}='DayOfTheYear';
dsYear1.Properties.VariableNames{2}='DayOfTheWeek';
dsYear1.Properties.VariableNames{3}='GasConsumption';

dsYear2.Properties.VariableNames{1}='DayOfTheYear';
dsYear2.Properties.VariableNames{2}='DayOfTheWeek';
dsYear2.Properties.VariableNames{3}='GasConsumption';

% PLOTTING DATASET ON GRAPHS, for each year (2D, more easy to be "read") 
%Year 1
figure(1)
subplot(2,1,1)
plot(dsYear1.DayOfTheYear,dsYear1.GasConsumption, 'Linewidth' , 2);
title('GAS CONSUMPTION IN ITALY -- Year 1');
xlabel('Days of Year 1');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:12
       xline(i*30, 'm--');
end
%Year 2
subplot(2,1,2)
plot(dsYear2.DayOfTheYear,dsYear2.GasConsumption, 'r', 'Linewidth' , 2);
title('GAS CONSUMPTION IN ITALY -- Year 2');
xlabel('Days of Year 2');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:12
       xline(i*30, 'm--');
end

% FIRST OBSERVATIONS:
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


%% CONCLUSION


%% PROGRAM MADE BY FRANCESCO AMATO, FILIPPO ROGNONI & FRANCESCO MINAGLIA