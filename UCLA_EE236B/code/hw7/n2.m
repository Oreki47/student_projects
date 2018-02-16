clc;clear;
m = 50;
n = 40;
randn('state',0)
s = [.5 1 2 3];
A = randn(m,n);
xhat = sign(randn(n,1));
b = A*xhat + s(1)*randn(m,1);
cvx_begin
    variable x(n)
    minimize norm(A*x-b)
    subject to
        0 <= x <= 1
cvx_end