clc;clear;
one_bit_meas_data;

A = diag(y)*A;
b = y.*b;
x = A\b;
for k = 1 : 50
   w = A*x - b;
   Phi = 0.5*erfc(-w/sqrt(2));
   Phix = 0.5*sqrt(2*pi)*erfcx(-w/sqrt(2));
   obj = -sum(log(Phi));
   grad = -A'*(1./Phix);
   hess = A'*diag((w+1./(Phix))./Phix)*A;
   v = -hess\grad;
   f = grad'*v;
   if (-f/2 < 1e-8)
       break;
   end
   t = 1;
   while(-sum(log(0.5*erfc(-(A*(x+t*v)-b)/sqrt(2)))) > ...
        obj + 0.01*t*f)
        t = t/2;
   end
   x = x + t*v;
end
