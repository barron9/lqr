% Clear workspace and close figures
clear;
clc;
close all;

% Define system parameters
I_ship = 1000;          % Moment of inertia (kg.m^2)
D_ship = 50;            % Damping coefficient (N.m.s/rad)
K_ship = 500;           % Stiffness (N.m/rad)
M_ship = 10000;         % Mass of the ship (kg)
C_ship = 100;           % Damping coefficient for translation (N.s/m)
K_ship_translational = 1000; % Stiffness for translation (N/m)
g = 9.81;               % Gravitational acceleration (m/s^2)

% External inputs (torque and force)
tau_ext = 100;          % External torque (N.m)
F_ext = 500;            % External force (N)

% Initial conditions
theta0 = 0;             % Initial roll angle (rad)
theta_dot0 = 0;         % Initial roll angular velocity (rad/s)
x_ship0 = 0;            % Initial ship displacement (m)
x_ship_dot0 = 0;        % Initial ship velocity (m/s)

% Time span for simulation
tspan = [0 20];         % Simulation time (0 to 20 seconds)

% Combine initial conditions into a single vector
y0 = [theta0; theta_dot0; x_ship0; x_ship_dot0];

% Solve the system of ODEs using ode45
[t, y] = ode45(@(t, y) ship_ball_dynamics(t, y, I_ship, D_ship, K_ship, M_ship, C_ship, K_ship_translational, g, tau_ext, F_ext), tspan, y0);

% Extract results
theta = y(:, 1);        % Roll angle (rad)
theta_dot = y(:, 2);    % Roll angular velocity (rad/s)
x_ship = y(:, 3);       % Ship displacement (m)
x_ship_dot = y(:, 4);   % Ship velocity (m/s)

% Compute ball's acceleration and velocity
a_ball = g * theta + gradient(x_ship_dot, t); % Ball's acceleration
v_ball = cumtrapz(t, a_ball);                % Ball's velocity (integral of acceleration)

% Plot results
figure;

% Plot ship's roll angle
subplot(3, 1, 1);
plot(t, theta, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Roll Angle (rad)');
title('Ship Roll Angle');
grid on;

% Plot ship's displacement
subplot(3, 1, 2);
plot(t, x_ship, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Displacement (m)');
title('Ship Translational Displacement');
grid on;

% Plot ball's velocity
subplot(3, 1, 3);
plot(t, v_ball, 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Ball Velocity');
grid on;

% Dynamics function
function dydt = ship_ball_dynamics(t, y, I_ship, D_ship, K_ship, M_ship, C_ship, K_ship_translational, g, tau_ext, F_ext)
    % Unpack state variables
    theta = y(1);           % Roll angle
    theta_dot = y(2);       % Roll angular velocity
    x_ship = y(3);          % Ship displacement
    x_ship_dot = y(4);      % Ship velocity

    % Ship's roll dynamics
    theta_ddot = (tau_ext - D_ship * theta_dot - K_ship * theta) / I_ship;

    % Ship's translational dynamics
    x_ship_ddot = (F_ext - C_ship * x_ship_dot - K_ship_translational * x_ship) / M_ship;

    % Return derivatives
    dydt = [theta_dot; theta_ddot; x_ship_dot; x_ship_ddot];
end