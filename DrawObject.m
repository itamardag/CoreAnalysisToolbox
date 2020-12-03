rotv = (manual_pos_matrix * v')';
scarsInfoFig = figure;
hold on;
for i = 1:n_scars
    patch('Faces',sdata(i).faces,'Vertices',rotv,'facecolor',[1 1 1],'linestyle','none','AmbientStrength',0.3, ...
          'SpecularExponent',30,'SpecularStrength',0.1);
end
axis equal;
view(90,90);
light2=light('color',[1 1 1],'position',[0,0,1]);