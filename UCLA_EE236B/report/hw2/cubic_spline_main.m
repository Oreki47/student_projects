clc;clear;
%%------------Setup--------------------
[t, y]=spline_data;
G=[];
A=[];
n=13;
for i=0:10
    [~, ~, gpp] = bsplines(i);
    G=[G; gpp'];
end

for i=1:length(t)
    [g, ~, ~] =bsplines(t(i));
    A=[A; g'];
end
%%------------CVX----------------------
cvx_begin
    variable x(n)
    minimize norm(A*x - y)
    subject to 
        G*x >= 0
cvx_end
%%-----------Plot----------------------
fp=0:.01:10;
fm=[];
for i=1:length(fp) 
    [g, ~, ~] =bsplines(fp(i));
    fm=[fm; g']; 
end
f=fm*x;
plot(t, y, 'o'), hold on,
plot(fp,f, 'r')
hold off;

