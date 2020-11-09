function [straightLineRidges, jaggedness, edgeLengthVar, angleVar, angleMean, angleTurn, pointDists] ...
    = StraightLineApprox(strikingPlatform, blanks, scars)
if nargin < 3
%     [name, path] = uigetfile('ScarsQins-*.mat'); 
    name = 'ScarsQins-L_18_H14bd_172_176_10.mat'; path = 'E:\Archeology Lab\francesco ridge segments bug\';
    scars = load([path name]);
end

% figure
% hold on
straightLineRidges = cell(size(blanks));
jaggedness = zeros(size(blanks));
pointDists = zeros([length(blanks), 2]);
neighbors = cell2mat(scars.scars_data(:, 2));
if isempty(scars.sdata(strikingPlatform).faces) % Striking platform was merged into another scar
       edgeLengthVar=nan;
       angleVar=nan;
       angleMean=nan;
       angleTurn=nan;
       return
end
[up, ~] = SurfaceMeanNorm(scars.sdata(strikingPlatform).faces, scars.v, [0 0 0]);
for neighborIndex = 1:length(blanks)
    neighbor = blanks(neighborIndex);
    if isempty(scars.sdata(neighbor).faces)
       continue; %scar was merged into another scar
    end
    [forward, ~] = SurfaceMeanNorm(scars.sdata(neighbor).faces, scars.v, [0 0 0]);
    eitherNeighbor = neighbors == [min(strikingPlatform, neighbor), max(strikingPlatform, neighbor)];
    bothNeighbors = eitherNeighbor(:, 1) & eitherNeighbor(:, 2);
    ridgeIndices = find(bothNeighbors > 0);
%     patch('Faces',scars.sdata(neighbor).faces,'Vertices',scars.v,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
%       'SpecularExponent',30,'SpecularStrength',0.1,'Tag',getPatchTag);
    totalLineLength = 0;
    totalCurvature = 0;
    totalWeight = 0;
    fullRidge = [];
    for i = 1:length(ridgeIndices)
%         plot3(scars.scars_data{ridgeIndices(i), 1}(:, 1), scars.scars_data{ridgeIndices(i), 1}(:, 2), scars.scars_data{ridgeIndices(i), 1}(:, 3))
        ridge = scars.scars_data{ridgeIndices(i), 1};
        fullRidge = [fullRidge; ridge];
        [~, ~, curvatures, ~, avgPointDist, lineLength] = LineApprox(ridge, forward, up);
        totalLineLength = totalLineLength + lineLength;
        curvatures(curvatures == inf) = [];
        curvatures(imag(curvatures) ~= 0) = [];
        if (~isempty(curvatures))
            totalCurvature = (totalCurvature * totalWeight + sum(curvatures)) / ...
                             (totalWeight + length(curvatures));
        end
    end
    [p1, p2, ~, ~, ~, ~] = LineApprox(fullRidge, forward, up);
    jaggedness(neighborIndex) = totalCurvature;
    straightLineRidges{neighborIndex} = [p1; p2];
    pointDists(neighborIndex, 1) = avgPointDist;
    pointDists(neighborIndex, 2) = totalLineLength;
%     plot3([p1(1), p2(1)], [p1(2), p2(2)], [p1(3), p2(3)]);
end
if length(straightLineRidges)>1 %more than 1 valid blank-plat pairs
lengths = NaN(length(straightLineRidges), 1);
angles = NaN(length(straightLineRidges), 1);
edges=zeros(length(straightLineRidges),3);
for i = 1:length(straightLineRidges)
   edges(i,:) = straightLineRidges{i}(2, :) - straightLineRidges{i}(1, :);
   if (i < length(straightLineRidges))
       nextEdge = straightLineRidges{i + 1}(2, :) - straightLineRidges{i + 1}(1, :);
   else
       nextEdge = straightLineRidges{1}(2, :) - straightLineRidges{1}(1, :);
   end
   
   lengths(i) = norm(edges(i,:));
   angles(i) = acos(dot(edges(i,:), nextEdge) / (norm(edges(i,:)) * norm(nextEdge)));
end
edgeLengthVar = var(lengths / mean(lengths,'omitnan'),'omitnan');
angleVar = var(angles / mean(angles,'omitnan'),'omitnan');
angleMean = mean(angles,'omitnan');
angleTurn=acos(dot(edges(1,:),edges(end,:))/(norm(edges(1,:))*norm(edges(end,:))));
else % 1 or less valid blanks-plat pairs
    edgeLengthVar=NaN;
    angleVar=NaN;
    angleMean=NaN;
    angleTurn=NaN;
end
end
