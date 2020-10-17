function [curvature] = ThreePointCurvature(a, b, c)
vertexParams = zeros(3, 2);
vertexParams(1, 1) = acos(dot(b - a, c - a) / (norm(b - a) * norm(c - a)));
vertexParams(2, 1) = acos(dot(c - b, a - b) / (norm(a - b) * norm(c - b)));
vertexParams(3, 1) = acos(dot(a - c, b - c) / (norm(a - c) * norm(b - c)));
vertexParams(1, 2) = norm(c - b);
vertexParams(2, 2) = norm(a - c);
vertexParams(3, 2) = norm(b - a);

angle = 0;
length = 0;
for i = 1:3
    if vertexParams(i, 1) > pi / 2
        angle = vertexParams(i, 1);
        length = vertexParams(i, 2);
    end
end
if angle == 0
    angle = vertexParams(1, 1);
    length = vertexParams(1, 2);
end

curvature = 2 * sin(angle) / length;
