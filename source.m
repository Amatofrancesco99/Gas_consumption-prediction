%% ANNOTAZIONE SUL CODICE 


%% RICHIAMI DI TEORIA


%% AZIONI PRELIMINARI 
%(PULIZIA MATLAB)
clear;
clc;
close all;


%% SVOLGIMENTO
% Importo la tabella, selezionando solo i dati a cui sono interessato a
% visualizzare
dsAnno1=readtable('./Dataset/gasITAday.xlsx', 'Range', 'A3:C367');
dsAnno2=readtable('./Dataset/gasITAday.xlsx', 'Range', 'A368:C732');

% Modifico i nomi delle colonne del dataset
dsAnno1.Properties.VariableNames{1}='GiornoAnno';
dsAnno1.Properties.VariableNames{2}='GiornoSettimana';
dsAnno1.Properties.VariableNames{3}='Dati';

dsAnno2.Properties.VariableNames{1}='GiornoAnno';
dsAnno2.Properties.VariableNames{2}='GiornoSettimana';
dsAnno2.Properties.VariableNames{3}='Dati';

%Plottiamo i grafici dei due anni
%Anno1
figure(1);
subplot(2,1,1);
plot(dsAnno1.GiornoAnno,dsAnno1.Dati, 'Linewidth' , 2);
xlabel('Days of Year 1');
ylabel('Consumption (millionM^3)');
grid on
%Anno2
subplot(2,1,2);
plot(dsAnno2.GiornoAnno,dsAnno2.Dati, 'r', 'Linewidth' , 2);
xlabel('Days of Year 2');
ylabel('Consumption (millionM^3)');
grid on

%% CONCLUSIONE


%% PROGRAM MADE BY FRANCESCO AMATO, FILIPPO ROGNONI & FRANCESCO MINAGLIA