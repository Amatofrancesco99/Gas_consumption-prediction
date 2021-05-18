%% PREDICTION FUNCTION ONLY

% prediction function
function s_hat=prediz(dy,dw)
    x=dy;
    x2=dw;
    % Second degree harmonic function
    % The numeric value of the coefficient of the sin/cos terms are the same
    % one we've found in live_script.mlx
    s_hat=92.335926898759130 + 81.438247639981800*cos(x*((2*pi)/365)) + 34.239314268549640*sin(x*((2*pi)/365)) + -6.681112039616750*cos(x2*((2*pi)/7)) + -2.675412560965765*sin(x2*((2*pi)/7))+ 17.885671526017582*cos(x*((4*pi)/365)) + 17.376574512281540*sin(x*((4*pi)/365)) + -2.382534793449163*cos(x2*((4*pi)/7)) + -3.929506835007748*sin(x2*((4*pi)/7));
end