clc;clear;
illumdata;
n=10;
cvx_begin
    variable x(n)
    minimize norm(A*x-1, inf)
    subject to 
        0 <= x <= 1
cvx_end
p = max(abs(log(A*x)));