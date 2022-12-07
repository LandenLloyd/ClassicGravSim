function [me] = get_me(bodies, masses)
%GET_ME Gets the total mechanical energy of the system at the current
%timestep.
%   bodies: an N x 9 matrix, where each row holds the position, velocity,
%   and acceleration for that body
%   masses: a 1 x N matrix, where each row holds the mass for that body

[~, N] = size(masses);
G = 6.67e-11;
me = 0;

for i = 1:N
    % Add the kinetic energy
    me = me + 1/2 * masses(i) * sum(bodies(i, 4:6).^2);

    % Calculate total gravitational potential
    for j = 1:N
        if j ~= i
            me = me - (G * masses(i) * masses(j)) / ...
                (norm(bodies(j, 1:3) - bodies(i, 1:3)));
        end
    end
end

end

