clc;clear;
illumdata;
b=ones(20,1);
x=A\b;
x1=[1 0 1 0 0 1 0 1 0 1];
p = max(abs(log(A*x1')));