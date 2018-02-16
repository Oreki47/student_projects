warning('off','MATLAB:nargchk:deprecated');
A=[-1, 0, 1];
B=[1, 1, 0];
C=[1, 2, 0];
cvx_begin
    variable x(3,1)
    minimize(A*x)
    subject to
       B*x >= 1
       C*x <= 3
       x >= 0
cvx_end