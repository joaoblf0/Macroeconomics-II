%% Stationary Equilibrium

clear;
close all;

%% Asset demand (or supply of savings)

beta = 0.95;
Rvec = linspace(0.001,1/beta-1-1e-4,50)';
Avec = NaN*Rvec;

tic
for ii=1:length(Rvec)
    Avec(ii) = ss_demand(Rvec(ii),beta);
end
toc

%% Figures

% Preamble for figures
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',12)
set(0,'defaultLegendFontSize',12)

figure(1)
hold on
h1 = plot(Avec,Rvec,'b-','LineWidth',2.5);
h2 = xline(0,'-r','LineWidth',2.5);
yline(1/beta-1,'--k','LineWidth',1.5);
text(-0.8, 1/beta-1 +0.002,'$\beta^{-1}-1$')
grid on;
set(gca, 'YTickLabel', yticklabels, 'TickLabelInterpreter', 'latex');
%xlim([0 amax]);
title('Long-term asset demand and supply');
legend([h1, h2],'Asset demand (households)','Asset supply', 'location','southeast');

print -depsc2 'f_supply_demand.eps'  


