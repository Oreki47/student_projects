% -------------------------------------------
% MAE 271B Project
% Zhiyuan Cao
% 02/27/17
% -------------------------------------------
clc;clear;
% -------------------------------------------
% GLOBAL CONSTANTS
% -------------------------------------------
vc = 300;                        % ft/sec
tf = 10;                         % sec
R1 = 15e-6;                      % rad^2sec
R2 = 1.67e-3;                    % rad^2sec^3
tau = 2;                         % sec
dt = 0.01;                       % sec
t = linspace(0, tf-dt, tf/dt)';  % discrete t
m = length(t);
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
    d_x = zeros (3, m);         % Actual Delta x
    x = zeros(3, m);            % Actual State x
    
    z = zeros(1, m);            % Measurement
    
    x_hat = zeros(3, m);        % Estimate State x
    d_x_hat = zeros(3, m);      % Estimate Delta x
    P = zeros(3, 3, m);         % Variance
    K = zeros(3, m);            % Kalman Gain
    err = zeros(3, m);          % Error
    res = zeros(1, m);          % Residues
    % ---------------------------------------
    % INITILIZE VALUES
    % ---------------------------------------
    H = [1/(vc*tf) 0 0];
    y0 = 0;       
    v0 = normrnd(v_mean, v_sigma);
    a0 = normrnd(a_mean, a_sigma); 
    x(:, 1) = [y0, v0, a0]';
    
    V0 = R1 + (R2/tf^2);
    n0 = normrnd(0, sqrt(V0/dt));
    z(:, 1) = H*x(:, 1) + n0;
    
    P(:, :, 1) = [0 0 0; 0 v_sigma^2 0; 0 0 a_sigma^2];
    K(:, 1) = P(:, :, 1)*H'/V0;
    
    d_x_hat(:, 1) = F*x_hat(:, 1)...
        + K (:, 1)*(z(:, 1) - H*x_hat(:, 1)); 
    
    % ---------------------------------------
    % ACTUAL STATE
    % ---------------------------------------
    for i = 1 : n - 1      
        a = normrnd(a_mean, a_sigma/sqrt(dt));
        d_x(:, i + 1) = F*x(:, i) + G*a;       
     
        x(:, i + 1) = x(:, i) + d_x(:, i)*dt;
        H = [1/((vc*(tf - t(i + 1)))) 0 0];
        
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
