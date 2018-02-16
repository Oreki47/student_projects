clc;clear;
illumdata;
n=20;
m=10;
rho=0.1;
for i=1:100
    x=[A; sqrt(rho)*eye(m)]\[ones(n,1); sqrt(rho)*0.5*ones(m,1)];
    if(min(0<=x) && max(x<=1))
        break;
    else
        rho=rho+0.01;
    end
end

p = max(abs(log(A*x)));