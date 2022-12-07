function [x] = get_cm(bodies, masses)
%GET_CM Calculates the position of the center of mass
%   bodies: an N x 9 matrix, where each row holds the position, velocity,
%   and acceleration for that body
%   masses: an N x 1 matrix, where each row holds the mass for that body

x = (bodies(:, 1:3)' * masses ./ sum(masses))';

end

