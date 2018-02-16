clc;clear;
rand('state',0);
n = 40;
X = 30*[rand(1,n); rand(1,n)];
delta = 15*pi/180;
t_tar=15*pi/180;
N = 400 ; 
theta = linspace(t_tar + delta, 2*pi + t_tar-delta, N)';
A = exp(1i*[cos(theta), sin(theta)]*X);
F = exp(1i*[cos(t_tar), sin(t_tar)]*X);
cvx_begin
    variable omega(n) complex 
    minimize  max(abs(A*omega))
    subject to
        F*omega == 1 
cvx_end
t = linspace(-180, 180, N)';
A1 = exp(1i * [cosd(t), sind(t)]*X);
g = abs(A1*omega);
semilogy(t, g);
