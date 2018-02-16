function [a0, acc] = acc_gen(tf, dt, at)
lam = 0.25; tc = 0;
t = linspace(0, tf-dt, tf/dt)'; 
m = length(t);
acc = zeros(1, m);
if (round(rand) == 1)
    a0 = at;
else
    a0 = -at;
end
ii = 1;
while (tc <= tf)
   tc(ii + 1) = tc(ii) - log(rand)/lam;
   ii = ii + 1;
end
ii = 2;
for jj = 1:length(t)
    if(t(jj) > tc(ii))
        at = -at;
        ii = ii + 1;
    end
    acc(jj) = at;
end
% plot(t, acc, 'r', 'LineWidth',2),
% xlabel('time(s)'),
% ylabel('Acceleration(ft/sec^2)');
end