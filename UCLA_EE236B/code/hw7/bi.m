clc;clear;
m = 50;
n = 40;

for i=1:4
    randn('state',0)
    s = [.5 1 2 3];
    A = randn(m,n);
    xhat = sign(randn(n,1));
    b = A*xhat + s(i)*randn(m,1);
    cvx_begin sdp
        variable z(n);
        variable Z(n,n) symmetric;
        minimize (trace(A'*A*Z)-2*b'*A*z + b'*b)
        subject to
            [Z z; z' 1] >= 0
            diag(Z) == 1;
    cvx_end
    clc;
    % x_a
    f1(i) = norm(A*sign((A\b))-b);
    % x_b
    f2(i) = norm(A*sign(z)-b);
    % x_c
    [v, ~] = eig([Z z; z' 1]);
    f3(i) = norm(A*sign(v(1:n, n+1))-b);
    % x_d
    f4(i) = 1000;
    for j = 1:100
        f4_temp = norm(A*sign(mvnrnd(z,Z-z*z')')-b);
        if (f4_temp <= f4(i))
            f4(i) = f4_temp;
        end
    end
    % dual
    dual(i) = sqrt(trace(A'*A*Z)-2*b'*A*z + b'*b);
end