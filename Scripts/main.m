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



%% PREDICTING GAS CONSUMPTION WITH ENTRY VALUES, USING BEST MODEL

% run the script predictionWithValuesEntry
run('./predictionWithValuesEntry.m');


%% PROGRAM MADE BY :
% - FRANCESCO AMATO ;
% - FILIPPO ROGNONI ;
% - FRANCESCO MINAGLIA 