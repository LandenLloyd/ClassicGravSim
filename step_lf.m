function [bodies] = step_lf(bodies, masses, dt)
%STEP_LF Moves the simulation forward by a fixed step using leapfrog
%integration. Leapfrog integration has error O(h^2), which is sufficient
%to be used as part of rk4.
%   bodies: an N x 9 matrix, where each row holds the position, velocity,
%   and acceleration for that body
%   masses: an N x 1 matrix, where each row holds the mass for that body
%   dt: the fixed timestep
[~, N] = size(masses);
G = 6.67430e-11;
e = 1e4; % the distance under which gravitation force is supressed

% Loop over each body, calculating acceleration before the first "kick"
for i = 1:N
    bodies(i, 7:9) = 0;

    % Loop over each other body to apply the force of gravity
    for j = 1:N
        if i ~= j
            % Add the force of gravity from body j
            bodies(i, 7:9) = bodies(i, 7:9) + ...
                (G * masses(j) * (bodies(j, 1:3) - bodies(i, 1:3))) / ...
                (norm((bodies(j, 1:3) - bodies(i, 1:3)), 2).^2 + e).^(3/2);
        end
    end
end

% Integrate each body according to the first two steps in leapfrog
for i = 1:N
    bodies(i, 4:6) = bodies(i, 4:6) + bodies(i, 7:9) * dt / 2;
    bodies(i, 1:3) = bodies(i, 1:3) + bodies(i, 4:6) * dt;
end

% Loop over each body, calculating acceleration after the second "kick"
for i = 1:N
    bodies(i, 7:9) = 0;

    % Loop over each other body to apply the force of gravity
    for j = 1:N
        if i ~= j
            % Add the force of gravity from body j
            % This includes a softening term to normalize the behavior
            % at small scales. See:
            % http://www.scholarpedia.org/article/N-body_simulations_(gravitational)#Introduction
            bodies(i, 7:9) = bodies(i, 7:9) + ...
                (G * masses(j) * (bodies(j, 1:3) - bodies(i, 1:3))) / ...
                (norm((bodies(j, 1:3) - bodies(i, 1:3)), 2).^2 + e).^(3/2);
        end
    end
end

% Perform the last step of leapfrog
for i = 1:N
    bodies(i, 4:6) = bodies(i, 4:6) + bodies(i, 7:9) * dt / 2;
end

end

