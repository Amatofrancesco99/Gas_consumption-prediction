%% THEORETICAL REFERENCES

% (1) CROSS-VALIDATION & MODEL IDENTIFICATION, WITH MATRIOSKA MODELS
%     (1.1)
% Remember that:  Y=fi*teta+V, assuming that E[V]=0 & Var[V]=sigma^2
% Moreover: TetaLS=(Fi^t*Fi)^-1*(Fi^t*Y), where ^t stands for transposition
% & Var[TetaLS]=sigma^2*(Fi^t*Fi)^-1
% Theta is the real parameter, ThetaLS instead is the extimated parameter

% Whenever sigma^2 is not known, how shall we calculate the standard deviation?
% sigma^2 not known ==> sigma_hat^2=SSR/(n-q)
% Where SSR=epsilon^t*epsilon
% Epsilon= Y- Y_hat_LS, where Y_hat_LS=fi*tetaLS.


%     (1.2)
% Fisher's Test ==> Fixed a level of significance alpha
% (tipically alpha = 0.05) search on the table falpha that satisfies:
%            P(F(1,N-q)<falpha)=(1-alpha)

% Then I could apply this simple roule:
% - If f<falpha ==> choose the model M(q-1)
% - If f>falpha ==> choose the model model M(q)
% (falpha is always calculated with the model with more parameters)

% M stands for matrioska models. On one hand we have M(q-1), the model with less
% parameters, on the other hand we have M(q), the model with more parameters (between the two models considered).
% f is an reduction index % of sum of squares of residues (SSR) which
% is obtained by passing from the simplest model to the most complex one and is
% calculated with this approach: 
%            f=(N-q)*[ (SSR(q-1)-SSR(q)) / SSR(q)]
% Taking as reference q (in N-q), the more complex model


%     (1.3)
%FPE= (N+q)/(N-q)*SSR
%MDL= [(ln(N)*q)/N]+ln(SSR)
%AIC= 2q/N+ln(SSR)


%     (1.4)
% A further criterion for choosing which models to choose,
% once you have identified the "best" models seen before you choose 
% those meeting the condition ("dogma"):
% variance of estimated parameter= 2 * standard deviation of estimated parameter
% In our case:      var_thetaLSX=2*std_thetaLSX
% Where X is the number of parameters in the model that we are considering

% If the condition is not met then the addition of that parameter
% in our model is superfluous


%% MODEL IDENTIFICATION WITH MATRIOSKA MODELS
% We shall use the first year to identify the model/s which is/are better
% representing our data, to predict also "future"/other data.
% The second year, instead, is used to verify if the identification model
% finded (with the first year) could be precise, or not. 

fprintf('MODEL IDENTIFICATION WITH MATRIOSKA MODELS');

% USEFUL VARIABLES
n=length(dsYear1.GasConsumption); %Number of observations
nVal=length(dsYear2.GasConsumption); % Number of observation (for validation)
% Array containing all values of the days in a week, that we will consider
daysOfTheWeek_grid=linspace(0,7,100); 
% Array containing all values of the days in a year, that we will consider
daysOfTheYear_grid=linspace(0,365,100); 
% We get the matrices with the two coordinates
[Dy, Dw]=meshgrid(daysOfTheYear_grid, daysOfTheWeek_grid);
Dw_vec=Dw(:);
Dy_vec=Dy(:);
alpha=0.05; %fixed the level of significance


% Only seeing the graph of the identification data we can see
% that the constant model would be too inaccurate, since the data does not
% are aligned along a plane that cuts the z-axis perpendicularly.
% By eye it is better to start from a plane with a certain slope, 
% and then to gradually more complex models (to evaluate the figures 
% of merit through different criteria and establish the best model).

%Read again the section of "THEORETICAL REFERENCES" (1.1)


% 1. FIRST DEGREE POLYNOMIAL MODEL:
Phi1= [ones(n,1), dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek ]; 
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

%Showing this model
% We create an ad hoc Phi by inserting as values not the vectors of
% observations, but vectors containing grid values
Phi1_grid=[ones(length(Dy_vec),1), Dy_vec, Dw_vec ]; 
shape1=Phi1_grid*ThetaLS1; %shape creation
shape1_matrix=reshape(shape1, size(Dy)); %Transform the shape in a matrix

