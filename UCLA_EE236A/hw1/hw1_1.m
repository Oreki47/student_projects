clc;clear;
%warning('off','MATLAB:nargchk:deprecated');
profit = [8, 65 - 2*8, 120 - 1*65];
timeEq = [1, 2, 3];
AB = [1, -2, 0];
BC = [0, 1, -1];
profit1 = [60, 65 - 2*60, 120 - 1*65];
profit2 = [8, 100 - 2*8, 120 - 1*100];

cvx_begin
    variable x(3,1)
    maximize(profit2*x)
    subject to
       timeEq*x <= 60
       x >= 0
       AB*x >= 0
       BC*x >= 0      
cvx_end