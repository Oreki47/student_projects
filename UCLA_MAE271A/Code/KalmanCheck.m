%-------------------------------------------------------------------------
% MAE 271
% Zhiyuan Cao
% 304397496
%-------------------------------------------------------------------------
clc; clear; 

n=50; % Number of Ensemble
NOM = 151;

errAver = zeros(3, NOM);
errStore = zeros(3, NOM, n);
pAver = zeros(3, 3, NOM);
pAverDiag = zeros(3, NOM);
pStoreAver = zeros(3, 3, NOM);
orthEstErr= zeros(3, 3, NOM);
orthRes = zeros(2, 2);
%-------------------------------------------------------------------------
% Run and Collect Data
%-------------------------------------------------------------------------

for Iter1 = 1 : n
    KalmanMain;
    
    errStore(:, :, Iter1) = err;
    errAver = err + errAver;
    pAver = pAver + pStore;
    pAverDiag = pAverDiag + pDiag;
    if rem(Iter1, 100) == 0
        disp(Iter1)
    end
end
%-------------------------------------------------------------------------
% Checks
%-------------------------------------------------------------------------
errAver = errAver/n; % Ensemble Average
pAver = pAver/n; % Ensemble Average Variance
for Iter1 = 1 : n
    for Iter2 = 1 : NOM
        errDiff = errStore(:, Iter2, Iter1)-errAver(:, Iter2);
        pStoreAver(:, :, Iter2) = pStoreAver(:, :, Iter2) + (errDiff) * transpose(errDiff);
        orthEstErr(:, :, Iter2) = orthEstErr(:, :, Iter2) + errDiff * transpose(xHat(:, Iter2));
    end
    orthRes(:, :) = orthRes(:, :) + res(:, 30)*transpose(res(:, 20));
end
pStoreAver = pStoreAver/(n-1); % Actual error Variance
orthEstErr = orthEstErr/n; % Orthogonality of the Error
orthRes = orthRes/n; % Independence of the residuals

disp(orthRes);
disp(max(pStoreAver(:))),
disp(min(pStoreAver(:)));
disp(max(errAver(:))),
disp(min(errAver(:)));
disp(max(orthEstErr(:))),
disp(min(orthEstErr(:)));

set(0,'defaultfigurecolor',[1 1 1]);
figure(1)
subplot(3,1,1)
plot(tGps, errAver(1, :), 'r'), hold on
plot(tGps, sqrt(pAverDiag(1, :)), '--'), hold on
plot(tGps, -sqrt(pAverDiag(1, :)), '--')
title('Position Error', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Position(m)', 'FontSize', 16);
subplot(3,1,2)
plot(tGps, errAver(2, :), 'r'), hold on
plot(tGps, sqrt(pAverDiag(2, :)), '--'), hold on
plot(tGps, -sqrt(pAverDiag(2, :)), '--')
title('Velocity Error', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Velocity(m/s)', 'FontSize', 16);
subplot(3,1,3)
plot(tGps, errAver(3, :),'r'), hold on
plot(tGps, sqrt(pAverDiag(3, :)), '--'), hold on
plot(tGps, -sqrt(pAverDiag(3, :)), '--')
title('Bias Error', 'FontSize', 16)
xlabel('Times(s)', 'FontSize', 16)
ylabel('Bias', 'FontSize', 16);


figure(2)
subplot(3,3,1)
plot(tGps, reshape(pStoreAver(1, 1, :), 1, NOM) -...
    reshape(pAver(1, 1, :), 1, NOM))
title('P1, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,2)
plot(tGps, reshape(pStoreAver(1, 2, :), 1, NOM) -...
    reshape(pAver(1, 2, :), 1, NOM))
title('P1, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,3)
plot(tGps, reshape(pStoreAver(1, 3, :), 1, NOM) -...
    reshape(pAver(1, 3, :), 1, NOM))
title('P1, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,4)
plot(tGps, reshape(pStoreAver(2, 1, :), 1, NOM) -...
    reshape(pAver(2, 1, :), 1, NOM))
title('P2, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,5)
plot(tGps, reshape(pStoreAver(2, 2, :), 1, NOM) -...
    reshape(pAver(2, 2, :), 1, NOM))
title('P2, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,6)
plot(tGps, reshape(pStoreAver(2, 3, :), 1, NOM) -...
    reshape(pAver(2, 3, :), 1, NOM))
title('P2, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,7)
plot(tGps, reshape(pStoreAver(3, 1, :), 1, NOM) -...
    reshape(pAver(3, 1, :), 1, NOM))
title('P3, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,8)
plot(tGps, reshape(pStoreAver(3, 2, :), 1, NOM) -...
    reshape(pAver(3, 2, :), 1, NOM))
title('P3, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,9)
plot(tGps, reshape(pStoreAver(3, 3, :), 1, NOM) -...
    reshape(pAver(3, 3, :), 1, NOM))
title('P3, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);


figure(3)
subplot(3,3,1)
plot(tGps, reshape(orthEstErr(1, 1, :), 1, NOM))
title('E[.]1, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,2)
plot(tGps, reshape(orthEstErr(1, 2, :), 1, NOM))
title('E[.]1, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,3)
plot(tGps, reshape(orthEstErr(1, 3, :), 1, NOM))
title('E[.]1, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,4)
plot(tGps, reshape(orthEstErr(2, 1, :), 1, NOM))
title('E[.]2, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,5)
plot(tGps, reshape(orthEstErr(2, 2, :), 1, NOM))
title('E[.]2, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,6)
plot(tGps, reshape(orthEstErr(2, 3, :), 1, NOM))
title('E[.]2, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,7)
plot(tGps, reshape(orthEstErr(3, 1, :), 1, NOM))
title('E[.]3, 1', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);
subplot(3,3,8)
plot(tGps, reshape(orthEstErr(3, 2, :), 1, NOM))
title('P3, 2', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('Variance', 'FontSize', 12);
subplot(3,3,9)
plot(tGps, reshape(orthEstErr(3, 3, :), 1, NOM))
title('E[.]3, 3', 'FontSize', 12)
xlabel('Times(s)', 'FontSize', 12)
ylabel('E[.]', 'FontSize', 12);

