function [bodies] = get_accel(bodies, masses, softening)
%STEP_LF Moves the simulation forward by a fixed step using leapfrog
%integration. Leapfrog integration has error O(h^2), which is sufficient
%to be used as part of rk4.
%   bodies: an N x 9 matrix, where each row holds the position, velocity,
%   and acceleration for that body
%   masses: an N x 1 matrix, where each row holds the mass for that body
%   softening: the distance below which gravity is supressed
[~, N] = size(masses);
G = 6.67430e-11;

bodies(:, 7:9) = 0;

% Loop over each body, calculating acceleration before the first "kick"
for i = 1:N
    % Loop over each other body to apply the force of gravity
    for j = 1:N
        if i ~= j
            % Add the force of gravity from body j
            bodies(i, 7:9) = bodies(i, 7:9) + ...
                (G * masses(j) * (bodies(j, 1:3) - bodies(i, 1:3))) / ...
                (norm((bodies(j, 1:3) - bodies(i, 1:3)), 2).^2 + softening^2).^(3/2);
        end
    end
end

end

