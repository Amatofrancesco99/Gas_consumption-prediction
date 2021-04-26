%% FIRST OBSERVATION:
% We want to do understand what are the fundamental frequencies that 
% characterize our signal. 
% Those frequency, we may think, will be:
% - A constant frequency that represents the average trend of consumption of
%   gas during all the years;
% - A frequency representing the full-yearly seasonality (cosine/sine):
%   during different years the gas consumption function is the same;
% - A frequency representing the half-yearly seasonality (cosine/sine):
%   during hottest month gas consumption is less then colder one;
% - A frequency representing the weekly periodicity (cosine/sine): 
%   during weekend gas consumption is less than other days 
%   (weekly seasonality).


%% PLOT 2D GAS CONSUMPTION (both years)

fprintf('MODEL IDENTIFICATION, USING FOURIER THEORY\n');

% days of both years
days = linspace(1,730,730);
daysWeek = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'B2:B732'))';
% gas consumption during both years
gas_consumption = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C2:C732'));


% Plotting part
figure(1)
plot(days,gas_consumption);
title('GAS CONSUMPTION IN ITALY (2D) -- Two Years');
xlabel('Days');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:24
       xline(i*30, 'm--');
end


%% SPECTRUM OF THE GAS CONSUMPTION FUNCTION

% Use Fourier transforms to find the frequency components of a signal 
% buried in noise.
% Specify the parameters of a signal with a sampling frequency of 1 kHz 
% and a signal duration of 0.730 seconds.
Fs = 1000;                    % Sampling frequency                    
T = 1/Fs;                     % Sampling period       
L = length(days);             % Length of signal (number of days)
t = (0:L-1)*T;                % Time vector

%Plotting the signal's spectrum
figure(2)
% Compute the Fourier transform of the signal
signalSpectrum=fft(gas_consumption);
% Compute the two-sided spectrum P2. Then compute the single-sided spectrum 
% P1 based on P2 and the even-valued signal length L.
P2 = abs(signalSpectrum/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% Define the frequency domain f and plot the single-sided amplitude spectrum P1.
% The amplitudes are not exactly at 0.7 and 1, as expected, because of the added 
% noise. On average, longer signals produce better frequency approximations.
f = linspace(1,366,366);
plot(f,P1); 
grid on
title('SPECTRUM OF THE GAS CONSUMPTION FUNCTION');
xlabel('frequency (mHz)')
ylabel('FFT Gas Consumption')


%% FIND ALL PEAKS OF THE SIGNAL SPECTRUM & SELECTING IMPORTANT ONE

hold on
%Find important peaks of the signal spectrum
[amp,locs] = findpeaks(P1);
% Because findpeaks function does not find the peak in 0, we insert it
% manually
ampPeakIn0= 85.61;
%Show only important peaks on plot shown before
locsImpPeaks= [locs(1:3);locs(41);210;314];
ampImpPeaks= [amp(1:3);amp(41);2.921;1.696];
plot([0;locsImpPeaks],[ampPeakIn0;ampImpPeaks],'g*');
legend('ORIGINAL SIGNAL SPECTRUM','IMPORTANT PEAKS')


%% IDENTIFY MODEL 

% Useful variables
dsYear1=readtable('../Dataset/gasITAday.xlsx', 'Range', 'A3:C367');
dsYear2=readtable('../Dataset/gasITAday.xlsx', 'Range', 'A368:C732');

% Change the coloumn's name in the different datasets
dsYear1.Properties.VariableNames{1}='DayOfTheYear';
dsYear1.Properties.VariableNames{2}='DayOfTheWeek';
dsYear1.Properties.VariableNames{3}='GasConsumption';
dsYear2.Properties.VariableNames{1}='DayOfTheYear';
dsYear2.Properties.VariableNames{2}='DayOfTheWeek';
dsYear2.Properties.VariableNames{3}='GasConsumption';

n=length(dsYear1.GasConsumption); %Number of observations
nVal=length(dsYear2.GasConsumption); % Number of observation (for validation)


%% MODEL IDENTIFICATION 

% Visto che l'andamento annuale non è costante è meglio partire da un
% armonica di primo grado, per poi effettuare i vari confronti e vedere il
% modello migliore.

% Stimiamo un modello che rappresenti l'andamento annuale, successivamente
% utilizzeremo anche un modello che rappresenta il trend settimanale


% ARMONICA DI PRIMO GRADO
Phi1= [ones(n,1), cos(((pi)/365)*dsYear1.DayOfTheYear), sin(((pi)/365)*dsYear1.DayOfTheYear) ]; 
[ThetaLS1, std_thetaLS1] = lscov(Phi1, dsYear1.GasConsumption);

% Variables that will be useful to us regarding the choice of
% best model
q1=length(ThetaLS1); %Number of parameters considered by the model in question
%Estimated yield given our model
y_hat1=Phi1*ThetaLS1;
%Residual calculation
epsilon1=dsYear1.GasConsumption-y_hat1;
%SSR calculation
SSR1=epsilon1'*epsilon1;


figure()
% Plotted on a graph data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek, dsYear1.GasConsumption, 'bo')
hold on
% Plotting on graphs identified model
fun = @(a0,a1,b1,x) a0 + a1*cos(x*((pi)/365)) + b1*sin(x*((pi)/365));
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek,fun(ThetaLS1(1),ThetaLS1(2),ThetaLS1(3),dsYear1.DayOfTheYear), 'm*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend( 'data','First degree Sin/Cos model', 'Location', 'Northeast');


