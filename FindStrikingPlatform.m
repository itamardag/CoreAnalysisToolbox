function scarID = FindStrikingPlatform()
[name, path] = uigetfile('ScarsQins-*.mat'); %name = 'ScarsQins-EG_I_71_451.mat'; path = 'E:\Archeology Lab\forItamar\';
scars = load([path name]);
scarTotalAngles = zeros(length(scars.sdata), 1);
ridgeIndex = 1;
while ridgeIndex < length(scars.scars_data(:, 1))
    if length(scars.scars_data{ridgeIndex, 1}) < 4
        scars.scars_data(ridgeIndex, :) = [];
    else
        ridgeIndex = ridgeIndex + 1;
    end
end
neighbors = cell2mat(scars.scars_data(:, 2));
for scarIndex = 1:length(scarTotalAngles)
    neighborAngles = zeros(length(scars.sdata(scarIndex).neighbor_scars), 1);
    perimiter = 0;
    for neighborIndex = 1:length(neighborAngles)
        neighbor = scars.sdata(scarIndex).neighbor_scars(neighborIndex);        
        eitherNeighbor = neighbors == [min(scarIndex, neighbor), max(scarIndex, neighbor)];
        bothNeighbors = eitherNeighbor(:, 1) & eitherNeighbor(:, 2);
        ridgeIndices = find(bothNeighbors > 0);
        ridgeLength = 0;
        for i = 1:length(ridgeIndices)
            ridgeLength = ridgeLength + length(scars.scars_data{ridgeIndices(i), 1});
        end
        if ridgeLength > 0
            [angle, ~, ~, ~] = AngleBetweenScars(scarIndex, neighbor, scars);
        end
        neighborAngles(neighbor) = angle * ridgeLength;
        perimiter = perimiter + ridgeLength;
    end
    scarTotalAngles(scarIndex) = sum(neighborAngles) / perimiter;
end
scarID = find(scarTotalAngles == min(scarTotalAngles));
end