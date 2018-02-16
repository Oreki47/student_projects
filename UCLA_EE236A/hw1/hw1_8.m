%% Profit Optimization
warning('off','MATLAB:nargchk:deprecated');
m = 100;
%%      | x1|  x2|  x3|  x4|  x5|  x6|  x7|  x8|  x9|  x10|
A=      [-2.8   0 -1.3  3.14 -1.9  1.5 -1.8  4.1    0 1.96];
zeroV = [   0   1    0     0    0    0    0    0    1    0];
day1b = [ 2.8   0    0     0    0    0    0    0    0    0];
day2s = [  -1   0    0     1    0    0    0    0    0    0];
day2b = [ 2.8   0  1.3 -3.14    0    0    0    0    0    0];
day3s = [  -1   0   -1     1    0    1    0    0    0    0];
day3b = [ 2.8   0  1.3 -3.14  1.9 -1.5    0    0    0    0];
day4s = [  -1   0   -1     1   -1    1    0    1    0    0];
day4b = [ 2.8   0  1.3 -3.14  1.9 -1.5  1.8 -4.1    0    0];
day5s = [  -1   0   -1     1   -1    1   -1    1    0    1];
cvx_begin
    variable x(10)
    minimize -(A*x) - m
    subject to
        zeroV*x == 0
        day1b*x <= m
        day2s*x <= 0
        day2b*x <= m
        day3s*x <= 0
        day3b*x <= m
        day4s*x <= 0
        day4b*x <= m
        day5s*x == 0
        x >= 0

cvx_end