%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Macroeconomics II - Session 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var y_hat pi r u_m;
varexo var_eps;
parameters sigma sigma_m rho beta phi rho_m kappa;

% Parameter calibration
beta = 0.99;
sigma = 5;
kappa = 1.2;
phi = 1.5;
rho = 0.05;
rho_m = 0.5;
sigma_m = 0.025;

model(linear);
// DIS 
y_hat = y_hat(+1) - (1/sigma)*(r-pi(+1)-rho);

// PC
pi = beta*pi(+1)+kappa*y_hat;

// MP rule
r = rho + phi*pi + u_m;

// Monetary Shock
u_m = rho_m*u_m(-1) + sigma_m*var_eps;
end;


shocks;
    var var_eps = 1;
end;


stoch_simul(order=1, irf=30) y_hat pi r u_m;

