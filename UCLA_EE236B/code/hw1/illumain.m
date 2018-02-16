clc;clear;
illumdata;
r=0.01:0.01:1;
r1=ones(10,1)*r;
f0=max(abs(log(A*r1)));
plot(r,f0);
