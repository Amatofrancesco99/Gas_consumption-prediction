%% AIM OF THIS CODE
% Identify an annual profile model for the long-term forecast of the
% time series.


%% ADVISE
% If you want to see only prediction of gas consumption, after inserting
% values (days of the week, days of the year), comment all the other run sections


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


%% CONCLUSION (BEST MODEL)

% With our dataset the best model (in terms of standard deviation and SSR),
% is the MLP NN (Multi-Layer-Percetron Neural Network). 

% IMPORTANT:
% Note that the best model was built on the basis of the data we had, if
% you think you can predict the gas consumption in non-"normal" situations
% such as this year because of Covid, the forecast could be very different
% from what actually happens. Clearly you have to keep a lot of 
% "variables" in mind, predicting those kind of trend.


%% PREDICTING GAS CONSUMPTION WITH ENTRY VALUES, USING BEST MODEL

% run the script predictionWithValuesEntry
run('./predictionWithValuesEntry.m');


%% PROGRAM MADE BY :
% - FRANCESCO AMATO ;
% - FILIPPO ROGNONI ;
% - FRANCESCO MINAGLIA 