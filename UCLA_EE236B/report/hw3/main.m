clc;clear;
N = 30;n = 3;
A = [-1, .4, .8; 1, 0, 0; 0, 1, 0];
b = [1; 0; 0.3];
x_des = [7; 2; -6];
x_init = zeros(n, 1);
cvx_begin
    variable x(n, N+1)
    variable u(1, N)
    minimize (sum(max(abs(u), 2*abs(u)-1)))
    subject to 
        x(:, 2 : N+1) == A*x(:, 1 : N) + b*u
        x(:, 1) == x_init;
        x(:, N+1) == x_des;
cvx_end
stairs(0 : N-1, u, 'LineWidth', 2)
xlabel('t')
ylabel('u')