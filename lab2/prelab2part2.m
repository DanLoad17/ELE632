% Parameters
Ac = 1; % Carrier amplitude
Am = 0.5; % Message amplitude
fm = 1e3; % Message frequency
fc = 10e3; % Carrier frequency
fs = 100e3; % Sampling frequency
t = 0:1/fs:2/fm; % Time vector

% Signal generation
m_t = Am*cos(2*pi*fm*t); % Message signal
phi_AM_t = Ac*cos(2*pi*fc*t + m_t.*cos(2*pi*fm*t)); % AM signal

% Hilbert transform
h = hilbert(phi_AM_t); % Hilbert transform of the AM signal
phi_AM_h_t = abs(h); % Envelope signal

% LPF and DC block
[b, a] = butter(6, 2*fm/fs, 'low'); % 6th-order Butterworth LPF with cutoff frequency of fm
phi_AM_h_t_filtered = filter(b, a, phi_AM_h_t); % Filtered envelope signal
phi_AM_h_t_DCblock = phi_AM_h_t_filtered - mean(phi_AM_h_t_filtered); % DC block

% Spectra at test points A, B and C
spectrum_AM = abs(fft(phi_AM_t));
spectrum_A = abs(fft(phi_AM_t.*hilbert(phi_AM_t)));
spectrum_B = abs(fft(-1i*(phi_AM_t.*hilbert(phi_AM_t))));
spectrum_C = abs(fft(phi_AM_h_t_filtered));

% Plotting
figure(1)
subplot(4,1,1)
plot(t, phi_AM_t)
title('AM Signal')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,2)
plot(t, real(h))
title('Real part of Hilbert Transform')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,3)
plot(t, imag(h))
title('Imaginary part of Hilbert Transform')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,4)
plot(t, phi_AM_h_t)
title('Envelope Signal')
xlabel('Time (s)')
ylabel('Amplitude')

figure(2)
f = linspace(-fs/2, fs/2, length(spectrum_AM));
subplot(4,1,1)
plot(f, fftshift(spectrum_AM))
title('Spectrum of AM Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(4,1,2)
plot(f, fftshift(spectrum_A))
title('Spectrum at Point A')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(4,1,3)
plot(f, fftshift(spectrum_B))
title('Spectrum at Point B')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(4,1,4)
plot(f, fftshift(spectrum_C))
title('Spectrum at Point C')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
