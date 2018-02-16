    % Build up acc vector with correlation to a_0
%     for iter_sub = 1:length(t)
%         a_cor(length(t) - iter_sub + 1) = exp(-t(iter_sub)/tau);
%     end
%     for iter_sub = 1:length(t)
%         rho = a_cor(iter_sub);
%         a(iter_sub) = rho*a_0 + sqrt(1-rho^2)*normrnd(a_mean, a_sigma);
%     end