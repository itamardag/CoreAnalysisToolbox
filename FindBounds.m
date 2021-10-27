function [width, blanksWidth, len, blanksLength, thickness] = FindBounds(plat, blanks, qinsFile, path)
    if nargin < 4
        [qinsFile, path] = uigetfile('Qins-*.mat'); 
%         qinsFile = 'Qins-18MII_6.mat'; path = 'E:\Archeology Lab\positioning francesco\';
    end
    scarsFile = ['Scars' qinsFile];
    load([path qinsFile]);
    load([path scarsFile]);
    
    rotv = (manual_pos_matrix * v')';
    bounds = struct;
    bounds.fullThickness = [min(rotv(:, 1)), max(rotv(:, 1))];  
    bounds.fullWidth = [min(rotv(:, 2)), max(rotv(:, 2))];
    bounds.fullLength = [min(rotv(:, 3)), max(rotv(:, 3))];
    
    width = abs(bounds.fullWidth(2) - bounds.fullWidth(1));
    len = abs(bounds.fullLength(2) - bounds.fullLength(1));
    thickness = abs(bounds.fullThickness(2) - bounds.fullThickness(1));
    
    minBlanksLength = inf;
    maxBlanksLength = -inf;
    for blank = blanks
        blankV = (manual_pos_matrix * sdata(blank).vertices')';
        minBlanksLength = min(min(blankV(:, 3)), minBlanksLength);
        maxBlanksLength = max(max(blankV(:, 3)), maxBlanksLength);
    end
    bounds.blanksLength = [minBlanksLength, maxBlanksLength];
    blanksLength = abs(bounds.blanksLength(2) - bounds.blanksLength(1));
    
    minBlanksWidth = inf;
    maxBlanksWidth = -inf;
    for blank = blanks
        for ridgeIndex = 1:length(sdata(blank).br_ridges)
            ridge = (manual_pos_matrix * sdata(blank).br_ridges{ridgeIndex}')';
            minBlanksWidth = min(min(ridge(:, 2)), minBlanksWidth);
            maxBlanksWidth = max(max(ridge(:, 2)), maxBlanksWidth);
        end
    end
    bounds.blanksWidth = [minBlanksWidth, maxBlanksWidth];
    blanksWidth = abs(bounds.blanksWidth(2) - bounds.blanksWidth(1));
    figure
    patch('Faces',f,'Vertices',v,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
        'SpecularExponent',30,'SpecularStrength',0.1);
    for i=1:size(blanks,2)
     patch('Faces',sdata(blanks(i)).faces,'Vertices',v,'facecolor','r','linestyle','none','AmbientStrength',0.3, ...
            'SpecularExponent',30,'SpecularStrength',0.1);
    end
    patch('Faces',sdata(plat).faces,'Vertices',v,'facecolor','b','linestyle','none','AmbientStrength',0.3, ...
            'SpecularExponent',30,'SpecularStrength',0.1);
    axis equal
    view([1 1 1]*-1)
    camlight('right')
    grid on
    xlabel('Length (mm)');ylabel('Width (mm)');zlabel('Thickness (mm)')
    save([path qinsFile], 'bounds', '-append');
end