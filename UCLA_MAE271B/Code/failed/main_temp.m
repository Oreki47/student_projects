% -------------------------------------------
% MAE 271B Project
% Zhiyuan Cao
% 02/27/17
% -------------------------------------------
clc;clear;
% -------------------------------------------
% GLOBAL CONSTANTS
% -------------------------------------------
v_c = 300;                       % ft/sec
t_f = 10;                        % sec
R_1 = 15e-6;                     % rad^2sec
R_2 = 1.67e-3;                   % rad^2sec^3
tau = 2;                         % sec
dt = 0.01;                       % sec
t = linspace(0, t_f-dt, t_f/dt)'; % discrete t
n = length(t);
num_sim = 1;
% -------------------------------------------
% STATS
% -------------------------------------------
y_mean = 0;
v_mean = 0;
a_mean = 0;
n_mean =0;                       
y_sigma = 0;
v_sigma = 200;
a_sigma = 100;
% ---------------------------------------
% STATE SPACE
% ---------------------------------------
F = [0 1 0; 0 0 -1; 0 0 -1/tau];
B = [0 1 0]';
G = [0 0 1]';
% -------------------------------------------
% Main Loop
% -------------------------------------------
for iter_main = 1:num_sim
    % -------------------------------------------
    % DATA STRUCTURE
    % -------------------------------------------
    d_x = zeros (3, n);         % Actual Delta x
    x = zeros(3, n);            % Actual State x
  
    V = zeros(1, n);            % Noise Variance
    noise = zeros(1, n);        % Noise
    z = zeros(1, n);            % Measurement
    
    x_hat = zeros(3, n);        % Estimate State x
    d_x_hat = zeros(3, n);      % Estimate Delta x
    P = zeros(3, 3, n);         % Variance
    K = zeros(3, n);            % Kalman Gain
    err = zeros(3, n);          % Error
    res = zeros(1, n);          % Residues
    % ---------------------------------------
    % INITILIZE VALUES
    % ---------------------------------------
    H = [1/(v_c*t_f) 0 0];
    y_0 = 0;       
    v_0 = normrnd(v_mean, v_sigma);
    a_0 = normrnd(a_mean, a_sigma); 
    x(:, 1) = [y_0, v_0, a_0]';

    
    z(:, 1) = H*x(:, 1) + noise(1);
    
    P(:, :, 1) = [0 0 0; 0 v_sigma^2 0; 0 0 a_sigma^2];
    K(:, 1) = P(:, :, 1)*H'/V(1);
    
    d_x_hat(:, 1) = F*x_hat(:, 1)...
        + K (:, 1)*(z(:, 1) - H*x_hat(:, 1)); 
    
    for i = 1:n
        V(i) = sqrt(R_1 + R_2/(t_f-t(i))^2);
        noise(i) = normrnd(n_mean, V(i));
    end
    % ---------------------------------------
    % ACTUAL STATE
    % ---------------------------------------
    for i = 1 : n - 1      
        a = normrnd(a_mean, a_sigma/sqrt(dt));
        d_x(:, i + 1) = F*x(:, i) + G*a;       
     
        x(:, i + 1) = x(:, i) + d_x(:, i)*dt;
        H = [1/((v_c*(t_f - t(i + 1)))) 0 0];
        
        z(:, i + 1) = H*x(:, i);
    end
    % ---------------------------------------
    % ESTIMATE STATE
    % ---------------------------------------   
    for i = 1: n - 1
       d_P = F*P(:, :, i) + P(:, :, i)*F'...
           - K(:, i)*H(:, i)'*P(:, :, i)...
           +G*v_sigma^2*G';
       P(:, :, i + 1) = P(:, :, i) + d_P*dt;
       K(:, i + 1) = P(:, :, i)*H(:, i)...
           /V_n(:, i);
       d_x_hat(:, i + 1) = F*x_hat(:, i)...
           + K(:, i + 1)*(z(:, i + 1) -...
           H(:, i)'*x_hat(:, i));
       x_hat(:, i + 1) = x_hat(:, i)...
           + d_x_hat(:, i + 1)*dt;
       res(:, i + 1) = z(:, i + 1) -...
           H(:, i + 1)'*x_hat(:, i + 1);
    end
    % ---------------------------------------
    % UPDATE 
    % ---------------------------------------      
end
