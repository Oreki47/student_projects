%-----------------------------------------------------------------------------
% Define Variables and give out one realization and store all values for
% later use
% Estimation of position, volocity and acclorometer bias
%-----------------------------------------------------------------------------
clc;clear;
%-----------------------------------------------------------------------------
% Initial values
%-----------------------------------------------------------------------------
t = 30;
freqAcc = 200; % Acc Frequency
deltaT = 0.005; % Delta t : 0.005 for 200Hz 
freqGps = 5; % GPS Frequency
freqDiff = freqAcc / freqGps; % Frequency Difference
numOfSample = t * freqAcc +1; % Number of Acc samples
numOfIter = t * freqGps + 1; % Number of Iteration

%-----------------------------------------------------------------------------
% Real acceleration value
%-----------------------------------------------------------------------------
accReal = zeros(1,numOfSample); 
for i= 1 : numOfSample
	accReal(i) = 10 * sin (.2 * pi * i * deltaT);
end

%-----------------------------------------------------------------------------
% Real velocity
%-----------------------------------------------------------------------------
veloReal = zeros(1, numOfSample); 
veloRealZeroMu = 100; % Initial Velocity Aver
veloRealZeroSigma = 1; % Initial Velocity Var
veloReal(1) = normrnd(veloRealZeroMu, veloRealZeroSigma); % Initial Velocity
for i = 2 : numOfSample
	if (rem(i, freqDiff) == 1)
		veloReal(i) = veloReal(i - 1) + accReal(i) * freqDiff * deltaT;
	else
		veloReal(i) = veloReal(i - 1);
	end
end

%-----------------------------------------------------------------------------
% Real Position
%-----------------------------------------------------------------------------
posiReal =zeros(1, numOfSample); 
posiRealZeroMu = 0; % Initial Position Aver
posiRealZeroSigma = 10; % Initial Position Var
posiReal(1) = normrnd(posiRealZeroMu, posiRealZeroSigma); % Initial Position
for i = 2 : numOfSample
	if(rem(i, freqDiff) == 1)
		posiReal(i) = posiReal(i - 1) + veloReal(i - 1) * freqDiff * deltaT + accReal(i - 1) * freqDiff * deltaT^2 * .5;
	else
		posiReal(i) = posiReal(i - 1);
	end
end

%-----------------------------------------------------------------------------
% Noise and Bias
%-----------------------------------------------------------------------------
biasAccMu = 0; % Bias Aver
biasAccSigma = 0.01 ; %?Bias Var
biasAcc = normrnd(biasAccMu, biasAccSigma); % Generate Bias for Accelerometer

omiga = zeros(1, numOfSample); % Noise
omigaMu = 0; % Noise Aver
omigaSigma = 0.0004; % Noise Var
for i = 1 : numOfSample
	omiga(i) = normrnd(omigaMu, omigaSigma);
end

%-----------------------------------------------------------------------------
% Acc value from the accelerometer 
%-----------------------------------------------------------------------------
accAcc = accReal + biasAcc + omiga; 

%-----------------------------------------------------------------------------
% Velocity generated from Accelerometer
%-----------------------------------------------------------------------------
veloAcc = zeros(1, numOfSample); 
veloAcc(1) = 100; % Initial Velocity
for i = 2: numOfSample
	veloAcc(i) = veloAcc(i - 1) + accAcc(i - 1) * deltaT;
end

%-----------------------------------------------------------------------------
% Position generated from Accelerometer
%-----------------------------------------------------------------------------
posiAcc = zeros(1, numOfSample); % Position generated from Accelerometer
posi(1) = 0; % Initial Position
for i = 2: numOfSample
	posiAcc(i) = posiAcc(i - 1) + veloAcc(i - 1) * deltaT + accAcc(i - 1) * deltaT^2 * .5;
end

%-----------------------------------------------------------------------------
% GPS Corruption
%-----------------------------------------------------------------------------
gpsCorrMu = [0; 0]; % GPS corruption Aver
gpsCorrSigma = [1, 0; 0, 0.04]; % GPS corruption Var
gpsCorr = zeros(2, numOfIter);
for i = 1 : numOfIter
	gpsCorr(1, i) = normrnd(gpsCorrMu(1), gpsCorrSigma(1));
	gpsCorr(2, i) = normrnd(gpsCorrMu(2), gpsCorrSigma(4));
end

%-----------------------------------------------------------------------------
% One Realization
%-----------------------------------------------------------------------------
diffEst = [posiReal - posiAcc; veloReal - veloAcc; biasAcc * ones(1, numOfSample)]; % x value
diffReal(1, :) = diffEst(1, 1 : freqDiff : end) + gpsCorr(1, :); % z value
diffReal(2, :) = diffEst(2, 1 : freqDiff : end) + gpsCorr(2, :);

%-----------------------------------------------------------------------------
% Matrix setups
%-----------------------------------------------------------------------------
phiX = [1, deltaT, -deltaT^2 * .5; 0, 1, -deltaT; 0, 0, 1]; % Coefficient for propagate x value
gammaX = -[deltaT^2 * .5, deltaT, 0]; % Coefficient for propagate Omiga value
h = [1, 0, 0; 0, 1, 0]; % Coefficient for update z
xBar = zeros(3, numOfSample); % Mean
xBar(:, 1) = [posiRealZeroMu; veloRealZeroMu; biasAccMu]; % Initial Mean
xHat = zeros(3, numOfIter); % Conditional Mean
pCon = zeros(3, 3, numOfIter); % Conditional Variance
m = zeros(3, 3, numOfSample); % Variance
m(:, :, 1) = [posiRealZeroSigma, 0, 0; 0, veloRealZeroSigma, 0; 0, 0, biasAccSigma]; % Initial Variance
z = diffReal; % Measurement
filRes= zeros(2, numOfIter); % Filter Residual


%-----------------------------------------------------------------------------
% Kalman Filter Implement
% The filter only updates at ti but propagate at tj
%-----------------------------------------------------------------------------
igps = 1;
for i = 1:numOfSample
	iforthEstErr
		% Update
		K = m(:, :, igps) * transpose(h) / (h * m(:, :, igps) * transpose(h) + gpsCorrSigma); % Calculate Kalman Gain
		filRes(:, igps) = (z(:, igps) - h * xBar(:, i)); % Store filter residual
        xHat(:, igps) = xBar(:, i) + K * filRes(:, igps); % Update Conditional Mean

        pCon(:, :, igps) = m(:, :, i) - K * h * m(:, :, i) ; % Update Conditional Variance

        xBar(:, i + 1) = phiX * xHat(:, igps); % Propagate Mean

        m(:, :, i + 1) = phiX * pCon(:, :, igps) * transpose(phiX) + gammaX * omigaSigma * transpose(gammaX); % Propagate Variance

        igps = igps + 1;
	else
		% Only propagate

		xBar(:, i + 1) = phiX * xBar(:, i); % Propagate Mean

		m(:, :, i + 1) = phiX * m(:, :, i) * transpose(phiX) + gammaX * omigaSigma * transpose(gammaX); % Propagate Variance
	end 
end

subplot(1,2,1)
plot(0 : deltaT * freqDiff : t, xHat(1, :), 'r'), hold on
plot(0 : deltaT * freqDiff : t, z(1, :));

subplot(1,2,2)
plot(0 : deltaT * freqDiff : t, xHat(3, :), 'r'), hold on
plot(0 : deltaT : t, biasAcc);