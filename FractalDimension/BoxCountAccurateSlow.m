function boxes = BoxCountAccurateSlow(line, boxSize)
    boxes = 0;
    for i = 2:size(line, 1)
       boxes = boxes + BoxCoverLine(line(i - 1, :), line(i, :), boxSize);
    end
end

function boxes = BoxCoverLine(start, finish, boxSize)
    direction = (finish - start) / norm(finish - start);
    boxes = 0;
    while (dot(direction, finish - start) > 0)
        boxes = boxes + 1;
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