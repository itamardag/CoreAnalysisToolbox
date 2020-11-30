function [manual_pos_matrix] = SetUpForwardDirections(qinsFile, up, forward)
up = (up / norm(up))';
forward = forward' - dot(forward, up) * up;
forward = forward / norm(forward);
xAngleUp = atan2(up(2), up(3));
Rx = [[1, 0, 0]; [0, cos(xAngleUp), -sin(xAngleUp)]; [0, sin(xAngleUp), cos(xAngleUp)]];
up = Rx * up;
forward = Rx * forward;
yAngleUp = atan2(up(3), up(1)) - pi/2;
Ry = [[cos(yAngleUp), 0, sin(yAngleUp)]; [0, 1, 0]; [-sin(yAngleUp), 0, cos(yAngleUp)]];
up = Ry * up;
forward = Ry * forward;
zAngleForward = -atan2(forward(2), forward(1));
Rz = [[cos(zAngleForward), -sin(zAngleForward), 0]; [sin(zAngleForward), cos(zAngleForward), 0]; [0, 0, 1]];
up = Rz * up;
forward = Rz * forward;
manual_pos_matrix = Rz * Ry * Rx;
save(qinsFile, 'manual_pos_matrix', '-append');
end