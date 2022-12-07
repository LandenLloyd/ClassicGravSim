format long

% For testing, it is convenient to use the same seed everytime
rng(42);

% Our random generation scheme is inspired by this Author:
% https://github.com/pmocz/nbody-matlab/blob/master/nbody.m
N = 20; % Number of bodies generated
m = 50; % Weight of each particles
history_size = 500; % Number of positions in the trails

% Constants for integration
t = 0;
tEnd = 51840;
dt = 4;
softening = 0.06;
num_iters = ceil((tEnd - t) / dt);

% Give each body 50 pounds of weight
masses = ones(N, 1) * m;

% Generate random positions and velocities
bodies = rand(N, 9) * 2 - 1;
bodies(:, 7:9) = 0;

% To show the path of particles in the graph, we keep a brief history of
% the positions for each particle
bodies_history = zeros(history_size, N, 3);

% Convert the frame to "center of mass", meaning the net momentum resets
% to zero. This prevents the system from leaving the bounds of the graph.
% Refer to https://github.com/pmocz/nbody-matlab
bodies(:, 4:6) = bodies(:, 4:6) - mean((masses*[1 1 1]) .* bodies(:, 4:6)) / mean(masses);
% We scale the velocity down so that the bodies stay in the screen
bodies(:, 4:6) = bodies(:, 4:6) * 2e-5;

% The solver being used
solver = @(bodies, masses, dt, softening) step_lf(bodies, masses, dt, softening);

% Create a larger window for multiple graphs
f = figure();
f.Position = f.Position * 2;

tiledlayout(2, 2);

% Create one plot for each body in the graph
nexttile
h = [];
for i = 1:N
    h = [h plot3(0, 0, 0, ".-", 'MarkerSize', 10, 'MarkerIndices', 1)];
    hold on
end
% h = plot3(bodies(:, 1), bodies(:, 2), bodies(:, 3), "o");
axis([-1 1 -1 1 -1 1]);
grid on
colormap(autumn(5));
hold off;

% Keep a history of the mechanical energy
nexttile
e_hist_t = [t];

[ke, pe, me] = get_me(bodies, masses);
ke_hist = [ke];
pe_hist = [pe];
me_hist = [me];

ke_h = plot(e_hist_t, ke_hist, '-');
hold on
pe_h = plot(e_hist_t, pe_hist, '-');
me_h = plot(e_hist_t, me_hist, '-');
legend("KE", "PE", "ME");
hold off

bodies = get_accel(bodies, masses, softening); % Initial acceleration
bodies(:, 4:6) = bodies(:, 4:6) + bodies(:, 7:9) * dt / 2; % Initial velocity step
for i = 1:num_iters
    bodies = solver(bodies, masses, dt, softening);
    t = t + dt;

    % Save the current position in the history
    % Shift all entries up one
    bodies_history(2:history_size, :, :) = bodies_history(1:history_size-1, :, :);
    bodies_history(1, :, :) = bodies(:, 1:3);

    % Save the current ME
    e_hist_t = [e_hist_t t];
    
    [ke, pe, me] = get_me(bodies, masses);
    ke_hist = [ke_hist ke];
    pe_hist = [pe_hist pe];
    me_hist = [me_hist me];

    set(ke_h, 'XData', e_hist_t);
    set(ke_h, 'YData', ke_hist);
    set(pe_h, 'XData', e_hist_t);
    set(pe_h, 'YData', pe_hist);
    set(me_h, 'XData', e_hist_t);
    set(me_h, 'YData', me_hist);

    % We do not start plotting until we have sufficient data to plot trails
    if i >= history_size
        % Plot the motion of the planets
        for j = 1:N
            set(h(j), 'XData', bodies_history(:, j, 1));
            set(h(j), 'YData', bodies_history(:, j, 2));
            set(h(j), 'ZData', bodies_history(:, j, 3));
        end
        
        drawnow limitrate
    end
end
