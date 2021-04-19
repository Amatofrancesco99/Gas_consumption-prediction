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

fprintf('NEURAL NETWORKS\n');


%% TIME SERIES FORCASTING ( USING A MLP FITTING NN, WITHOUT AUTOREGRESSION)
% SOLVE AN INPUT-OUTPU FITTING PROBLEM WITH A NEURAL NETWORK

% In fitting problems, you want a neural network to map between a data set 
% of numeric inputs and a set of numeric targets.

fprintf('\n  - MLP FITTING NN WITHOUT AUTO-REGRESSION: \n');

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
net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
MSE = perform(net,t,y);


SSR_MLP_NN=MSE*length(outputDatasetNN)
sdMLP_NN = sqrt(MSE)

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)


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


% Stopping code to show the result of the neural network (without
% autoregression) 
pause
% Close all the figure shown before
close all;


%% TIME SERIES FORCASTING ( USING A NARX MLP NN, WITH AUTOREGRESSION)
% SOLVE AN AUTOREGRESSION PROBLEM WITH EXTERNAL INPUT WITH A NARX NEURAL NETWORK

% Dynamic neural networks, which include tapped delay lines, are used 
% for nonlinear filtering and prediction.
% Reason why we can think about this network architecture, is because of we
% are talking about a time series process and we can consider that past 
% values of y(t) will be available when deployed. 

fprintf('\n  - NARX NEURAL NETWORK - MLP NN WITH AUTO-REGRESSION: \n');
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
MSE = perform(net,t,y);

SSR_NARX_MLP_NN=MSE*length(outputDatasetNN)
sdNARX_MLP_NN=sqrt(MSE)

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


% Plotting on a 3D Graph the NARX neural network gas consumption data prevision 
% generated (with both years) 
figure
% Real gas consumption data (both two years)
plot3(inputDatasetNN(3:end,1),inputDatasetNN(3:end,2), outputDatasetNN(3:end,:), 'bo');
hold on
% NARX MLP NN, with auto-regression, gas consumption prevision
% Convert y from cell to double (we need it later)
y_from_cell_to_double=length(y);
for i = 1:length(y)
   y_from_cell_to_double(i) = cell2mat(y(i)); 
end
plot3(inputDatasetNN(3:end,1),inputDatasetNN(3:end,2),  y_from_cell_to_double', 'g*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D) - Real Data vs NARX MLP NN Prevision');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('Real Gas Consumption Data','NARX MLP NN Gas Consumption Prevision','Location', 'Northeast')


% Stopping code to show the result of the neural network (with
% autoregression) 
pause
% Close all the figure shown before
close all;
clc;


%% CONCLUSION (COMPARISON BETWEEN THOSE TWO DIFFERENT NEURAL NETWORK ARCHITECTURES & RESULTS)

% By eye, it can be said that the network without self-regression gives 
% results much more imprecise than the one with self-regression, although 
% the one without has an higher number of neurons in the hidden layer 
% (10 neurons against 5).
% We can say that, in terms of MSE, the network with autoregressive 
% part produce results 10 times better than the one without.
% The training algorithm choose for both neural network it's the same
% ( Bayesian Regularization backpropagation ).


% WHY THIS HAPPENS?
% Read this interesting article
% https://www.google.it/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwi5rJKOvIHwAhXj_rsIHWH_BuQQFjAAegQIAxAD&url=https%3A%2F%2Fcyberleninka.org%2Farticle%2Fn%2F735808.pdf&usg=AOvVaw0NfHODmjX3dw-8tc8GjRsl