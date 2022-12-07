function [bodies] = step_lf(bodies, masses, dt, softening)
%STEP_LF Moves the simulation forward by a fixed step using leapfrog
%integration. Leapfrog integration has error O(h^2), which is sufficient
%to be used as part of rk4.
%   bodies: an N x 9 matrix, where each row holds the position, velocity,
%   and acceleration for that body
%   masses: an N x 1 matrix, where each row holds the mass for that body
%   dt: the fixed timestep
%   softening: the distance below which gravity is supressed

% Step the position
bodies(:, 1:3) = bodies(:, 1:3) + bodies(:, 4:6) * dt;

bodies = get_accel(bodies, masses, softening);

% Perform the last step of leapfrog
bodies(:, 4:6) = bodies(:, 4:6) + bodies(:, 7:9) * dt;

end