% ARMONICA DI SECONDO GRADO
Phi2= [ones(n,1), cos(((pi)/365)*dsYear1.DayOfTheYear), sin(((pi)/365)*dsYear1.DayOfTheYear) ...
    , cos(((2*pi)/365)*dsYear1.DayOfTheYear), sin(((2*pi)/365)*dsYear1.DayOfTheYear)]; 
[ThetaLS2, std_thetaLS2] = lscov(Phi2, dsYear1.GasConsumption);

% Variables that will be useful to us regarding the choice of
% best model
q2=length(ThetaLS2); %Number of parameters considered by the model in question
%Estimated yield given our model
y_hat2=Phi2*ThetaLS2;
%Residual calculation
epsilon2=dsYear1.GasConsumption-y_hat2;
%SSR calculation
SSR2=epsilon2'*epsilon2;


figure()
% Plotted on a graph data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek, dsYear1.GasConsumption, 'bo')
hold on
% Plotting on graphs identified model
fun = @(a0,a1,b1,a2,b2,x) a0 + a1*cos(x*((pi)/365)) + b1*sin(x*((pi)/365)) + a2*cos(2*x*((pi)/365)) + b2*sin(2*x*((pi)/365));
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek,fun(ThetaLS2(1),ThetaLS2(2),ThetaLS2(3),ThetaLS2(4),ThetaLS2(5),dsYear1.DayOfTheYear), 'm*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend( 'data','Second degree Sin/Cos model', 'Location', 'Northeast');


% ARMONICA TERZO GRADO 
Phi3= [ones(n,1), cos(((pi)/365)*dsYear1.DayOfTheYear), sin(((pi)/365)*dsYear1.DayOfTheYear) ...
    , cos(((2*pi)/365)*dsYear1.DayOfTheYear), sin(((2*pi)/365)*dsYear1.DayOfTheYear) ... 
    , cos(((3*pi)/365)*dsYear1.DayOfTheYear), sin(((3*pi)/365)*dsYear1.DayOfTheYear)]; 
[ThetaLS3, std_thetaLS3] = lscov(Phi3, dsYear1.GasConsumption);

% Variables that will be useful to us regarding the choice of
% best model
q3=length(ThetaLS3); %Number of parameters considered by the model in question
%Estimated yield given our model
y_hat3=Phi3*ThetaLS3;
%Residual calculation
epsilon3=dsYear1.GasConsumption-y_hat3;
%SSR calculation
SSR3=epsilon3'*epsilon3;


figure()
% Plotted on a graph data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek, dsYear1.GasConsumption, 'bo')
hold on
% Plotting on graphs identified model
fun = @(a0,a1,b1,a2,b2,a3,b3,x) a0 + a1*cos(x*((pi)/365)) + b1*sin(x*((pi)/365)) + a2*cos(2*x*((pi)/365)) + b2*sin(2*x*((pi)/365)) + a3*cos(3*x*((pi)/365)) + b3*sin(3*x*((pi)/365));
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek,fun(ThetaLS3(1),ThetaLS3(2),ThetaLS3(3),ThetaLS3(4),ThetaLS3(5),ThetaLS3(6),ThetaLS3(7),dsYear1.DayOfTheYear), 'm*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend( 'data','Third degree Sin/Cos model', 'Location', 'Northeast');


%% ARMONICA QUARTO GRADO
Phi4= [ones(n,1), cos(((pi)/365)*dsYear1.DayOfTheYear), sin(((pi)/365)*dsYear1.DayOfTheYear) ...
    , cos(((2*pi)/365)*dsYear1.DayOfTheYear), sin(((2*pi)/365)*dsYear1.DayOfTheYear) ... 
    , cos(((3*pi)/365)*dsYear1.DayOfTheYear), sin(((3*pi)/365)*dsYear1.DayOfTheYear) ...
    , cos(((4*pi)/365)*dsYear1.DayOfTheYear), sin(((4*pi)/365)*dsYear1.DayOfTheYear)]; 
[ThetaLS4, std_thetaLS4] = lscov(Phi4, dsYear1.GasConsumption);

% Variables that will be useful to us regarding the choice of
% best model
q4=length(ThetaLS4); %Number of parameters considered by the model in question
%Estimated yield given our model
y_hat4=Phi4*ThetaLS4;
%Residual calculation
epsilon4=dsYear1.GasConsumption-y_hat4;
%SSR calculation
SSR4=epsilon4'*epsilon4;


figure()
% Plotted on a graph data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek, dsYear1.GasConsumption, 'bo')
hold on
% Plotting on graphs identified model
fun = @(a0,a1,b1,a2,b2,a3,b3,a4,b4,x) a0 + a1*cos(x*((pi)/365)) + b1*sin(x*((pi)/365)) + a2*cos(2*x*((pi)/365)) + b2*sin(2*x*((pi)/365)) + a3*cos(3*x*((pi)/365)) + b3*sin(3*x*((pi)/365)) + a4*cos(4*x*((pi)/365)) + b4*sin(4*x*((pi)/365));
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek,fun(ThetaLS4(1),ThetaLS4(2),ThetaLS4(3),ThetaLS4(4),ThetaLS4(5),ThetaLS4(6),ThetaLS4(7),ThetaLS4(8),ThetaLS4(9),dsYear1.DayOfTheYear), 'm*');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend( 'data','Third degree Sin/Cos model', 'Location', 'Northeast');


% Stopping code to show only the results
pause
% Close all the figure shown before
close all;
clc;