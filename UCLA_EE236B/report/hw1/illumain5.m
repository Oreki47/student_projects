clc;clear;
illumdata;
n=10;
cvx_begin
    variable x(n)
    minimize max(max(max(max(A*x, 4-4*A*x), 2.5-A*x/0.64), 2-A*x))
    subject to 
        0 <= x <= 1
cvx_end
p = max(abs(log(A*x)));