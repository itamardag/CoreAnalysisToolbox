function [straightLineRidges, jaggedness, edgeLengthVar, angleVar, angleMean] = StraightLineApprox(strikingPlatform, blanks, scars)
if nargin < 3
    [name, path] = uigetfile('ScarsQins-*.mat'); 
%     name = 'ScarsQins-EG_IV_3028.mat'; path = 'E:\Archeology Lab\forItamar\FrancescoNewBugs\';
    scars = load([path name]);
end

figure
hold on
straightLineRidges = cell(size(blanks));
jaggedness = zeros(size(blanks));
neighbors = cell2mat(scars.scars_data(:, 2));
[up, ~] = SurfaceMeanNorm(scars.sdata(strikingPlatform).faces, scars.v, [0 0 0]);
for neighborIndex = 1:length(blanks)
    neighbor = blanks(neighborIndex);
    [forward, ~] = SurfaceMeanNorm(scars.sdata(neighbor).faces, scars.v, [0 0 0]);
    eitherNeighbor = neighbors == [min(strikingPlatform, neighbor), max(strikingPlatform, neighbor)];
    bothNeighbors = eitherNeighbor(:, 1) & eitherNeighbor(:, 2);
    ridgeIndices = find(bothNeighbors > 0);
    ridge = [];
    patch('Faces',scars.sdata(neighbor).faces,'Vertices',scars.v,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
      'SpecularExponent',30,'SpecularStrength',0.1,'Tag',getPatchTag);
    for i = 1:length(ridgeIndices)
        plot3(scars.scars_data{ridgeIndices(i), 1}(:, 1), scars.scars_data{ridgeIndices(i), 1}(:, 2), scars.scars_data{ridgeIndices(i), 1}(:, 3))
        ridge = [ridge; scars.scars_data{ridgeIndices(i), 1}];
    end
    [p1, p2, residuals] = LineApprox(ridge, forward, up);
    straightLineRidges{neighborIndex} = [p1; p2];
    jaggedness(neighborIndex) = var(sqrt(dot(residuals', residuals')));
    plot3([p1(1), p2(1)], [p1(2), p2(2)], [p1(3), p2(3)]);
end
lengths = zeros(length(straightLineRidges), 1);
angles = zeros(length(straightLineRidges), 1);
for i = 1:length(straightLineRidges)
   edge = straightLineRidges{i}(2, :) - straightLineRidges{i}(1, :);
   if (i < length(straightLineRidges))
       nextEdge = straightLineRidges{i + 1}(2, :) - straightLineRidges{i + 1}(1, :);
   else
       nextEdge = straightLineRidges{1}(2, :) - straightLineRidges{1}(1, :);
   end
   
   lengths(i) = norm(edge);
   angles(i) = acos(dot(edge, nextEdge) / (norm(edge) * norm(nextEdge)));
end
edgeLengthVar = var(lengths / mean(lengths));
angleVar = var(angles / mean(angles));
angleMean = mean(angles);
end
