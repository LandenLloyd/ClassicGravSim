format long

% % Our initial conditions
% masses = [50 50 50 50];
% % Each row is in the form [xx, xy, xz, vx, vy, vz, ax, ay, az]
% bodies = [0.5 0 0 0 1e-6 0 0 0 0;
%     -0.5 0 0 0 -1e-6 0 0 0 0;
%     0 0.5 0 1e-6 0 0 0 0 0;
%     0 -0.5 0 -1e-6 0 0 0 0 0];

% Our random generation scheme is inspired by this Author:
% https://github.com/pmocz/nbody-matlab/blob/master/nbody.m
N = 20;

% Give each body 50 pounds of weightx
masses = ones(N, 1) * 50;

% Generate random positions and velocities
bodies = rand(N, 9) * 2 - 1;
bodies(:, 4:9) = 0;

% vel = vel - mean((mass*[1 1 1]) .* vel) / mean(mass);
% Convert the frame to "center of mass", meaning the net momentum resets
% to zero. This prevents the system from leaving the bounds of the graph.
bodies(:, 4:6) = bodies(:, 4:6) - mean((masses*[1 1 1]) .* bodies(:, 4:6)) / mean(masses);

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
