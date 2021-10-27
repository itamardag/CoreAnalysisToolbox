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
[seg1, normals1, variances1] = ScarStripsNormals(scars.sdata(scar1).faces, scars.v, ridge, segmentLength);
[seg2, normals2, variances2] = ScarStripsNormals(scars.sdata(scar2).faces, scars.v, ridge, segmentLength);

mostStable1 = find(variances1 == min(variances1(1:min(segmentNumber, length(variances1)))), 1);
mostStable2 = find(variances2 == min(variances2(1:min(segmentNumber, length(variances2)))), 1);
figure;
patch('Faces',scars.f,'Vertices',scars.v,'facecolor',[1 1 1],'linestyle',...
    'none','AmbientStrength',0.3,'SpecularExponent',30,'SpecularStrength',0.1);
hold on
for i=1:size(seg1,2)
    patch('Faces',seg1{1,i},'Vertices',scars.v,'facecolor',[0 0 (1/size(seg1,2))*i],...
        'linestyle','none','AmbientStrength',0.3,'SpecularExponent',30,'SpecularStrength',0.1);
end
for i=1:size(seg2,2)
    patch('Faces',seg2{1,i},'Vertices',scars.v,'facecolor',[(1/size(seg2,2))*i 0 0],...
        'linestyle','none','AmbientStrength',0.3,'SpecularExponent',30,'SpecularStrength',0.1);
end
for i=2:size(scars.scars_data,1)
    plot3(scars.scars_data{i,1}(:,1),scars.scars_data{i,1}(:,2),...
        scars.scars_data{i,1}(:,3),'Color','k')
end
plot3(scars.scars_data{i,1}(:,1),scars.scars_data{i,1}(:,2),scars.scars_data{i,1}(:,3),'Color','k')
if useSPStable
    strip_cent=mean(scars.v(unique(seg1{1,mostStable1}),:));
    norm_v1=[strip_cent;strip_cent-(normals1(mostStable1,:).*10)];
    plot3(norm_v1(:,1),norm_v1(:,2),norm_v1(:,3),'color',[0 0 (1/size(seg1,2))*mostStable1])
else
    for i=1:size(seg1,2)
        if isnan(seg1{1,i})
        else
        strip_cent=mean(scars.v(unique(seg1{1,i}),:));
        norm_v1=[strip_cent;strip_cent-(normals1(i,:).*10)];
        plot3(norm_v1(:,1),norm_v1(:,2),norm_v1(:,3),'color',[0 0 (1/size(seg1,2))*i])
        end
    end
end
for i=1:size(seg2,2)
    if isnan (seg2{1,i})
    else
    strip_cent=mean(scars.v(unique(seg2{1,i}),:));
    norm_v1=[strip_cent;strip_cent-(normals2(i,:).*10)];
    plot3(norm_v1(:,1),norm_v1(:,2),norm_v1(:,3),'color',[(1/size(seg2,2))*i 0 0])
    end
end
axis equal; grid on
xlabel('x (mm)');ylabel('y (mm)');zlabel('z (mm)')
av_1=sum(normals1,1,'omitnan')/norm(sum(normals1,1,'omitnan'));
av_2=sum(normals2,1,'omitnan')/norm(sum(normals2,1,'omitnan'));
cr_n=cross(av_1,av_2)/norm(cross(av_1,av_2));
av_n=sum([normals2;normals1],1,'omitnan')/norm(sum([normals2;normals1],1,'omitnan'))*-1;
view(sum([cr_n;av_n],1))
camlight('left');


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