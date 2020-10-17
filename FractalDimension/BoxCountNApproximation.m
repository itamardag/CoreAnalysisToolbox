function boxesNumber = BoxCountNApproximation(line, boxSize)
    boxes = table();
    for i = 2:size(line, 1)
       segmentBoxes = BoxCoverLine(line(i - 1, :), line(i, :), boxSize);
       boxes = [boxes; segmentBoxes];
    end
    boxes = unique(boxes);
    boxesNumber = size(boxes, 1);
end

function boxes = BoxCoverLine(start, finish, boxSize)
    direction = (finish - start) / norm(finish - start);
    boxes = table();
    while (dot(direction, finish - start) > 0)
        boxes(end + 1, :) = table(start - mod(start, boxSize));
        start = GridStep(start, direction, boxSize);
    end
end

function newStart = GridStep(start, direction, boxSize)
    gridStart = start - mod(start, boxSize);
    alpha = NaN(size(start));
    for j = 1:length(start)
        alpha(j) = (gridStart(j) + boxSize - start(j)) / direction(j);
    end
    newStart = start + min(abs(alpha)) * direction;
end