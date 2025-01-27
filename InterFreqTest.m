%----- Setup
clear all
close all

Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
N = floor(fsampIQ*Tfull);
nfft = 2^9; % Size of FFT used in power spectrum estimation
% nfft = 1000;
% % fsampL1 = 46.08e6;   % Sampling frequency (Hz)
window = 100;
fIF = 2.5e6;
Tl = 1/fsampIQ;


%----- Load data
fid = fopen('niData02.bin','r','l');
Y = fread(fid, [2,N], 'int16')';

% %----- Calculate IF signal
Y = Y(:,1) + 1j*Y(:,2);
[Sxx, fVec1] = pwelch(Y, 200, 100, nfft, fsampIQ, 'psd', 'centered');

[yVec] = iq2if(real(Y), imag(Y), Tl, fIF);
[Syy, fVec2] = pwelch(yVec, 200, 100, nfft, 2/Tl,'psd', 'centered');

[IVec, QVec] = if2iq(yVec, Tl/2, fIF);
X_IF = IVec + 1j*QVec;
[Szz, fVec3] = pwelch(X_IF, 200, 100, nfft, fsampIQ, 'psd', 'centered');


figure(1)
clf
subplot(2,2,1)
hold on
yLow1 = min(10*log10(Sxx));
plot(fVec1/1e6,10*log10(Sxx));

yLow2 = min(10*log10(Szz));
plot(fVec2(length(fVec2)/2:end)/1e6-2.5 , 10*log10(Syy(length(fVec2)/2:end)));

yLow3 = min(10*log10(Szz));
plot(fVec3/1e6,10*log10(Szz));

grid on
title('Power spectral density estimate of the Baseband/IF Signals');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
legend('BB of original signal',...
    'Single sided shifted IF signal', 'Conversion back to BB')
hold off

subplot(2,2,2)
yLow2 = min(10*log10(Sxx));
area(fVec1/1e6,10*log10(Sxx),yLow2);
grid on
title('Power spectral density estimate of the orignal BB signal');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');

subplot(2,2,3)
yLow2 = min(10*log10(Syy));
area(fVec2/1e6,10*log10(Syy),yLow2);
grid on
title('Power spectral density estimate of the IF signal');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');

subplot(2,2,4)
yLow2 = min(10*log10(Szz));
area(fVec3/1e6,10*log10(Szz),yLow2);
grid on
title('Power spectral density estimate of converted BB signal');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');

% %----- Display power spectral density estimate
% yLow = min(10*log10(Sxx));
% yHigh = max(10*log(Sxx));
% T = nfft/fsampIQ;
% delf = 1/T;
% fcenter = (nfft/2)*delf;
% fVec1 = (fVec1 - fcenter);
% Sxx = [Sxx(nfft/2 + 1 : end); Sxx(1:nfft/2)];
% figure(1);
% hold on
% area(fVec1/1e6,10*log10(Sxx),yLow);
% % ylim([yLow,yHigh]);
% grid on;
% shg;
% title('Power spectral density estimate of the Baseband Signal');
% xlabel('Frequency (MHz)');
% ylabel('Power density (dB/Hz)');
% hold off
% 
% yLow = min(10*log10(Syy));
% yHigh = max(Syy);
% T = Tl/2;
% delf = 1/T;
% fcenter = (nfft/2)*delf;
% fVec2 = (fVec2 - fcenter);
% Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
% figure(2);
% hold on
% area(fVec2/1e6,10*log10(Syy),yLow);
% % ylim([yLow,yHigh]);
% grid on;
% shg;
% title('Power spectral density estimate of GPS L1 Signal');
% xlabel('Frequency (MHz)');
% ylabel('Power density (dB/Hz)');
% hold off
% 
% yLow = min(10*log10(Szz));
% yHigh = max(Szz);
% T = nfft/fIF;
% delf = 1/T;
% fcenter = (nfft/2)*delf;
% fVec1 = (fVec3 - fcenter);
% Szz = [Szz(nfft/2 + 1 : end); Szz(1:nfft/2)];
% figure(3);
% hold on
% area(fVec3/1e6,10*log10(Szz),yLow);
% % ylim([yLow,yHigh]);
% grid on;
% shg;
% title('Power spectral density estimate of the Baseband Signal');
% xlabel('Frequency (MHz)');
% ylabel('Power density (dB/Hz)');
% hold off

fclose(fid);