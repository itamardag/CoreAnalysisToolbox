function [meanNorm, variance] = SurfaceMeanNorm(faces, vertices, varOrthogonalDir)
% SURFACEMEANNORM Calculates the mean normal of a surface
% @param vertices: N*3 Matrix of all vertices on the surface, given by x,y,z coordinates.
% @param faces: M*3 Matrix of all faces on the surface, given by threes of vertices creating triangles.
% @param varOrthogonalDir: 3D Vector defining a direction orthogonal to along which variance will be measured.
% @return meanNorm: The mean normal of the surface.
% @return var: The variance in normals ortohogonally to varOrthogonalDir.
if isnan(faces)
    meanNorm = NaN;
    variance = NaN;
    return
end
normals = facenormals(faces, vertices);
projectedNormals = zeros(size(normals));
for i = 1:length(normals(:, 1))
    normals(i, :) = normals(i, :) / norm(normals(i, :)); %facenormals return non-normal vectors
    projection = dot(normals(i, :), varOrthogonalDir) * varOrthogonalDir;
    projectedNormals(i, :) = (normals(i, :) - projection) / norm(normals(i, :) - projection);
end
meanNorm = squeeze(mean(normals));
meanNorm = meanNorm / norm(meanNorm);
meanForDot = repmat(meanNorm, length(projectedNormals(:, 1)), 1);
varAngles = acos(max(min(dot(projectedNormals', meanForDot'), 1), -1));
variance = var(varAngles);
end

function [fn]=facenormals(f,v)
%
v1=v(f(:,2),:)-v(f(:,1),:);
v2=v(f(:,3),:)-v(f(:,2),:);
fn=cross(v2,v1);
end