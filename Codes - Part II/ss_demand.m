function A = ss_demand(r,beta)


%% PARAMETERS

% preferences
risk_aver   = 2;
% beta        = 0.95;

%returns
%r           = 0.03;
%r = 1/beta - 1;
R = 1+ r;

% income risk: discretized N(mu,sigma^2)
mu_y    = 1;
sd_y    = 0.2;
ny      = 5;

% asset grids
na          = 500;
amax        = 20; 
borrow_lim  = -1;
agrid_par   = 1; %1 for linear, 0 for L-shaped

% computation
max_iter    = 1000;
tol_iter    = 1.0e-6;
Nsim        = 50000;
Tsim        = 500;

%% OPTIONS
Display     = 0;
DoSimulate  = 1;
%MakePlots   = 1;

%% DRAW RANDOM NUMBERS
rng(2017);
yrand = rand(Nsim,Tsim);

%% SET UP GRIDS

% assets
agrid = linspace(0,1,na)';
agrid = agrid.^(1./agrid_par);
agrid = borrow_lim + (amax-borrow_lim).*agrid;

% income: disretize normal distribution
width = fzero(@(x) discrete_normal(ny,mu_y,sd_y,x),2);
[~,ygrid,ydist] = discrete_normal(ny,mu_y,sd_y,width);
ycumdist = cumsum(ydist);
    % discrete_normal fun: given width, creates equally spaced 
    %                      approximation to normal distribution
    % find the width that matches the standard deviation

%% UTILITY FUNCTION

if risk_aver==1
    u = @(c)log(c);
else    
    u = @(c)(c.^(1-risk_aver)-1)./(1-risk_aver);
end    

%% INITIALIZE VALUE FUNCTION

Vguess = zeros(na,ny);
for iy = 1:ny
    Vguess(:,iy) = u(r.*agrid+ygrid(iy))./(1-beta);
end
% Vguess = ones(na,ny);

%% ITERATE ON VALUE FUNCTION

V = Vguess;

Vdiff = 1;
iter = 0;

while iter <= max_iter && Vdiff>tol_iter
    iter = iter + 1;
    Vlast = V;
    V = zeros(na,ny);
    sav = zeros(na,ny);
    savind = zeros(na,ny);
    con = zeros(na,ny);
    
    % loop over assets
    for ia = 1:na
        
        % loop over income
        for iy = 1:ny
            cash = R.*agrid(ia) + ygrid(iy);
            Vchoice = u(max(cash-agrid,1.0e-10)) + beta.*(Vlast*ydist);           
            [V(ia,iy),savind(ia,iy)] = max(Vchoice);
            sav(ia,iy) = agrid(savind(ia,iy));
            con(ia,iy) = cash - sav(ia,iy);
       end
    end
    
    
    Vdiff = max(max(abs(V-Vlast)));
    if Display >=1
        disp(['Iteration no. ' int2str(iter), ' max val fn diff is ' num2str(Vdiff)]);
    end
end    



%% SIMULATE
if DoSimulate ==1
    yindsim = zeros(Nsim,Tsim);
    aindsim = zeros(Nsim,Tsim);
    
    % initial assets
    aindsim(:,1) = 1;
    
    %loop over time periods
    for it = 1:Tsim
        if Display >=1 && mod(it,100) ==0
            disp([' Simulating, time period ' int2str(it)]);
        end
        
        %income realization: note we vectorize simulations at once because
        %of matlab, in other languages we would loop over individuals
        yindsim(yrand(:,it)<= ycumdist(1),it) = 1;
        for iy = 2:ny
            yindsim(yrand(:,it)> ycumdist(iy-1) & yrand(:,it)<=ycumdist(iy),it) = iy;
        end
        
        % asset choice
        if it<Tsim
            for iy = 1:ny
                aindsim(yindsim(:,it)==iy,it+1) = savind(aindsim(yindsim(:,it)==iy,it),iy);
            end
        end
    end
    
    %assign actual asset and income values;
    asim = agrid(aindsim);
    %ysim = ygrid(yindsim);

end

A = mean(asim(:,Tsim));