figure
mesh(Dy,Dw,shape1_matrix);
hold on
%Overlay of observations to our model
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek , dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('first degree polynomial model' , 'data', 'Location', 'Northeast');


% 2. SECOND DEGREE POLYNOMIAL MODEL:
Phi2= [ones(n,1), dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek, (dsYear1.DayOfTheYear).^2 ...
      , (dsYear1.DayOfTheWeek).^2, (dsYear1.DayOfTheYear).*(dsYear1.DayOfTheWeek) ]; 
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

%Showing this model
% We create an ad hoc Phi by inserting as values not the vectors of
% observations, but vectors containing grid values
Phi2_grid=[ones(length(Dy_vec),1), Dy_vec, Dw_vec, Dy_vec.^2, Dw_vec.^2, Dy_vec.*Dw_vec ]; 
shape2=Phi2_grid*ThetaLS2; %shape creation
shape2_matrix=reshape(shape2, size(Dy)); %Transform the shape in a matrix

figure
mesh(Dy,Dw,shape2_matrix);
hold on
%Overlay of observations to our model
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek , dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('second degree polynomial model' , 'data', 'Location', 'Northeast');


% 3. THIRD DEGREE POLYNOMIAL MODEL:
Phi3= [ones(n,1), dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek, (dsYear1.DayOfTheYear).^2 ...
      , (dsYear1.DayOfTheWeek).^2, (dsYear1.DayOfTheYear).*(dsYear1.DayOfTheWeek) ...
      , dsYear1.DayOfTheYear.^3, dsYear1.DayOfTheWeek.^3, (dsYear1.DayOfTheYear.^2).*dsYear1.DayOfTheWeek ...
      , dsYear1.DayOfTheYear.*(dsYear1.DayOfTheWeek.^2)]; 
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

%Showing this model
% We create an ad hoc Phi by inserting as values not the vectors of
% observations, but vectors containing grid values
Phi3_grid=[ones(length(Dy_vec),1), Dy_vec, Dw_vec, Dy_vec.^2, Dw_vec.^2, Dy_vec.*Dw_vec ...
    , Dy_vec.^3, Dw_vec.^3, (Dy_vec.^2).*Dw_vec, Dy_vec.*(Dw_vec.^2) ]; 
shape3=Phi3_grid*ThetaLS3; %shape creation
shape3_matrix=reshape(shape3, size(Dy)); %Transform the shape in a matrix

figure
mesh(Dy,Dw,shape3_matrix);
hold on
%Overlay of observations to our model
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek , dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('third degree polynomial model' , 'data', 'Location', 'Northeast');


% 4. FOURTH DEGREE POLYNOMIAL MODEL:
Phi4= [ones(n,1), dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek, (dsYear1.DayOfTheYear).^2 ...
      , (dsYear1.DayOfTheWeek).^2, (dsYear1.DayOfTheYear).*(dsYear1.DayOfTheWeek) ...
      , dsYear1.DayOfTheYear.^3, dsYear1.DayOfTheWeek.^3, (dsYear1.DayOfTheYear.^2).*dsYear1.DayOfTheWeek ...
      , dsYear1.DayOfTheYear.*(dsYear1.DayOfTheWeek.^2) ... 
      , dsYear1.DayOfTheYear.^4, dsYear1.DayOfTheWeek.^4, (dsYear1.DayOfTheYear.^3).*dsYear1.DayOfTheWeek...
      , (dsYear1.DayOfTheYear.^2).*(dsYear1.DayOfTheWeek.^2) ...
      , dsYear1.DayOfTheYear.*(dsYear1.DayOfTheWeek.^3)]; 
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

%Showing this model
% We create an ad hoc Phi by inserting as values not the vectors of
% observations, but vectors containing grid values
Phi4_grid=[ones(length(Dy_vec),1), Dy_vec, Dw_vec, Dy_vec.^2, Dw_vec.^2, Dy_vec.*Dw_vec ...
    , Dy_vec.^3, Dw_vec.^3, (Dy_vec.^2).*Dw_vec, Dy_vec.*(Dw_vec.^2) ... 
    , Dy_vec.^4, Dw_vec.^4, (Dy_vec.^3).*Dw_vec, (Dy_vec.^2).*(Dw_vec.^2) ...
    , Dy_vec.*(Dw_vec.^3)]; 
