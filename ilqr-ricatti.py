import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# Define system matrices (example: a simple pendulum-like system)
A = np.array([[0, 1], [0, 0]])  # System matrix (2x2)
B = np.array([[0], [1]])        # Input matrix (2x1)

# State penalty matrix (Q) and control penalty matrix (R)
Q = np.array([[1, 0], [0, 1]])  # State penalty (penalizing deviation in position and velocity)
R = np.array([[1]])             # Control penalty (penalizing control effort)

# Desired state (target state) - let's say we want to reach a specific position and velocity
x_target = np.array([np.pi / 4, 0])  # Target: position = pi/4, velocity = 0 (arbitrary target)

# Initial state (non-equilibrium state) - let's start at a different position and velocity
x_initial = np.array([np.pi / 2, 0])  # Initial: position = pi/2, velocity = 0

# Define the Riccati differential equation
def riccati_eq(t, P_flat):
    # Reshape P_flat into a 2x2 matrix
    P = P_flat.reshape(2, 2)
    
    # Compute the derivative of P (Riccati equation)
    dP_dt = A.T @ P + P @ A - P @ B @ np.linalg.inv(R) @ B.T @ P + Q
    
    # Flatten the result to return as a vector for solve_ivp
    return dP_dt.flatten()

# Initial guess for P (identity matrix)
P0 = np.eye(2).flatten()

# Time span for integration
t_span = (0, 10)

# Solve the Riccati equation numerically using solve_ivp
solution = solve_ivp(riccati_eq, t_span, P0, method="RK45", t_eval=np.linspace(0, 10, 1000), dense_output=True)

# Reshape the solution to extract P(t) at each time step
P_solution = solution.y.reshape(2, 2, -1)

# Access the final P(t) for use in computing the feedback gain
P_final = P_solution[:, :, -1]

# Compute the feedback gain K(t) = P(t) * B
K_t = np.dot(P_final, B)

# Define the system dynamics
def system_dynamics(t, x):
    # x[0] is position (theta), x[1] is velocity (dot(theta))
    u_t = -np.dot(K_t.T, x - x_target)  # Apply the LQR control law: u(t) = -K * (x(t) - x_target)
    dxdt = A @ x + B @ u_t  # System dynamics
    return dxdt

# Solve the system dynamics using solve_ivp
result = solve_ivp(system_dynamics, t_span, x_initial, method="RK45", t_eval=np.linspace(0, 10, 1000))

# Plot the results
plt.figure(figsize=(10, 5))

# Plot position (theta) and velocity (dot(theta))
plt.subplot(2, 1, 1)
plt.plot(result.t, result.y[0, :], label='Position (theta)')
plt.axhline(y=x_target[0], color='r', linestyle='--', label='Target Position')
plt.title('Position (theta) Over Time')
plt.xlabel('Time [s]')
plt.ylabel('Position [rad]')
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(result.t, result.y[1, :], label='Velocity (dot(theta))')
plt.axhline(y=x_target[1], color='r', linestyle='--', label='Target Velocity')
plt.title('Velocity (dot(theta)) Over Time')
plt.xlabel('Time [s]')
plt.ylabel('Velocity [rad/s]')
plt.legend()

plt.tight_layout()
plt.show()
