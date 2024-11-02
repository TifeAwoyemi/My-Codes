function v = hybrid_model_testing_SPSD(y0, m, a, name)
% This code is non-linear Pachepsky (Continuous part)

r = 20;
ep = 0.5307; % Geng-Lutscher
te = 15000;  
        
[s, Ns, ts, Nts] = discretepart3(y0, ep, r, m, a, te);
[v, U] = uniquepart(Ns);
% discretepart3plot(s,Ns)   
end


function [v,U] = uniquepart(Ns)
U = Ns(end-100:end,2);
tol = 1e-3;
U = uniquetol(U,tol); 
v = length(U);
if U < tol
   v = 0;
end
if v > 16
   v = 16;
end
end
 
function discretepart3plot(s,Ns) 
figure, hold on,
subplot(1,2,1), plot(s,Ns(:,1),'kx')
subplot(1,2,2), plot(s,Ns(:,2),'kx')
end
 
function [s, Ns, ts, Nts] = discretepart3(y0, ep, r, m, a, te)
    s = zeros(1, 1+te);
    Ns = zeros(1+te, length(y0));
    tspan=0:.1:1; 
    ts = zeros(te*length(tspan),1); 
    Nts = zeros(te*length(tspan),length(y0)); 
    Ns(1,:) = y0;
    s(1) = 0;
    ind = 1; 
    for i = 1:te
        us = Ns(i,1);
        vs = Ns(i,2);
        y0 = [us, vs, 0];

        opt=odeset('RelTol',1e-4,'AbsTol',1e-7);
        [t, y] = ode45(@continuouspart3, tspan, y0, opt, ep, r, m, a); 
        f = y(end, 1);
        x = y(end, 2);
        b = y(end, 3);

        us1 = f(1);
        vs1 = x(1) * (1 + (b(1)));
        
        Ns(i+1,:) = [us1, vs1];
        s(i+1) = i;
        Nts(ind:(ind+length(tspan)-1),:)=y(:,1:2);
        ts(ind:(ind+length(tspan)-1))=(i-1)+tspan;
        ind=ind+length(tspan);
    end
end

function dy = continuouspart3(t, y, ep, r, m, a)
    f = y(1);
    x = y(2);
    b = y(3);
    
    df = r * f * (1 - f - (x / (1 + (ep * f))));
    dx = -m * x;
    db = a * f / (1 + (ep * f));
    dy = [df; dx; db];
end    