function [p1, p2, curvatures, residuals, avgPointDist, totalLineLength] = LineApprox(ridge, forward, up)
radi = zeros(size(ridge, 1), 1);
length = zeros(size(ridge, 1), 1);
direction = cross(forward, up) / norm(cross(forward, up));
residuals = zeros(size(ridge));
curvatures = zeros([size(ridge, 1) - 2, 1]);
lengths = zeros([size(ridge, 1) - 1, 1]);
for i = 1:size(ridge, 1)
    radi(i) = dot(ridge(i, :), forward);
end
origin = (ridge(find(radi == min(radi), 1), :) + ridge(find(radi == max(radi), 1), :)) / 2;
for i = 1:size(ridge, 1)
    length(i) = dot(ridge(i, :) - origin, direction);
    residuals(i, :) = ridge(i, :) - origin - length(i) * direction;
    if (i ~= 1 && i ~= size(ridge, 1))
       curvatures(i - 1) = ThreePointCurvature(ridge(i - 1, :), ridge(i, :), ridge(i + 1, :));
    end
    if (i ~= 1)
       lengths(i - 1) = norm(ridge(i, :) - ridge(i - 1, :));
    end
end
p1 = origin + min(length) * direction;
p2 = origin + max(length) * direction;
avgPointDist = mean(lengths);
totalLineLength = sum(lengths);
end