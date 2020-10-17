function [angle, variance, possibleAngles, variances,err] = AngleBetweenScars(scar1, scar2, segmentLength, ...
                                                                          segmentNumber, useSPStable,...
                                                                          scars, file)
if nargin < 6
    [name, path] = uigetfile('ScarsQins-*.mat');
    fileName = [path '\' name];
    scars = load(fileName);
end
existingRidges = reshape([scars.scars_data{:, 2}]', 2, length([scars.scars_data{:, 2}]')/2)';
index = 0;
for i = 1:length(existingRidges)
   if existingRidges(i, 1) == min([scar1, scar2]) && existingRidges(i, 2) == max([scar1, scar2]) ...
      && length(scars.scars_data{i, 1}) >= 10
       index = i;
       break;
   end
end
err=[];
if index == 0
%         msgbox({'Scars do not share a ridge. Please pick scars that share a ridge.';...
        err=['No shared ridge: ',file,'; Scar1 ID: ',num2str(scar1),'; Scar2 ID: ',num2str(scar2)];
        angle=[];
        variance=[];
        possibleAngles=[];
        variances=[];
            return
end
ridge = scars.scars_data{index, 1};
[~, normals1, variances1] = ScarStripsNormals(scars.sdata(scar1).faces, scars.v, ridge, segmentLength);
[~, normals2, variances2] = ScarStripsNormals(scars.sdata(scar2).faces, scars.v, ridge, segmentLength);

mostStable1 = find(variances1 == min(variances1(1:min(segmentNumber, length(variances1)))), 1);
mostStable2 = find(variances2 == min(variances2(1:min(segmentNumber, length(variances2)))), 1);

angle =  pi-acos(max(min(dot(normals1(mostStable1, :), normals2(mostStable2, :)), 1), -1));
variance = variances1(mostStable1) + variances2(mostStable2);

if useSPStable
    possibleAnglesSize = length(variances2);
else
    possibleAnglesSize = min(length(variances1), length(variances2));
end
possibleAngles = zeros(possibleAnglesSize, 1);
variances = zeros(size(possibleAngles));

scar1Index = mostStable1;
for i = 1:length(possibleAngles)
    if ~useSPStable
        scar1Index = i;
    end
    possibleAngles(i) = pi-acos(max(min(dot(normals1(scar1Index, :), normals2(i, :)), 1), -1));
    variances(i) = variances1(scar1Index) + variances2(i);
end