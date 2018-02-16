clc;clear;
spacecraft_landing_data;
for i = 1:35 
   K = i;
   sc_ld_main;
   clc;
   if cvx_optval ~= Inf
       break;
   end
end