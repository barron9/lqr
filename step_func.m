syms t s a;

% Define the unit step function 1(t - a)
f = (t - a) * heaviside(t - a);

% Compute the Laplace transform
F_s = laplace(f, t, s);

% Display the result
disp('Laplace Transform:');
disp(F_s);
