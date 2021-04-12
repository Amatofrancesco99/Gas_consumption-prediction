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
dsYear1.Properties.VariableNames{3}='Consumption';

dsYear2.Properties.VariableNames{1}='DayOfTheYear';
dsYear2.Properties.VariableNames{2}='DayOfTheWeek';
dsYear2.Properties.VariableNames{3}='Consumption';

% Graph plot (2D, more easy to be "read") 
%Year 1
figure(1);
subplot(2,1,1);
plot(dsYear1.DayOfTheYear,dsYear1.Consumption, 'Linewidth' , 2);
xlabel('Days of Year 1');
ylabel('Consumption (millionM^3)');
grid on
%Year 2
subplot(2,1,2);
plot(dsYear2.DayOfTheYear,dsYear2.Consumption, 'r', 'Linewidth' , 2);
xlabel('Days of Year 2');
ylabel('Consumption (millionM^3)');
grid on

% OBSERVATION:
% From the diagrams we can already notice that the gas consumption decreases 
% in the hottest months of the year, more specifically in the days that go 
% from the 120th (April) to the 290th (September)


%% CONCLUSION


%% PROGRAM MADE BY FRANCESCO AMATO, FILIPPO ROGNONI & FRANCESCO MINAGLIA