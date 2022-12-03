format long

% Our initial conditions
masses = [50 50 50 50];
% Each row is in the form [xx, xy, xz, vx, vy, vz, ax, ay, az]
bodies = [0.5 0 0 0 1e-6 0 0 0 0;
    -0.5 0 0 0 -1e-6 0 0 0 0;
    0 0.5 0 1e-6 0 0 0 0 0;
    0 -0.5 0 -1e-6 0 0 0 0 0];

% Constants for integration
t = 0;
tEnd = 518400;
dt = 1;
softening = 0.1;
num_iters = ceil((tEnd - t) / dt);

% The solver being used
solver = @(bodies, masses, dt, softening) step_lf(bodies, masses, dt, softening);

% Create a plot that ranges from -1 to 1 on all axis.
h = plot3(bodies(:, 1), bodies(:, 2), bodies(:, 3), "o");
hold on
axis([-1 1 -1 1 -1 1])
hold off
bodies = get_accel(bodies, masses, softening); % Initial acceleration
for i = 1:num_iters
    bodies = solver(bodies, masses, dt ,softening);
    t = t + dt;

    % Plot the motion of the planets
    set(h, 'XData', bodies(:, 1));
    set(h, 'YData', bodies(:, 2));
    set(h, 'ZData', bodies(:, 3));

    drawnow limitrate
end
