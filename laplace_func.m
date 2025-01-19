% Time vector for plotting
t = -10:0.01:10;  % Time from -10 to 10 with a step of 0.01

% Step function (Heaviside function)
u = @(t) double(t >= 0);  % Heaviside function (step function)

% Pulse function (rectangular pulse, 1 between -2 and 2)
pulse = @(t) double(abs(t) <= 2);  % Pulse function between -2 and 2

% Impulse function (approximated by a very narrow Gaussian)
impulse = @(t) exp(-t.^2 / 0.01);  % Narrow Gaussian as approximation of impulse

% Sinusoidal function (sine wave)
sinusoid = @(t) sin(2*pi*t);  % Sinusoidal wave with frequency 1 Hz

% Ramp function
ramp = @(t) max(0, t);  % Ramp function (0 for t<0 and t for t>=0)

% Exponential function (e^(-t))
exp_func = @(t) exp(-t);  % Exponential decay function

% Translated function (example: f(t-3) = sin(t-3))
translated_func = @(t) sin(t - 3);  % Translated sinusoidal function by 3 units

% Create the figure
figure;

% Plot all functions in one figure with subplots

% Translated function
subplot(3, 3, 1);
plot(t, translated_func(t), 'LineWidth', 2);
title('Translated Function: sin(t-3)');
xlabel('Time (t)');
ylabel('f(t-3)');
grid on;

% Step function
subplot(3, 3, 2);
plot(t, u(t), 'LineWidth', 2);
title('Step Function (u(t))');
xlabel('Time (t)');
ylabel('u(t)');
grid on;

% Pulse function
subplot(3, 3, 3);
plot(t, pulse(t), 'LineWidth', 2);
title('Pulse Function');
xlabel('Time (t)');
ylabel('Pulse');
grid on;

% Impulse function (approximated by a narrow Gaussian)
subplot(3, 3, 4);
plot(t, impulse(t), 'LineWidth', 2);
title('Impulse Function (Approximation)');
xlabel('Time (t)');
ylabel('Impulse');
grid on;

% Sinusoidal function
subplot(3, 3, 5);
plot(t, sinusoid(t), 'LineWidth', 2);
title('Sinusoidal Function');
xlabel('Time (t)');
ylabel('sin(t)');
grid on;

% Ramp function
subplot(3, 3, 6);
plot(t, ramp(t), 'LineWidth', 2);
title('Ramp Function');
xlabel('Time (t)');
ylabel('Ramp(t)');
grid on;

% Exponential function
subplot(3, 3, 7);
plot(t, exp_func(t), 'LineWidth', 2);
title('Exponential Function');
xlabel('Time (t)');
ylabel('exp(-t)');
grid on;

% Translated function with a shift by 5 units
subplot(3, 3, 8);
plot(t, translated_func(t - 5), 'LineWidth', 2);
title('Translated Function: sin(t-5)');
xlabel('Time (t)');
ylabel('sin(t-5)');
grid on;

% Adjust layout for better visualization
sgtitle('Various Functions and Their Translations');
