%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Macroeconomics II - Session 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameter calibration
beta = 0.99;
sigma = 5;
kappa = 1.2;
phi = 1.5;
rho = 0.05;
rho_m = 1.1;
sigma_m = 0.025;

% Matrix construction
g0 = [1 1/sigma 0 0; 0 beta 0 0; 0 -phi 1 -1; 0 0 0 1];
g1 = [1 0 1/sigma 0; -kappa 1 0 0; 0 0 0 0; 0 0 0 rho_m];
Psi = [0;0;0;sigma_m];
Pi = [1 1/sigma; beta 0; 0 0; 0 0];
Const = [-rho/sigma; 0; rho; 0];

% Gensys code to solve the system
[G1,C,impact,fmat,fwt,ywt,gev,eu,loose] = gensys(g0,g1,Const,Psi,Pi);

disp("eu vector");
disp(eu);

% Graphs
if eu==[1 1] 
    T=30;
    
    series = zeros(T+1,4);
    series(1, :) = impact; % Initial effect of the monetary shock
    for t=1:T
        series(t+1, :) = G1*series(t,:).';
    end
    
    subplot(2,2,1);
    plot(0:T, series(:,1), 'r', 'LineWidth',1.5);
    grid;
    title('$y_t$','Interpreter','latex');
    
    subplot(2,2,2);
    plot(0:T, series(:,2), 'r', 'LineWidth',1.5);
    grid;
    title('$\pi_t$','Interpreter','latex');
    
    subplot(2,2,3);
    plot(0:T, series(:,3), 'r', 'LineWidth',1.5);
    grid;
    title('$r_t$','Interpreter','latex');
    
    subplot(2,2,4);
    plot(0:T, series(:,4), 'r', 'LineWidth',1.5);
    grid;
    title('$u_t$','Interpreter','latex');
end



