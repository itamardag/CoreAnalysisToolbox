function baseAngle = BaseAngle(strikingPlatform, blanks, segmentLength, segmentNum,scars)

if nargin<5
    [name, path] = uigetfile('ScarsQins-*.mat'); %name = 'ScarsQins-EG_I_71_451.mat'; path = 'E:\Archeology Lab\forItamar\';
    scars = load([path name]);
end
scars=load(scars);
ridgeIndex = 1;
while ridgeIndex < length(scars.scars_data(:, 1))
    if length(scars.scars_data{ridgeIndex, 1}) < 4
        scars.scars_data(ridgeIndex, :) = [];
    else
        ridgeIndex = ridgeIndex + 1;
    end
end
neighborAngles = zeros(length(blanks), 1);
perimiter = 0;
neighbors = cell2mat(scars.scars_data(:, 2));
for neighbor = blanks    
    eitherNeighbor = neighbors == [min(strikingPlatform, neighbor), max(strikingPlatform, neighbor)];
    bothNeighbors = eitherNeighbor(:, 1) & eitherNeighbor(:, 2);
    ridgeIndices = find(bothNeighbors > 0);
    ridgeLength = 0;
    for i = 1:length(ridgeIndices)
        ridgeLength = ridgeLength + length(scars.scars_data{ridgeIndices(i), 1});
    end
    if ridgeLength > 0
        [angle, ~, ~, ~] = AngleBetweenScars(strikingPlatform, neighbor,  segmentLength, segmentNum, true, ...
                                             scars);
    end
    neighborAngles(neighbor) = angle * ridgeLength;
    perimiter = perimiter + ridgeLength;
end
baseAngle = sum(neighborAngles) / perimiter;
end