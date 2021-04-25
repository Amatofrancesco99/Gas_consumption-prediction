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
%%daysWeek = table2array(readtable('../Dataset/gasITAday.xlsx', 'Range', 'B2:B732'))';
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
f = Fs*(0:(L/2))/L;
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
locsImpPeaks= locs(1:2);
ampImpPeaks= amp(1:2);
plot([0;locsImpPeaks],[ampPeakIn0;ampImpPeaks],'g*');
legend('ORIGINAL SIGNAL SPECTRUM','IMPORTANT PEAKS')


%% "REBUILD" ORIGINAL FUNCTION USING MOST IMPORTANT FREQUENCIES

% Remember how Fourier series are built
% If you don't remember, look at this link: https://en.wikipedia.org/wiki/Fourier_series
freqs = (locs-1)/days(end); 
signal_0=ampPeakIn0; 
signal=signal_0;
% Because important peaks are 4, as said in the "first observation" section
% (with the one in 0 included)
 for n=1:length(locsImpPeaks)
    %%if (n==3)
         %%signal=signal+amp(n)*square(freqs(n)*daysWeek,0.285);
    %%else
         signal = signal+amp(n)*cos(2*pi*freqs(n)*days-pi/8);
    %%end
end
figure(3)
plot(smooth(signal),'LineWidth',2);
% Added vertical lines to see better the different months gas consumption
for i = 1:24
       xline(i*30, 'm--');
end
hold on
plot(days,gas_consumption);
title('GAS CONSUMPTION FUNCTION (IN ITALY)');
xlabel('Days');
ylabel('Consumption (millionM^3)');
legend('Gas consumption prediction, using important frequencies','Real gas consumption trend');


%% MSE AND STANDARD DEVIATION OF FOURIER MODEL IDENTIFICATION

Residuals=(gas_consumption.'-signal);
SSR_Fourier=0;
for i = 1:length(Residuals)
       SSR_Fourier=SSR_Fourier+Residuals(i).^2;
end
SSR_Fourier
MSE_Fourier=SSR_Fourier/length(days);
sd_Fourier=sqrt(MSE_Fourier)


% Stopping code to show only the results
pause
% Close all the figure shown before
close all;
clc;