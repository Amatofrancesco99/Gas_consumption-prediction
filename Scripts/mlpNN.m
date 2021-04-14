%% BEFORE READING THIS CODE, READ THIS SECTION AND THE LINKS:

% For those who don't know we use both the abbreviations:
%   - MLP: Multi-layer Perceptron
%   - NN: Neural Network

% TIME SERIES FORECASTING WITH DEEP LEARNING
% https://towardsdatascience.com/time-series-forecasting-with-deep-learning-and-attention-mechanism-2d001fc871fc

% NARX TIME SERIES - FEEDBACK MLP NEURAL NETWORK
% https://it.mathworks.com/help/deeplearning/ug/design-time-series-narx-feedback-neural-networks.html


%% DATASET VARIABLES:

% input dataset for the neural network 
% (all the DayOfTheYear-DayOfTheWeek data, both years)
inputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'A3:B732'));

% output (target) dataset for the neural network
% (all the gas consumption data, both years)
outputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C3:C732'));


%% TIME SERIES FORCASTING ( USING A NARX MLP NN )
% SOLVE AN AUTOREGRESSION PROBLEM WITH EXTERNAL INPUT WITH A NARX NEURAL NETWORK

% Dynamic neural networks, which include tapped delay lines, are used 
% for nonlinear filtering and prediction.
% Reason why we can think about this network architecture, is because of we
% are talking about a time series process and we can consider that past 
% values of y(t) will be available when deployed. 

fprintf('NARX NEURAL NETWORK - MLP NN\n');
% This script assumes these variables are defined:
%
%   inputDatasetNN - input time series.
%   outputDatasetNN - feedback time series.

X = tonndata(inputDatasetNN,false,false);
T = tonndata(outputDatasetNN,false,false);

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:2;
feedbackDelays = 1:2;
% Even if you increase the number of neurons, exceeding the number of 5 neurons,
% you do not get better performance.
% ( talking about performance in terms of mean square error ) 
hiddenLayerSize = 5;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer
% states. Using PREPARETS allows you to keep your original time series data
% unchanged, while easily customizing it for networks with differing
% numbers of delays, with open loop or closed loop feedback modes.
[x,xi,ai,t] = preparets(net,X,{},T);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 65/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t,xi,ai);

% Test the Network
y = net(x,xi,ai);
e = gsubtract(t,y);
MSE = perform(net,t,y)

% VIEW THE NETWORK
% view(net)

% PLOTS
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, ploterrhist(e)
%figure, plotregression(t,y)
figure, plotresponse(t,y)
%figure, ploterrcorr(e)
%figure, plotinerrcorr(x,e)

% Closed Loop Network
% Use this network to do multi-step prediction.
% The function CLOSELOOP replaces the feedback input with a direct
% connection from the output layer.
netc = closeloop(net);
netc.name = [net.name ' - Closed Loop'];
%view(netc)
[xc,xic,aic,tc] = preparets(netc,X,{},T);
yc = netc(xc,xic,aic);
closedLoopPerformance = perform(net,tc,yc)

% Step-Ahead Prediction Network
% For some applications it helps to get the prediction a timestep early.
% The original network returns predicted y(t+1) at the same time it is
% given y(t+1). For some applications such as decision making, it would
% help to have predicted y(t+1) once y(t) is available, but before the
% actual y(t+1) occurs. The network can be made to return its output a
% timestep early by removing one delay so that its minimal tap delay is now
% 0 instead of 1. The new network returns the same outputs as the original
% network, but outputs are shifted left one timestep.
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
%view(nets)
[xs,xis,ais,ts] = preparets(nets,X,{},T);
ys = nets(xs,xis,ais);
stepAheadPerformance = perform(nets,ts,ys)


%Plotting on a 3D Graph the neural network function generated (with both years gas
%consumption data) 



% Stopping code to show the result of the neural network
pause
% Close all the figure shown before
close all;
clc;