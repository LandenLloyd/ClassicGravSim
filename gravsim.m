format long

% Our random generation scheme is inspired by this Author:
% https://github.com/pmocz/nbody-matlab/blob/master/nbody.m
N = 15; % Number of bodies generated

% Give each body 50 pounds of weight
masses = ones(N, 1) * 50;

% Generate random positions and velocities
bodies = rand(N, 9) * 2 - 1;
bodies(:, 7:9) = 0;

% To show the path of particles in the graph, we keep a brief history of
% the positions for each particle
history_size = 500;
bodies_history = zeros(history_size, N, 3);

% vel = vel - mean((mass*[1 1 1]) .* vel) / mean(mass);
% Convert the frame to "center of mass", meaning the net momentum resets
% to zero. This prevents the system from leaving the bounds of the graph.
bodies(:, 4:6) = bodies(:, 4:6) - mean((masses*[1 1 1]) .* bodies(:, 4:6)) / mean(masses);
% We scale the velocity down so that the bodies stay in the screen
bodies(:, 4:6) = bodies(:, 4:6) * 2e-5;

% Constants for integration
t = 0;
tEnd = 518400;
dt = 4;
softening = 0.1;
num_iters = ceil((tEnd - t) / dt);

% The solver being used
solver = @(bodies, masses, dt, softening) step_lf(bodies, masses, dt, softening);

% Create one plot for each body in the graph
h = [];
for i = 1:N
    h = [h plot3(bodies(i, 1), bodies(i, 2), bodies(i, 3), "-")];
    hold on
end
% h = plot3(bodies(:, 1), bodies(:, 2), bodies(:, 3), "o");
axis([-1 1 -1 1 -1 1]);
grid on
colormap(autumn(5));

bodies = get_accel(bodies, masses, softening); % Initial acceleration
bodies(:, 4:6) = bodies(:, 4:6) + bodies(:, 7:9) * dt / 2; % Initial velocity step
for i = 1:num_iters
    bodies = solver(bodies, masses, dt ,softening);
    t = t + dt;

    % We do not start plotting until we have sufficient data to plot trails
    if i >= history_size
        % Save the current position in the history
        % Shift all entries up one
        bodies_history(2:history_size, :, :) = bodies_history(1:history_size-1, :, :);
        bodies_history(1, :, :) = bodies(:, 1:3);
    
        % Plot the motion of the planets
        for j = 1:N
            set(h(j), 'XData', bodies_history(:, j, 1));
            set(h(j), 'YData', bodies_history(:, j, 2));
            set(h(j), 'ZData', bodies_history(:, j, 3));
        end
        
        drawnow limitrate
    end
end
