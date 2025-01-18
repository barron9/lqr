% Parameters for the system
k = 1;  % Example gain (you can modify this value)
omega = logspace(-1, 2, 500);  % Frequency range for log scale
s = 1j * omega;  % s = j*omega (complex frequency)

% Define the transfer function G(s)
numerator = k * (s + 2) .* (s + 10);
denominator = s .* (s + 1) .* (s + 5) .* (s + 15).^2;
G_s = numerator ./ denominator;

% Calculate magnitude and phase
magnitude = abs(G_s);
phase = angle(G_s);

% Plot magnitude and phase
figure;

% Magnitude plot
subplot(2,1,1);
semilogx(omega, 20*log10(magnitude));  % Magnitude in dB
xlabel('Frequency (rad/s)');
ylabel('Magnitude (dB)');
title('Magnitude of G(s)');

% Phase plot
subplot(2,1,2);
semilogx(omega, rad2deg(phase));  % Phase in degrees
xlabel('Frequency (rad/s)');
ylabel('Phase (degrees)');
title('Phase of G(s)');

