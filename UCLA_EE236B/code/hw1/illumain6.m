clc;clear;
illumdata;
n=10;
cvx_begin
    variable x(n)
    minimize max(max(A*x, inv_pos(A*x)))
    subject to 
        0 <= x <= 1
cvx_end
p = max(abs(log(A*x)));