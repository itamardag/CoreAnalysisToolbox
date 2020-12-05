function [] = DrawObject(withWalls, qinsFile, path)
    if nargin < 3
        [qinsFile, path] = uigetfile('Qins-*.mat'); 
%         qinsFile = 'Qins-18MII_6.mat'; path = 'E:\Archeology Lab\positioning francesco\';
    end
    scarsFile = ['Scars' qinsFile];
    load([path qinsFile]);
    load([path scarsFile]);
    
    rotv = (manual_pos_matrix * v')';
    figure;
    hold on;
    for i = 1:n_scars
        patch('Faces',sdata(i).faces,'Vertices',rotv,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
              'SpecularExponent',30,'SpecularStrength',0.1);
    end
    axis equal;
    view(90,90);
    light('color',[1 1 1],'position',[0,0,1]);
    
    if(withWalls)
        x = [bounds.fullWidth(1) bounds.fullWidth(2)];
        y = [bounds.fullThickness(1) bounds.fullThickness(2)];
        z = [bounds.fullLength(1) bounds.fullLength(2)];
        xBlanks = [bounds.blanksWidth(1) bounds.blanksWidth(2)];
        zBlanks = [bounds.blanksLength(1) bounds.blanksLength(2)];
        
        % Full Length
        DrawCleanArtifact(n_scars, sdata, rotv);
        set(gcf, 'Name', 'Full Length');
        
        surf(x, y, ones(2) * z(1));
        surf(x, y, ones(2) * z(2));
        view(0, 0);
        %%%%
        
        % Blanks Length
        DrawCleanArtifact(n_scars, sdata, rotv);
        set(gcf, 'Name', 'Blanks Length');
        
        surf(x, y, ones(2) * zBlanks(1));
        surf(x, y, ones(2) * zBlanks(2));
        view(0,0);
        %%%%
        
        % Full Width
        DrawCleanArtifact(n_scars, sdata, rotv);
        set(gcf, 'Name', 'Full Width');
        
        surf([x(1) x(1)], y, [z(1) z(2); z(1) z(2)]);
        surf([x(2) x(2)], y, [z(1) z(2); z(1) z(2)]);
        view(0, 0);
        %%%%
        
        % Blanks Width
        DrawCleanArtifact(n_scars, sdata, rotv);
        set(gcf, 'Name', 'Blanks Width');
        
        surf([xBlanks(1) xBlanks(1)], y, [z(1) z(2); z(1) z(2)]);
        surf([xBlanks(2) xBlanks(2)], y, [z(1) z(2); z(1) z(2)]);
        view(0, 0);
        %%%%
        
        % Full Depth
        DrawCleanArtifact(n_scars, sdata, rotv);
        set(gcf, 'Name', 'Full Depth');
        
        surf(x, [y(1) y(1)], [z(1) z(1); z(2) z(2)]);
        surf(x, [y(2) y(2)], [z(1) z(1); z(2) z(2)]);
        view(90, 90);
        %%%%
    end
    
end

function [] = DrawCleanArtifact(n_scars, sdata, rotv)
        figure;
        hold on;
        for i = 1:n_scars
        patch('Faces',sdata(i).faces,'Vertices',rotv,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
              'SpecularExponent',30,'SpecularStrength',0.1);
        end
        axis equal;
        light('color',[1 1 1],'position',[0,0,1]);
end