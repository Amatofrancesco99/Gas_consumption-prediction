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
      fprintf('Insert the day of the week (it must be an integer)');
      fprintf('(Remember that 1 is Sunday, 7 is Saturday)');
      DayOfTheWeek=str2int(input());
  end
  while ((DayOfTheYear<=0 || DayOfTheYear>365))
      fprintf('Insert the day of the year (it must be an integer, from 1 to 365)');
      DayOfTheYear=str2int(input());
  end
  
  % Gas consumption prediction using best model

  % Ask if you want to continue/end insert new values and predicting gas
  % consumes
  fprintf('You want to end the prediction of gas consumption inserting new values of day')
  fprintf('of the week and day of the year?');
  fprintf('(0=continue, 1=end)');
  END=str2int(input());
end
