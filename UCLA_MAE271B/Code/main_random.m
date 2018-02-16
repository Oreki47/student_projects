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
a = 0;
b = 1;
t = linspace(0, tf-dt, tf/dt)';  % discrete t
m = length(t);
ns = 1000;                         % number of simulation
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
% -----------------------------------------------
% GLOBAL DATA STRUCTURE
% -----------------------------------------------
err_g = zeros(3, m, ns);          % Global Err
err_aver = zeros(3, m);           % Global Err Aver
P_aver = zeros(3, 3, m);          % Global Var Aver
res_g = zeros(1, m, ns);          % Global Res
res_aver = zeros(1, m);           % Global Res Aver
% ---------------------------------------------------
% Main Loop
% ---------------------------------------------------
for jj = 1:ns
    if (rem(jj, 20) == 0)
        fprintf('Number of Iter: %d\n', jj);
    end
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
    [a0, Wat] = acc_gen(tf, dt, a_sig); 
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
        K(:, ii + 1) = P(:, :, ii + 1)*H(:, ii + 1)/V(ii + 1); % ii+1?        
        % UPDATE INPUT
        n(ii + 1) = normrnd(n_mea, sqrt(V(ii)/dt));        
        % UPDATE ACTUAL STATE        
        dx(:, ii + 1) = F*x(:, ii) + G*Wat(ii + 1);
        x(:, ii + 1) = x(:, ii) + dx(:, ii + 1)*dt;
        z(:, ii + 1) = H(:, ii + 1)'*x(:, ii + 1) + n(ii + 1);
        % UPDATE ESTIMATE STATE
        dxh(:, ii + 1) = F*xhat(:, ii) + K(:, ii)...
            *(z(:, ii) - H(:, ii)'*xhat(:, ii));
        xhat(:, ii + 1) = xhat(:, ii) + dxh(:, ii + 1)*dt;
        err(:, ii + 1) = xhat(:, ii + 1) - x(:, ii + 1);
        % UPDATE RESIDUE
        res(ii + 1) = z(:, ii + 1) - H(:, ii + 1)'*xhat(:, ii + 1);
    end
    err_g(:, :, jj) = err;
    res_g(:, :, jj) = res;
end
% ---------------------------------------------------
% DATA ANALYSIS
% ---------------------------------------------------
for jj = 1 : ns
   err_aver = err_g(:, :, jj) + err_aver;
   res_aver = res_g(:, :, jj) + res_aver;
end
err_aver = err_aver/ns;
res_aver = res_aver/ns;
for jj = 1 : ns
    for ii = 1 : m
        P_aver(:, :, ii) = P_aver(:, :, ii) + (err_g(:, ii, jj) - err_aver(:, ii))...
            *(err_g(:, ii, jj) - err_aver(:, ii))';
    end
end
res_cor = xcorr(res_aver);
P_aver = P_aver/ns;
% ---------------------------------------------------
% PLOTS
% ---------------------------------------------------

figure (6),
subplot(3,1,1), plot(t, sqrt(squeeze(P(1, 1, :))), 'b:'),
hold on,        plot(t, -sqrt(squeeze(P(1, 1, :))), 'b:'),
hold on,        plot(t, -err_aver(1, :), 'r'),
xlabel('time(s)') % x-axis label
ylabel('Position(ft)'), % y-axis label
hold off;
subplot(3,1,2), plot(t, sqrt(squeeze(P(2, 2, :))), 'b:'),
hold on,        plot(t, -sqrt(squeeze(P(2, 2, :))), 'b:'),
hold on,        plot(t, -err_aver(2, :), 'r'),
xlabel('time(s)') % x-axis label
ylabel('Velocity(ft/sec)'), % y-axis label
hold off;
subplot(3,1,3), plot(t, sqrt(squeeze(P(3, 3, :))), 'b:'),
hold on,        plot(t, -sqrt(squeeze(P(3, 3, :))), 'b:'),
hold on,        plot(t, err_aver(3, :), 'r'),
xlabel('time(s)') % x-axis label
ylabel('Acceleration(ft/sec^2)'), % y-axis label
hold off;

figure (7), plot(t, sqrt(squeeze(P(1, 1, :))), 'b'),
hold on,    plot(t, sqrt(squeeze(P_aver(1, 1, :))), 'b:'),
hold on,    plot(t, sqrt(squeeze(P(2, 2, :))), 'r'),
hold on,    plot(t, sqrt(squeeze(P_aver(2, 2, :))), 'r:'),
hold on,    plot(t, sqrt(squeeze(P(3, 3, :))), 'g'),
hold on,    plot(t, sqrt(squeeze(P_aver(3, 3, :))), 'g:'),
hold off,
xlabel('time(s)') % x-axis label
ylabel('Standard deviation of the state error') % y-axis label
legend('A priori variance in position (ft)', ...
    'Actual error variance in position (ft)',...
    'A priori variance in velocity (ft/sec)', ...
    'Actual error variance in velocity (ft/sec)',...
    'A priori variance in acceleration (ft/sec^2 )', ...
    'Actual error variance in acceleration (ft/sec^2)');


