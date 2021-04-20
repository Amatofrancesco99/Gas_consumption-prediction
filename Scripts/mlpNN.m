%% BEFORE READING THIS CODE, READ THIS SECTION AND THE LINKS:

% For those who don't know we use both the abbreviations:
%   - MLP: Multi-layer Perceptron
%   - NN: Neural Network

% TIME SERIES FORECASTING WITH DEEP LEARNING
% https://towardsdatascience.com/time-series-forecasting-with-deep-learning-and-attention-mechanism-2d001fc871fc


%% DATASET VARIABLES:

% input dataset for the neural network 
% (all the DayOfTheYear-DayOfTheWeek data, both years)
inputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'A3:B732'));

% output (target) dataset for the neural network
% (all the gas consumption data, both years)
outputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C3:C732'));


%% TIME SERIES FORCASTING ( USING A MLP FITTING NN )
% SOLVE AN INPUT-OUTPUT FITTING PROBLEM WITH A NEURAL NETWORK

% In fitting problems, you want a neural network to map between a data set 
% of numeric inputs and a set of numeric targets.

fprintf('MLP FITTING NN \n');

% This script assumes these variables are defined:
%
%   inputDatasetNN - input data.
%   outputDatasetNN - target data.

x = inputDatasetNN';
t = outputDatasetNN';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 10;
MLPNN_net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[MLPNN_net,tr] = train(MLPNN_net,x,t);

% Test the Network
y = MLPNN_net(x);
e = gsubtract(t,y);
MSE = perform(MLPNN_net,t,y);


SSR_MLP_NN=MSE*length(outputDatasetNN)
sdMLP_NN = sqrt(MSE)

% View the Network
%view(MLPNN_net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(MLPNN_net,x,t)


% Plotting on a 3D Graph the MLP NN, without auto-regression, gas consumption
% data prevision generated ( both years ) 
figure
% Real gas consumption data (both two years)
plot3(inputDatasetNN(:,1),inputDatasetNN(:,2), outputDatasetNN, 'bo');
hold on
% MLP NN, without auto-regression, gas consumption prevision
plot3(inputDatasetNN(:,1),inputDatasetNN(:,2),  y', 'g*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D) - Real Data vs MLP NN Prevision');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('Real Gas Consumption Data','MLP NN Gas Consumption Prevision','Location', 'Northeast')


% Stopping code to show the result of the neural network 
pause
% Close all the figure shown before
close all;
clc;