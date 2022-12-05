format long

% Our random generation scheme is inspired by this Author:
% https://github.com/pmocz/nbody-matlab/blob/master/nbody.m
N = 10; % Number of bodies generated

% Give each body 50 pounds of weight
masses = ones(N, 1) * 50;

% Generate random positions and velocities
bodies = rand(N, 9) * 2 - 1;
bodies(:, 7:9) = 0;

% vel = vel - mean((mass*[1 1 1]) .* vel) / mean(mass);
% Convert the frame to "center of mass", meaning the net momentum resets
% to zero. This prevents the system from leaving the bounds of the graph.
bodies(:, 4:6) = bodies(:, 4:6) - mean((masses*[1 1 1]) .* bodies(:, 4:6)) / mean(masses);
% We scale the velocity down so that the bodies stay in the screen
bodies(:, 4:6) = bodies(:, 4:6) * 2e-5;

% Constants for integration
t = 0;
tEnd = 518400;
dt = 1;
softening = 0.1;
num_iters = ceil((tEnd - t) / dt);

% The solver being used
solver = @(bodies, masses, dt, softening) step_lf(bodies, masses, dt, softening);

% Create a plot that ranges from -2 to 2 on all axes.
h = plot3(bodies(:, 1), bodies(:, 2), bodies(:, 3), "o");
axis([-1 1 -1 1 -1 1]);
grid on
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
