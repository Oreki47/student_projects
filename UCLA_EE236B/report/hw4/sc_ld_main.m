clc;clear;
spacecraft_landing_data;
K =25;
e33 = [zeros(2, K);ones(1, K)];
F =Fmax *ones(1, K+1);
cvx_begin
    variable x(9, K+1)
    minimize sum(norms(x(1:3,:)))
    subject to 
        norms(x(1:3,:)) <= F
        alpha*norms(x(4:5,:)) - x(6,:) <=0
        x(7:9, 2:K+1) == x(7:9, 1:K) + (h/m)*x(1:3, 1:K) - h*g*e33
        x(4:6, 2:K+1) == x(4:6, 1:K) + (h/2)*(x(7:9, 2:K+1) + x(7:9, 1:K))
        x(4:6, 1) == p0
        x(7:9, 1) == v0
        x(4:9, K+1) == 0
cvx_end