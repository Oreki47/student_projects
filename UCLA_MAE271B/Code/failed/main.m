% -------------------------------------------
% MAE 271B Project
% Zhiyuan Cao
% 02/27/17
% -------------------------------------------
clc;clear;
% -------------------------------------------
% GLOBAL CONSTANTS
% -------------------------------------------
V_c = 300;                       % ft/sec
t_f = 10;                        % sec
R_1 = 15e-6;                     % rad^2sec
R_2 = 1.67e-3;                   % rad^2sec^3
tau = 2;                         % sec
dt = 0.01;                       % sec
t = linspace(t_f, 0, t_f/dt+1)'; % discrete t
n = length(t);
num_sim = 1;
% -------------------------------------------
% DATA STRUCTURE
% -------------------------------------------
a_cor = ones(1, n);     % Correlation
a = zeros(1, n);        % Actual_Acc
v = zeros(1, n);        % Actual_Vel
y = zeros(1, n);        % Actual_pos
V = zeros(1, n);        % Noise
H = zeros(1, 3, n);     % Measure
x_bar = zeros(3, 1, n); % Mean
x = zeros(3, 1, n);     % Actual State
P = zeros(3, 3, n);     %
K = zeros(3, 1, n);     %
z = zeros(1, n);        %
err = zeros(3, 1, n);   % Error
res = zeros(1, n);      % Residues
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
n_sigma = 0;
for iter_sub = 1:n
    V(iter_sub) = R_1 + R_2/t(iter_sub)^2;
end
% ---------------------------------------
% STATE SPACE
% ---------------------------------------
F = [0 1 0; 0 0 -1; 0 0 -1/tau];
B = [0 1 0]';
G = [0 0 1]';
for iter_sub = 1:n
    H(:, :, iter_sub) = [1/(V_c*t(iter_sub)) 0 0];
end
% -------------------------------------------
% Main Loop
% -------------------------------------------
for iter_main = 1:num_sim
    % ---------------------------------------
    % INITILIZE VALUES
    % ---------------------------------------
    y_0 = 0;       
    v_0 = normrnd(v_mean, v_sigma);
    a_0 = normrnd(a_mean, a_sigma);
    P_0 = [0 0 0; 0 v_sigma^2 0; 0 0 a_sigma^2];
    % ---------------------------------------
    % 
    % ---------------------------------------
    % ---------------------------------------
    % ACTUAL STATE
    % ---------------------------------------

end
