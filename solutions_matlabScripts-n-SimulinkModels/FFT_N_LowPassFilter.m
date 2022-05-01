% *************************************************************************
% By        : Jabed-Akhtar (github)
% date      : 01.05.2022
% *************************************************************************
% file      : FFT_N_LowPassFilter.m
% brief     :
% *************************************************************************
% script (this) related infos:
%   - a source used within this script: https://youtu.be/st5Px3JtMSo
%   - evicences/pics can be found at location: '../evidences/FFT_N_LowPassFilter.jpg'
% *************************************************************************
% Descriptions:
%   - This is a simple example of filtering noisy signals in time-domain
%       and in frequency-domain.
% *************************************************************************

clc; clear; close all;


%% Variables --------------------------------------------------------------
Fs = 200e3; %sampling frequency
Ts=1/Fs;
dt=0:Ts:5e-3-Ts;

f1 = 1e3; %1st frequency for the signal
f2 = 20e3; %2nd frequency for the signal
f3 = 30e3; %3rd frequency for the signal

y1 = 5*sin(2*pi*f1*dt);
y2 = 5*sin(2*pi*f2*dt);
y3 = 10*sin(2*pi*f3*dt);
y = y1+y2+y3; %adding all signals with different frequencies

%plotting the signal -> noisy
plot(dt, y); grid;
title('Signal (noisy) - Time Domain')
xlabel('Time [s]'); ylabel('Amplitude [V]');


%% FFT for Signal (noisy) -------------------------------------------------
nfft=length(y);
nfft2=2.^nextpow2(nfft); %length of signal in power of two

fft_y = fft(y,nfft2);
fft_y=fft_y(1:nfft2/2);

xfft=Fs.*(0:nfft2/2-1)/nfft2;

%plotting the signal (noisy) frequency domain
plot(xfft, abs(fft_y/max(fft_y))); grid;
title('Signal (noisy) - Frequency Domain');
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');


%% Low Pass Filter in time Domain -----------------------------------------
cut_off_f = 1.5e3/Fs/2;
order=32;

h=fir1(order, cut_off_f); %FIR filter design
con = conv(y, h); %convolutional multiplication of signal and designed filter

%plotting the signal (noisy)
figure(1)
subplot(3,1,1)
plot(dt,y); grid;
title('Signal (with Noise) - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');
subplot(3,1,2)
stem(h); grid;
title('Impulse Response of the Filter - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');
subplot(3,1,3)
plot(con); grid;
title('Filtered Signal - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');


%% Low Pass Filter in Frequency Domain ------------------------------------
fh = fft(h,nfft2);
fh = fh(1:nfft2/2);

mul = fh.*fft_y;

%plotting the signal (noisy)
figure(2)
subplot(3,1,1)
plot(xfft, abs(fft_y/max(fft_y))); grid;
title('Signal (with Noise) - Frequency Domain');
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');
subplot(3,1,2)
plot(xfft, abs(fh/max(fh))); grid;
title('Impulse Response of the Filter - Frequency Domain')
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');
subplot(3,1,3)
plot(abs(mul/max(mul))); grid;
title('Filtered Signal - Frequency Domain')
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');


%% Plotting signals in time domain and in frequency domain
close all;
figure(3)
%for time domain
subplot(3,2,1)
plot(dt,y); grid;
title('Signal (with Noise) - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');
subplot(3,2,3)
stem(h); grid;
title('Impulse Response of the Filter - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');
subplot(3,2,5)
plot(con); grid;
title('Filtered Signal - Time Domain');
xlabel('Time [s]'); ylabel('Amplitude [V]');

%for frequency domain
subplot(3,2,2)
plot(xfft, abs(fft_y/max(fft_y))); grid;
title('Signal (with Noise) - Frequency Domain');
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');
subplot(3,2,4)
plot(xfft, abs(fh/max(fh))); grid;
title('Impulse Response of the Filter - Frequency Domain')
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');
subplot(3,2,6)
plot(abs(mul/max(mul))); grid;
title('Filtered Signal - Frequency Domain')
xlabel('Frequency [Hz]'); ylabel('Normalized Amplitude');


% *************************** END OF FILE *********************************