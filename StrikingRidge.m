function ridges = StrikingRidge(strikingPlatform, blanks, scars)

if nargin < 3
%     [name, path] = uigetfile('ScarsQins-*.mat'); 
    name = 'ScarsQins-EG_IV_3028.mat'; path = 'E:\Archeology Lab\forItamar\FrancescoNewBugs\';
    scars = load([path name]);
end

% scarsInfoFig = figure;
% patch('Faces',scars.sdata(strikingPlatform).faces,'Vertices',scars.v,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
%       'SpecularExponent',30,'SpecularStrength',0.1,'Tag',getPatchTag);
% hold on;
% axis equal;
% view(90,90)
% bright_light([0 0 1],[0 0 0]);

ridges = {};
neighbors = cell2mat(scars.scars_data(:, 2));
for neighbor = blanks    
    eitherNeighbor = neighbors == [min(strikingPlatform, neighbor), max(strikingPlatform, neighbor)];
    bothNeighbors = eitherNeighbor(:, 1) & eitherNeighbor(:, 2);
    ridgeIndices = find(bothNeighbors > 0);
%     patch('Faces',scars.sdata(neighbor).faces,'Vertices',scars.v,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
%       'SpecularExponent',30,'SpecularStrength',0.1,'Tag',getPatchTag);
    for i = 1:length(ridgeIndices)
        ridges{end + 1} = scars.scars_data{ridgeIndices(i), 1};
    end
end
% figure
% hold on
% plot3(ridge(:, 1), ridge(:, 2), ridge(:, 3));
% for i = 1:length(ridges)
%     ridgeSegment = ridges{i};
%     plot3(ridgeSegment(:, 1), ridgeSegment(:, 2), ridgeSegment(:, 3));
% end
end