function boxes = BoxCount(line, boxSize)
    boxes = 0;
    for i = 2:size(line, 1)
       boxes = boxes + BoxCoverLine(line(i - 1, :), line(i, :), boxSize);
    end
end

function boxCount = BoxCoverLine(start, finish, boxSize)
    direction = (finish - start) / norm(finish - start);
    direction2D = [sqrt(direction(1)^2 + direction(2)^2), direction(3)];
    coverCoefficient = direction2D(1) / direction2D(2);
    overflow = coverCoefficient - floor(coverCoefficient);
    overflowCoefficient = overflow / (1 - overflow);
    boxEdge = (direction2D(2) / boxSize);
    boxCount = boxEdge * (coverCoefficient + overflowCoefficient);
end

% function newStart = GridStep(start, direction, boxSize)
%     gridStart = start - mod(start, boxSize);
%     alpha = NaN(size(start));
%     for j = 1:length(start)
%         alpha(j) = (gridStart(j) + boxSize - start(j)) / direction(j);
%     end
%     newStart = start + min(abs(alpha)) * direction;
% end