rotv = (manual_pos_matrix * v')';
scarsInfoFig = figure;
hold on;
for i = 1:n_scars
    patch('Faces',sdata(i).faces,'Vertices',rotv,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
          'SpecularExponent',30,'SpecularStrength',0.1,'Tag',getPatchTag);
end
axis equal;
view(90,90)
bright_light([0 0 1],[0 0 0]);