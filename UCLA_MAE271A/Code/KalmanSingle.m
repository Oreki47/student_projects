%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% MAE 271 Project
% Zhiyuan Cao
% 304397496
% KalmanSingle.m
%-------------------------------------------------------------------------
clc;clear;
%-------------------------------------------------------------------------
% Initial Values
%-------------------------------------------------------------------------
A = 10;
om = 2*pi*0.1;
freqAcc = 200; 
dt = 1/freqAcc;    
freqGps = 5; 
dtGps = 1/freqGps;
freqDiff = dtGps/dt;
T = 30;
tIMU = 0 : dt : T;
tGps = 0 : dtGps : T;
NOM = length(tGps); % Number of measurement
NOS = length(tIMU); % Number of Sample
%-------------------------------------------------------------------------
% Stats
%-------------------------------------------------------------------------
veloMu = 100;
posiMu = 0;
biasMu = 0;
noiseMu = 0;
gpsCorrMu = [0; 0];

veloSigma = 1;
posiSigma = 10;
biasSigma = .01;
noiseSigma = .0004;
gpsCorrSigma = [1, 0; 0, .04]; 
%-------------------------------------------------------------------------
% noise and Bias
%-------------------------------------------------------------------------
gpsCorr = zeros(2, NOS);
gpsCorr(1, :)= gpsCorrMu(1) + sqrt(gpsCorrSigma(1))*randn(1, NOS);
gpsCorr(2, :)= gpsCorrMu(2) + sqrt(gpsCorrSigma(4))*randn(1, NOS);
bias = 0.0938;
noise = noiseMu + sqrt(noiseSigma)*randn(1, NOS);
%-------------------------------------------------------------------------
% Real values
%-------------------------------------------------------------------------
accReal = A*sin(om*tIMU);
veloZero = normrnd(veloMu, veloSigma);
posiZero = normrnd(posiMu, posiSigma);
veloReal = veloZero + A/om*(1 - cos(om*tIMU));
posiReal = posiZero + (veloZero + A/om)*tIMU - A*sin(om*tIMU)/om^2;
%-------------------------------------------------------------------------
% Acc values
%-------------------------------------------------------------------------
veloAcc = zeros(1, NOS);
posiAcc = zeros(1, NOS);

accAcc = accReal + bias + noise;
veloAcc(1) = veloMu;
posiAcc(1) = posiMu;
for Iter = 2 : NOS
    veloAcc(Iter) = veloAcc(Iter - 1) + accAcc(Iter - 1)*dt;
    posiAcc(Iter) = posiAcc(Iter - 1) + veloAcc(Iter - 1)*dt ...
        + accAcc(Iter - 1)*dt^2/2;
end
%-------------------------------------------------------------------------
% One Realization
%-------------------------------------------------------------------------
posiDiff = posiReal(1 : freqDiff : end) - posiAcc(1 : freqDiff : end);
veloDiff = veloReal(1 : freqDiff : end) - veloAcc(1 : freqDiff : end);
z(1, :) = posiDiff + gpsCorr(1, 1 : freqDiff : end);
z(2, :) = veloDiff + gpsCorr(2, 1 : freqDiff : end);

%-------------------------------------------------------------------------
% Dynamics
%-------------------------------------------------------------------------
phi = [1, dtGps, -dtGps^2/2; 0, 1, -dtGps; 0, 0, 1];
phiT = transpose(phi);
h = [1, 0, 0; 0, 1, 0];
hT = transpose(h);
gamma = -[dtGps^2/2; dtGps; 0];
gammamaT = transpose(gamma);
mIter = [posiSigma, 0, 0; 0, veloSigma, 0; 0, 0, biasSigma];
xbar = [0; 0; 0];
%-------------------------------------------------------------------------
% Kalman Filter Implement
%-------------------------------------------------------------------------
xHat = zeros(3, NOM);
xBar = zeros(3, NOS);
est = zeros(3, NOM);
pStore = zeros(3, 3, NOM);
pDiag = zeros(3, NOM);
res = zeros(2, NOM);


Itergps = 1;
for Iter = 1:NOM
    %------------------------------
    % Update Conditional Mean
    %------------------------------
    K = mIter*hT/(h*mIter*hT + gpsCorrSigma);
    residual = (z(:, Itergps) - h*xbar);
    xhat = xbar + K*residual;
    res(:, Itergps) = residual;
    %------------------------------
    % Update Conditional Variance
    %------------------------------
    pIter = mIter - K*h*mIter;
    %------------------------------
    % Propagate the mean
    %------------------------------
    xbar = phi*xhat;
    xBar(:, Iter) = xbar;
    %------------------------------
    % Propagate the variance
    %------------------------------
    mIter = phi*pIter*phiT + gamma*noiseSigma*gammamaT;

    xHat(:, Itergps) = xhat;
    pDiag(:, Itergps) = diag(pIter);
    pStore(:, :, Itergps) = pIter;
    Itergps = Itergps + 1;

end
est(1, :) = xHat(1, :) + posiAcc(1 : freqDiff : end);
est(2, :) = xHat(2, :) + veloAcc(1 : freqDiff : end);
est(3, :) = xHat(3, :);
err(1, :) = est(1, :) - posiReal(1 : freqDiff : end);
err(2, :) = est(2, :) - veloReal(1 : freqDiff : end);
err(3, :) = est(3, :) - bias(1 : freqDiff : end);
%-------------------------------------------------------------------------
% Kalman Filter Implement
%-------------------------------------------------------------------------
set(0,'defaultfigurecolor',[1 1 1]);
figure(1)
subplot(3,1,1)
plot(tGps, est(1, :), 'r+'), hold on
plot(tIMU, posiReal(1, :))
title('Position', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Position(m)', 'FontSize', 16);

subplot(3,1,2)
plot(tGps, est(2, :), 'r+'), hold on
plot(tIMU, veloReal(1, :))
title('Velocity', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Velocity(m/s)', 'FontSize', 16);


subplot(3,1,3)
plot(tGps, est(3, :), 'r+'), hold on
plot(tIMU, bias)
title('Bias', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Bias', 'FontSize', 16);

figure(2)
subplot(3,1,1)
plot(tGps, err(1, :), 'r'), hold on
plot(tGps, sqrt(pDiag(1, :))), hold on
plot(tGps, -sqrt(pDiag(1, :)))
title('Position', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Position(m)', 'FontSize', 16);

subplot(3,1,2)
plot(tGps, err(2, :), 'r'), hold on
plot(tGps, sqrt(pDiag(2, :))), hold on
plot(tGps, -sqrt(pDiag(2, :)))
title('Velocity', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Velocity(m/s)', 'FontSize', 16);


subplot(3,1,3)
plot(tGps, err(3, :), 'r'), hold on
plot(tGps, sqrt(pDiag(3, :))), hold on
plot(tGps, -sqrt(pDiag(3, :)))
title('Bias', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Bias', 'FontSize', 16);
