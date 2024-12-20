% Define parameters
Ac = 1; % Carrier amplitude
Am = 0.5; % Modulating amplitude
fm = 1000; % Modulating frequency (Hz)
fc = 10000; % Carrier frequency (Hz)
mu = 0.5; % Modulation index

% Time vector
t = linspace(0, 0.02, 10000); % 20 ms duration

% Part (a)
m_t = Am*cos(2*pi*fm*t); % Modulating signal
phi_AM = (Ac + m_t).*cos(2*pi*fc*t); % AM signal

figure;
plot(t, phi_AM);
title('AM Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Part (b)
f = linspace(-20000, 20000, 10000); % Frequency vector
M_f = Am*(sinc(fm*(f-fc)) + sinc(fm*(f+fc))); % Modulating signal spectrum
Phi_AM_f = Ac/2*(sinc(f-fc) + sinc(f+fc)) + M_f/4; % AM signal spectrum

figure;
plot(f, Phi_AM_f);
title('AM Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Part (c)
mu = Am/Ac; % Modulation index

% Part (d)
Pc = (Ac^2)/2; % Carrier power
Psb = (Am^2)/8; % Sideband power
Ptotal = Pc + 2*Psb; % Total power
efficiency = Ptotal/Pc; % Power efficiency

% Part (e)
y_t_50 = abs(Ac + mu*Am*cos(2*pi*fm*t)); % Output of AM demodulator when mu = 0.5
y_t_120 = abs(Ac + 1.2*Am*cos(2*pi*fm*t)); % Output of AM demodulator when mu = 1.2

% Lowpass filter
[b, a] = butter(6, 1000/(44100/2), 'low'); % 6th-order Butterworth filter with cutoff frequency of 1 kHz
y_t_50_lp = filtfilt(b, a, y_t_50); % Apply filter
y_t_120_lp = filtfilt(b, a, y_t_120); % Apply filter

% DC block capacitor
tau = 1/(2*pi*1000); % Time constant of capacitor
y_t_50_dc = y_t_50_lp - y_t_50_lp(1)*exp(-t/tau); % Remove DC offset
y_t_120_dc = y_t_120_lp - y_t_120_lp(1)*exp(-t/tau); % Remove DC offset

% Plot outputs
figure;
plot(t, y_t_50_dc);
title('Output of AM Demodulator (μ = 0.5)');
xlabel('Time (s)');

figure;
plot(t, y_t_120_dc);
title('Output of AM Demodulator (μ = 1.2)');
xlabel('Time (s)');

