% ---------------------------------------------------
% MAE 271B Project
% Zhiyuan Cao
% 02/27/17
% ---------------------------------------------------
clc;clear;
% ---------------------------------------------------
% GLOBAL CONSTANTS
% ---------------------------------------------------
vc = 300;                        % ft/sec
tf = 10;                         % sec
R1 = 15e-6;                      % rad^2sec
R2 = 1.67e-3;                    % rad^2sec^3
tau = 2;                         % sec
dt = 0.01;                       % sec
sdt = sqrt(dt);                  % sqrt(dt)
t = linspace(0, tf-dt, tf/dt)';  % discrete t
m = length(t);
num_sim = 1;
% ---------------------------------------------------
% STATS
% ---------------------------------------------------
y_mea = 0;
v_mea = 0;
a_mea = 0;
n_mea =0;                       
y_sig = 0;
v_sig = 200;
v_var = 200^2;
a_sig = 100;
a_var = 100^2;
V = zeros(1, m);                  % State Noise PSD
for ii = 1 : m
    V(ii) = R1 + R2/((tf-t(ii))^2);
end
% -----------------------------------------------
% STATE SPACE
% -----------------------------------------------
F = [0 1 0; 0 0 -1; 0 0 -1/tau];
B = [0 1 0]';
G = [0 0 1]';
W = G*a_sig^2*G';
H = zeros(3, m);                 % Measurement Matrix
M = zeros(3, 3, m);
for ii = 1 : m
    H(:, ii) = [1/(vc*(tf-t(ii))) 0 0];
    M(:, :, ii) = H(:, ii)*H(:, ii)'/V(ii);
end
% ---------------------------------------------------
% Main Loop
% ---------------------------------------------------
for ij = 1:num_sim
    % -------------------------------------------
    % DATA STRUCTURE
    % -------------------------------------------
    Wat = zeros(1, m);          % Process Noise   
    x = zeros(3, m);            % Actual State x
    dx = zeros (3, m);          % Actual Delta x
    n = zeros(1, m);            % State Noise
    z = zeros(1, m);            % Measurement
    xhat = zeros(3, m);         % Estimate State x
    dxh = zeros(3, m);          % Estimate Delta x  
    P = zeros(3, 3, m);         % Variance
    K = zeros(3, m);            % Kalman Gain
    err = zeros(3, m);          % Error
    res = zeros(1, m);          % Residues
    % -----------------------------------------------
    % INITILIZE VALUES
    % -----------------------------------------------
    v0 = normrnd(v_mea, v_sig);
    a0 = normrnd(a_mea, a_sig);   
    Wat(1) = normrnd(a_mea, a_sig/sdt);
    x(:, 1) = [0, v0, a0]';
    dx(:, 1) = F*x(:, 1) + G*Wat(1);
    n(1) = normrnd(0, sqrt(V(1)/dt));    
    z(:, 1) = H(:, 1)'*x(:, 1) + n(1);
    P(:, :, 1) = [0 0 0; 0 v_var 0; 0 0 a_var];
    K(:, 1) = P(:, :, 1)*H(:, 1)/V(1);   
    % -----------------------------------------------
    % UPDATE 
    % -----------------------------------------------         
    for ii = 1 : m - 1          
        % UPDATE VARIANCE
        dp = F*P(:, :, ii) + P(:, :, ii)*F'...
            - P(:, :, ii)*M(:, :, ii)*P(:, :, ii)...
            + W;
        P(:, :, ii + 1) = P(:, :, ii) + dp*dt;
        % UPDATE KALMAN GAIN
        K(:, ii + 1) = P(:, :, ii)*H(:, ii)/V(ii); % ii+1?        
        % UPDATE INPUT
        Wat(ii + 1) = normrnd(a_mea, sqrt(a_var/dt)); 
        n(ii + 1) = normrnd(n_mea, sqrt(V(ii)/dt));        
        % UPDATE ACTUAL STATE        
        dx(:, ii + 1) = F*x(:, ii) + G*Wat(ii + 1);
        x(:, ii + 1) = x(:, ii) + dx(:, ii + 1)*dt;
        z(:, ii + 1) = H(:, ii)'*x(:, ii + 1) + n(ii + 1);
        % UPDATE ESTIMATE STATE
        dxh(:, ii + 1) = F*xhat(:, ii) + K(:, ii + 1)...
            *(z(:, ii + 1) - H(:, ii)'*xhat(:, ii));
        xhat(:, ii + 1) = xhat(:, ii) + dxh(:, ii + 1)*dt;
    end  
end

% ---------------------------------------------------
% PLOTS
% ---------------------------------------------------
figure (1), plot(t, K(1, :), 'b'),
hold on,    plot(t, K(2, :), 'r--'),
hold on,    plot(t, K(3, :), 'g:'),
hold off,
xlabel('time(s)') % x-axis label
ylabel('Kalman Filter Gains') % y-axis label
legend('K1', 'K2', 'K3');

figure (2), plot(t, x(1, :), 'b-'),
hold on,    plot(t, xhat(1,:), 'r--')
hold off,
xlabel('time(s)') % x-axis label
ylabel('Position(ft)'); % y-axis label

figure (3), plot(t, x(2, :), 'b-');
hold on,    plot(t, xhat(2,:), 'r--')
hold off,
xlabel('time(s)') % x-axis label
ylabel('Position(ft)'); % y-axis label

figure (4), plot(t, x(3, :), 'b-'),
hold on,    plot(t, xhat(3,:), 'r--')
hold off,
xlabel('time(s)') % x-axis label
ylabel('Position(ft)'); % y-axis label