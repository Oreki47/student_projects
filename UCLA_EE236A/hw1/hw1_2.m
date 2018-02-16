A=[22,18,25,24,27];
B=[.7, .25, .4, .2, .5];
C=[.1, .15, .5, .5, .4];
D=[.2, .6, .1, .3, .1];

cvx_begin
    variable x(5,1)
    minimize(A*x)
    subject to
       B*x == .4
       C*x == .35
       D*x == .25
       sum(x) == 1
       x >= 0
cvx_end