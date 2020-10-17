function [counts, boxSizes, D] = RidgeDimension(strikingPlatform, blanks, boxSizes, scars)
if nargin < 4
    [name, path] = uigetfile('ScarsQins-*.mat'); 
%     name = 'ScarsQins-EG_IV_3028.mat'; path = 'E:\Archeology Lab\forItamar\FrancescoNewBugs\';
    scars = load([path name]);
end
if nargin < 3
    boxSizes = (ones(1, 9) * 4) .^ (0:-1:-8);
end

ridges = StrikingRidge(strikingPlatform, blanks, scars);
counts = zeros(size(boxSizes));
for i = 1:length(boxSizes)
    for j = 1:length(ridges)
        counts(i) = counts(i) + BoxCountAccurateSlow(ridges{j}, boxSizes(i));
    end
end
x = log(1./boxSizes);
y = log(counts);
D = y./x;
end