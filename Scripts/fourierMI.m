%% RAGIONAMENTO
% Quello che vogliamo fare è riuscire a capire quali sono le frequenze
% fondamentali che caratterizzano il nostro segnale. Immaginiamo esse
% siano:
% - Una frequenza costante che rappresenta l'andamento medio di consumo di
%   gas durante l'anno; 
% - Una frequenza che rappresenti la frequenza semestrale (coseno/seno)
% - Una frequenza che rappresenti l'andamento settimanale (coseno/seno)


%% PLOT 2D GAS CONSUMPTION (both Years)

% date of both years
date = linspace(1,730,730);
gas_consumption = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C3:C732'));


figure(1)
%Year 1
plot(date,gas_consumption);
title('GAS CONSUMPTION IN ITALY (2D) -- Two Years');
xlabel('Days');
ylabel('Consumption (millionM^3)');
% Added vertical lines to see better the different months gas consumption
for i = 1:24
       xline(i*30, 'm--');
end


%% SPECTRUM OF THE GAS CONSUMPTION FUNCTION

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 730;              % Length of signal (number of days)
t = (0:L-1)*T;        % Time vector

fftGasConsumption=fft(gas_consumption);
P2 = abs(fftGasConsumption/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure()
plot(f,P1) 
title('SPECTRUM OF THE GAS CONSUMPTION FUNCTION');
xlabel('frequency (Hz)')
ylabel('FFT Gas Consumption')


%% FIND IMPORTANT FREQUENCY PEAKS, IN FFT FUNCTION
%pks = findpeaks(fftGasConsumption);
pks=[0 2.74 5.4]; %frequency of peaks
height_pks = [85.61 78.57 24.04]; %height of peaks


% Calcoliamo una funzione spettrale costituita solamente dai tre picchi
% fondamentali che abbiamo precedentemente individuato


% Let's calculate the signal function using only important frequencies



% Stopping code to show only the results
pause
% Close all the figure shown before
close all;
clc;