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


%% SPECTRUM OF THE GAS CONSUMPTION FUNCTION (EXTIMATION WITH PERIODOGRAM)

figure(2)
[Periodogram,f]=periodogram(gas_consumption,[],[],1000);
plot(f,Pxx);
title('SPECTRUM OF THE GAS CONSUMPTION FUNCTION');
xlabel('frequency (Hz)')
ylabel('FFT Gas Consumption')


%% FIND IMPORTANT FREQUENCY PEAKS, IN FFT FUNCTION
[peaksHeight,peaksLocation]=findpeaks(Periodogram);


% Calcoliamo una funzione spettrale costituita solamente dai tre picchi
% fondamentali che abbiamo precedentemente individuato


% Let's calculate the signal function using only important frequencies



% Stopping code to show only the results
pause
% Close all the figure shown before
close all;
clc;