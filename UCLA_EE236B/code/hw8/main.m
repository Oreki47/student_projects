clc;clear;
nonlin_meas_data;
B = [-eye(m - 1), zeros(m - 1, 1)] ...
    + [zeros(m - 1, 1), eye(m - 1)];
cvx_begin
    variables x(n) z(m);
    minimize( norm( z - A*x ) );
    subject to
        (B*y)/beta <= B*z;
        B*z <= (B*y)/alpha;
cvx_end

figure(1), plot(z, y),
figure(2), scatter(A*x, y, '.');