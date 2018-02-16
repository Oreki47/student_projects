clc;clear;
c_l = [1.5 1 5]';
w_max = 10;
w_min = 0.1;

n = 50;
u = logspace(-3,3,n);
a_1 = zeros(1,n);
d_1 = zeros(1,n);

for i=1:n
    cvx_begin gp
    variables t w(6)
    C = w;
    R = 1./w;
    minimize( sum(w) + u(i)*t )
    subject to
    w / w_max <= 1.0;
    w_min ./ w <= 1;
    (C(3) + c_l(1)) * sum(R([1,2,3])) ...
    + C(2) * sum(R([1,2])) ...
    + (sum(C([1,4,5,6])) + sum(c_l([2,3]))) * R(1) <= t;
    (C(5) + c_l(2)) * sum(R([1,4,5])) ...
    + C(4) * sum(R([1,4])) ...
    + (C(6) + c_l(3)) * sum(R([1,4])) ...
    + (sum(C([1,2,3])) + c_l(1)) * R(1) <= t;
    (C(6) + c_l(3)) * sum(R([1,4,6])) ...
    + C(4) * sum(R([1,4])) ...
    + sum(C([1,2,3]) + c_l(1)) * R(1) ...
    + (C(5) + c_l(2)) * sum(R([1,4])) <= t;
    cvx_end
    d_1(i) = t;
    a_1(i) = sum(w);
end;

n=100;
ws = logspace(-1,1,n);
a_2 = zeros(1,n);
d_2 = zeros(1,n);
for i=1:length(ws)
    w = ws(i)*ones(6,1);
    a_2(i) = sum(w);
    C = w;
    R = 1./w;
    t1 = (C(3) + c_l(1)) * sum(R([1,2,3])) ...
    + C(2) * sum(R([1,2])) ...
    + (sum(C([1,4,5,6])) + sum(c_l([2,3]))) * R(1);
    t2 = (C(5) + c_l(2)) * sum(R([1,4,5])) ...
    + C(4) * sum(R([1,4])) ...
    + (C(6) + c_l(3)) * sum(R([1,4])) ...
    + (sum(C([1,2,3])) + c_l(1)) * R(1);
    t3 = (C(6) + c_l(3)) * sum(R([1,4,6])) ...
    + C(4) * sum(R([1,4])) ...
    + sum(C([1,2,3]) + c_l(1)) * R(1) ...
    + (C(5) + c_l(2)) * sum(R([1,4]));
    d_2(i) = max([t1, t2, t3]);
end;
plot(a_1, d_1, '-', a_2, d_2, '--');