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


%% PLOT 2D GAS CONSUMPTION (both Years)

fprintf('MODEL IDENTIFICATION, USING FOURIER THEORY\n');

% days of both years
days = linspace(1,730,730);
% gas consumption during both years
gas_consumption = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'C3:C732'));


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
f = Fs*(0:(L/2))/L;
plot(f,P1); 
grid on
title('SPECTRUM OF THE GAS CONSUMPTION FUNCTION');
xlabel('frequency (mHz)')
ylabel('FFT Gas Consumption')


%% FIND ALL PEAKS OF THE SIGNAL SPECTRUM

hold on
%Find important peaks of the signal spectrum
[amp,locs] = findpeaks(P1);
% Because findpeaks function does not find the peak in 0, we insert it
% manually
ampPeakIn0= 85.61;
%Show only important peaks on plot shown before
plot([0;locs(1:3)],[ampPeakIn0;amp(1:3)],'g*');
legend('ORIGINAL SIGNAL SPECTRUM','IMPORTANT PEAKS')


%% "REBUILD" ORIGINAL FUNCTION USING MOST IMPORTANT FREQUENCIES

% Remember how Fourier series are built
% If you don't remember, look at this link: https://en.wikipedia.org/wiki/Fourier_series
freqs = (locs-1)/days(end); 
signal_0=ampPeakIn0/2; 
signal=0;
% Because important peaks are 4, as said in the firs observation section
% (with the one in 0 included)
for n=1:3
    signal = (signal+signal_0+amp(n)*cos(2*pi*freqs(n)*days)+amp(n)*sin(2*pi*freqs(n)*days)); 
end
figure(3)
plot(smooth(signal));
% Added vertical lines to see better the different months gas consumption
for i = 1:24
       xline(i*30, 'm--');
end
title('GAS CONSUMPTION FUNCTION (IN ITALY): reconstruction, using only frequencies with important contribution');
xlabel('Days');
ylabel('Consumption (millionM^3)');


% Stopping code to show only the results
pause
% Close all the figure shown before
close all;
clc;