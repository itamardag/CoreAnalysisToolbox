function [segments, normals, variances] = ScarStripsNormals(faces, vertices, ridge, segmentLength)
% SCARSTRIPSNORMALS Calculates the normals of strips of the surface
%
[scarNorm, ~] = SurfaceMeanNorm(faces, vertices, [0, 0, 0]);
scalarProjection = dot(repmat(scarNorm',1 , length(vertices)), vertices')';
vectorProjection = repmat(scalarProjection, 1, 3) .* repmat(scarNorm, length(scalarProjection), 1);
rotVec = vrrotvec(scarNorm, [0, 0, 1]);
xyPlaneProjection = (vrrotvec2mat(rotVec) * (vertices - vectorProjection)')';

ridgeScalarProjection = dot(repmat(scarNorm', 1, length(ridge)), ridge')';
ridgeVectorProjection = repmat(ridgeScalarProjection, 1, 3) .* repmat(scarNorm, ...
                               length(ridgeScalarProjection), 1);
planeRidge = ridge - ridgeVectorProjection;
xyRidge = (vrrotvec2mat(rotVec) * planeRidge')';
coefficients = polyfit(xyRidge(:, 1), xyRidge(:, 2), 1);
ridgeLineVec = (vrrotvec2mat([rotVec(1:3), -rotVec(4)]) * [1; coefficients(1); 0])';
ridgeLineVec = ridgeLineVec / norm(ridgeLineVec);

segments = {};
for i = 1:length(faces)
    distances = zeros(length(faces(i, :)), 1);
    for j = 1:length(faces(i, :))
       distances(j) = PointLineDistance(xyPlaneProjection(faces(i, j), 1:2), [1; coefficients(1)], ...
                                        [mean(xyRidge(:, 1)); mean(xyRidge(:, 2))]);
    end
    dist = ceil(mean(distances) / segmentLength);
    if length(segments) >= dist
       segments{dist} = [segments{dist}; faces(i, :)];
    else
       segments{dist} = faces(i, :);
    end
end
for segment = 1:length(segments)
    if length(segments{segment}) < 10
        segments(segment) = {NaN};
    end
end

normals = zeros(length(segments), 3); 
variances = zeros(length(segments), 1);
for i = 1:length(segments)
   [normals(i, :), variances(i)] = SurfaceMeanNorm(segments{i}, vertices, ridgeLineVec);
end
end
    
function d = PointLineDistance(point, direction, origin)
% For more information see "Distance from a point to a line" on wikipedia
    xCoordinates = [point(1), origin(1), origin(1) + direction(1)];
    yCoordinates = [point(2), origin(2), origin(2) + direction(2)];
    filler = [1 1 1];
    d = abs(det([xCoordinates; yCoordinates; filler])) / norm(direction);
end