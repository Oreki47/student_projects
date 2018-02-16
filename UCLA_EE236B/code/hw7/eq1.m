syms x
eqn = 1/(x-3)^2 + 1/(1+x)^2 +1/(2+x)^2 == 1;
solx = solve(eqn,x);
x = double(solx(1:4));
a1=1./(3-x);
a2=-1./(1+x);
a3=-1./(2+x);
c = -3*a1.^2 + a2.^2 + 2*a3.^2 +2*(a1 + a2 + a3);