%% AIM OF THIS CODE
% Identify an annual profile model for the long-term forecast of the
% time series.


%% PRELIMINARY ACTIONS 
%(MATLAB CLEANING)
clear;
clc;
close all;


%% DATASET PLOTTED ON GRAPH (2D & 3D)

% run the script "plottingGraph"
run('./plottingGraphs.m');


%% MODEL IDENTIFICATION WITH MATRIOSKA MODELS & CROSS-VALIDATION

% run the script "matrioskaIdentification_and_CrossValidation"
run('./matrioskaIdentification_and_CrossValidation.m');


%% MODEL IDENTIFICATION WITH NEURAL NETWORK

% run the script "mlpNN"
run('./mlpNN.m');


%% FOURIER MODEL IDENTIFICATION

% run the script "fourierMI" (MI stands for "model identification") 
run('./fourierMI.m');


%% CONCLUSION



%% PREDICTING GAS CONSUMPTION, USING BEST MODEL
% In this section the gas consumption forecast is made, inserted on the day
% of the week and the day of the year, using the best model among those 
% previously shown: polynomial regression, neural networks, Fourier series
% (read the conclusions section to understand better)
fprintf('PREDICTING GAS CONSUMES, USING BEST MODEL\n');

DayOfTheWeek=0;
DayOfTheYear=0;

% Insert and Control of: Day of the week and Day of the year Variables
% to than predict gas consumes
while (DayOfTheWeek<=0 || DayOfTheWeek>7) || (DayOfTheWeek<=0 || DayOfTheWeek>365)
    fprintf('Insert the day of the week (it must be an integer)');
    fprintf('(Remember that 1 is Sunday, 7 is Saturday)');
    DayOfTheWeek=str2int(input());
    fprintf('Insert the day of the year (it must be an integer, from 1 to 365)');
    DayOfTheYear=str2int(input());
end
% Gas consumption prediction using best model 


%% PROGRAM MADE BY :
% - FRANCESCO AMATO ;
% - FILIPPO ROGNONI ;
% - FRANCESCO MINAGLIA 