shape4=Phi4_grid*ThetaLS4; %shape creation
shape4_matrix=reshape(shape4, size(Dy)); %Transform the shape in a matrix

figure
mesh(Dy,Dw,shape4_matrix);
hold on
%Overlay of observations to our model
plot3(dsYear1.DayOfTheYear, dsYear1.DayOfTheWeek , dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
legend('fourth degree polynomial model' , 'data', 'Location', 'Northeast');


% COMPARISON BETWEEN THE DIFFERENT MODELS IDENTIFIED
% A usable criterion (simple to assess, but certainly not that
% to take into account) is to look at the SSR.
% As it is easy to guess the SSR shrinks as we always complicate 
% more than the model.
% (SSR=Sum of square of residuals)
% It is therefore necessary to apply the principle of thrift: "not always
% the more complicated model is better" so much so that if on the one hand the SSR
% reduces by adding more and more parameters, our model on the other
% is increasingly tapping noise and so it means that my model
% is no longer sensitive to data alone, but to their noise.

% For this reason other criteria arise, including some subjective and
% other objectives. Let’s start with the subjective ones.


%FISHER'S TEST
% Read again the section of "THEORETICAL REFERENCES" (1.2)

%Compare: FIRST DEGREE POLYNOMIAL MODEL vs SECOND DEGREE POLYNOMIAL MODEL
falpha2=finv(1-alpha, 1, n-q2);
f2= (n-q2)*((SSR1-SSR2)/SSR2);
%Compare: SECOND DEGREE POLYNOMIAL MODEL vs THIRD DEGREE POLYNOMIAL MODEL
falpha3=finv(1-alpha, 1, n-q3);
f3= (n-q3)*((SSR2-SSR3)/SSR3);
%Compare: THIRD DEGREE POLYNOMIAL MODEL vs FOURTH DEGREE POLYNOMIAL MODEL
falpha4=finv(1-alpha, 1, n-q4);
f4= (n-q4)*((SSR3-SSR4)/SSR4);

% Fisher's Test says the better model is the second degree polynomial 


% OBJECTIVE CRITERIONS: MDL,AIC,FPE 
% Read again the section of "THEORETICAL REFERENCES" (1.3)

%Objective criteria for the first degree model:
FPE1= ((n+q1)/(n-q1))*SSR1;
MDL1= ((log(n)*q1)/n)+log(SSR1);
AIC1= ((2*q1)/n) + log(SSR1);
%Objective criteria for the second degree model:
FPE2= ((n+q2)/(n-q2))*SSR2;
MDL2= ((log(n)*q2)/n)+log(SSR2);
AIC2= ((2*q2)/n) + log(SSR2);
%Objective criteria for the third degree model:
FPE3= ((n+q3)/(n-q3))*SSR3;
MDL3= ((log(n)*q3)/n)+log(SSR3);
AIC3= ((2*q3)/n) + log(SSR3);
%Objective criteria for the fourth degree model:
FPE4= ((n+q4)/(n-q4))*SSR4;
MDL4= ((log(n)*q4)/n)+log(SSR4);
AIC4= ((2*q4)/n) + log(SSR4);

% Choosing as the optimal model (of the single objective test), the one that 
% minimizes the amount of merit between the different models considered we note that
% for AIC, MDL & FPE, the better model is the fourth degree model.


% Read again the section of "THEORETICAL REFERENCES" (1.4)

% Stopping code to show only matrioska model identification results
pause
% Close all the figure shown before
close all;
clc;

%% CROSS-VALIDATION
% Clearly we use validation data to see which model
% better generalizes even new data, minimizing error/deviation
% between expected data and those actually present among those of
% validation.

fprintf('CROSS-VALIDATION');

% DATA DISPLAY
%Plotting identification and validation data on a 3D graph
figure
%Plotting identification data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek,dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1,2');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
%Plotting validation data
hold on
plot3(dsYear2.DayOfTheYear,dsYear2.DayOfTheWeek,dsYear2.GasConsumption,'r+');
legend('identification data','validation data','Location','Northeast'); 

%We estimate the performance of different models now, going to use however
%estimated parameters with new data (validation data)

% 1. FIRST DEGREE POLYNOMIAL MODEL
Phi1Val=[ones(nVal,1), dsYear2.DayOfTheYear, dsYear2.DayOfTheWeek]; 
y_hat1Val=Phi1Val*ThetaLS1;
epsilon1Val=dsYear2.GasConsumption-y_hat1Val;
SSR1Val=epsilon1Val'*epsilon1Val;

% 2. SECOND DEGREE POLYNOMIAL MODEL
Phi2Val=[ones(nVal,1), dsYear2.DayOfTheYear, dsYear2.DayOfTheWeek ...
    , (dsYear2.DayOfTheYear).^2, (dsYear2.DayOfTheWeek).^2 , (dsYear2.DayOfTheYear).*(dsYear2.DayOfTheWeek)]; 
y_hat2Val=Phi2Val*ThetaLS2;
epsilon2Val=dsYear2.GasConsumption-y_hat2Val;
SSR2Val=epsilon2Val'*epsilon2Val;

% 3. THIRD DEGREE POLYNOMIAL MODEL
Phi3Val=[ones(nVal,1), dsYear2.DayOfTheYear, dsYear2.DayOfTheWeek ...
    , (dsYear2.DayOfTheYear).^2, (dsYear2.DayOfTheWeek).^2 , (dsYear2.DayOfTheYear).*(dsYear2.DayOfTheWeek) ...
    , (dsYear2.DayOfTheYear).^3, (dsYear2.DayOfTheWeek).^3 ...
    , ((dsYear2.DayOfTheYear).^2).*(dsYear2.DayOfTheWeek), (dsYear2.DayOfTheYear).*((dsYear2.DayOfTheWeek).^2)]; 
y_hat3Val=Phi3Val*ThetaLS3;
epsilon3Val=dsYear2.GasConsumption-y_hat3Val;
SSR3Val=epsilon3Val'*epsilon3Val;

% 4. FOURTH DEGREE POLYNOMIAL MODEL
Phi4Val=[ones(nVal,1), dsYear2.DayOfTheYear, dsYear2.DayOfTheWeek ...
    , (dsYear2.DayOfTheYear).^2, (dsYear2.DayOfTheWeek).^2 , (dsYear2.DayOfTheYear).*(dsYear2.DayOfTheWeek) ...
    , (dsYear2.DayOfTheYear).^3, (dsYear2.DayOfTheWeek).^3 ...
    , ((dsYear2.DayOfTheYear).^2).*(dsYear2.DayOfTheWeek), (dsYear2.DayOfTheYear).*((dsYear2.DayOfTheWeek).^2) ...
    , (dsYear2.DayOfTheYear).^4, (dsYear2.DayOfTheWeek).^4, ((dsYear2.DayOfTheYear).^3).*(dsYear2.DayOfTheWeek) ...
    , ((dsYear2.DayOfTheYear).^2).*((dsYear2.DayOfTheWeek).^2) ...
    , (dsYear2.DayOfTheYear).*((dsYear2.DayOfTheWeek).^3)];
y_hat4Val=Phi4Val*ThetaLS4;
epsilon4Val=dsYear2.GasConsumption-y_hat4Val;
SSR4Val=epsilon4Val'*epsilon4Val;


% This time, to choose the best model let’s see which is the
% model that minimizes the SSR (Ssrval) between the data provided by the model and
% those that are the new data, that is those of validation.
% In this case, with cross-validation, the best model is the third degree one.


% Show best model for cross-validation, with all data (validation &
% identification) 
%Plotting identification and validation data on a 3D graph
figure
%Plotting identification data
plot3(dsYear1.DayOfTheYear,dsYear1.DayOfTheWeek,dsYear1.GasConsumption,'o');
grid on
title ('GAS CONSUMPTION IN ITALY (3D), in function of day of a Year and day of a week -- Year 1,2');
xlabel('DayOfTheYear');
ylabel('DayOfTheWeek');
zlabel('GasConsumption');
%Plotting validation data
hold on
plot3(dsYear2.DayOfTheYear,dsYear2.DayOfTheWeek,dsYear2.GasConsumption,'r+');
%Plotting best model for cross-validation (Third degree model)
mesh(Dy,Dw,shape3_matrix);
legend('identification data','validation data', 'third degree polynomial model','Location','Northeast'); 


% Stopping code to show the result of cross-validation
pause
% Close all the figure shown before
close all;
clc;