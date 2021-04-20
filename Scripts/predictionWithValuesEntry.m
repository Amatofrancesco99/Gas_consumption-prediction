% In this section the gas consumption forecast is made, inserted on the day
% of the week and the day of the year, using the best model among those 
% previously shown: polynomial regression, neural networks, Fourier series
% (read the conclusions section to understand better)
fprintf('PREDICTING GAS CONSUMES, USING BEST MODEL\n');

DayOfTheWeek=0;
DayOfTheYear=0;
END=0; % You want to end the prediction of gas consumption, inserting new values?

while (END==0)
  % Insert and Control of: Day of the week and Day of the year Variables
  % to than predict gas consumes
  while (DayOfTheWeek<=0 || DayOfTheWeek>7)
      fprintf('\nInsert the day of the week (it must be an integer)');
      fprintf('\n(Remember that 1 is Sunday, 7 is Saturday)\n ');
      DayOfTheWeek=input('');
  end
  while ((DayOfTheYear<=0 || DayOfTheYear>365))
      fprintf('\nInsert the day of the year \n(it must be an integer, from 1 to 365)\n ');
      DayOfTheYear=input('');
  end
  
  % Gas consumption prediction using best model
  % Before running this script run "mlpNN" script, because you need the
  % MLPNN_net to predict the gas consumption values
  fprintf('\nGas consumption predicted value\n ');
  s_hat = prediz(DayOfTheYear,DayOfTheWeek)
  
  
  % Ask if you want to continue/end insert new values and predicting gas
  % consumes
  fprintf('\nYou want to end the prediction of gas consumption inserting new values \nof day')
  fprintf(' of the week and day of the year?');
  fprintf(' (0=continue, 1=end)\n ');
  END=input('');
  if (END==0) 
      DayOfTheYear=0;
      DayOfTheWeek=0;
  end   
end


% Stop to see the results
pause
% Clear terminal
clc;


%% PREDICTION FUNCTION, USING NEURAL NETWORK

% Identify neural network model
function net =identifyMLP_net()
    % input dataset for the neural network 
    % (all the DayOfTheYear-DayOfTheWeek data, both years)
    inputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'A3:B732'));

    % output (target) dataset for the neural network
    % (all the gas consumption data, both years)
    outputDatasetNN = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C3:C732'));

    %   inputDatasetNN - input data.
    %   outputDatasetNN - target data.

    x = inputDatasetNN';
    t = outputDatasetNN';

    % Choose a Training Function
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
    
    net=MLPNN_net;
end

% Predicting gas consumes
function f = prediz(d,w)
    %Identify the network
    net=identifyMLP_net();
    f = net([d;w]);
end