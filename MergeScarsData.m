function MergeScarsData(newName)
[name, path] = uigetfile('ScarsQins-*.mat');
scars = load([path name]);
ridges = [scars.scars_data{:, 2}];
ridges = reshape(ridges, [2, length(ridges)/2])';
for i = 1:length(scars.scarGroups)
    group = scars.scarGroups{i};
    if ~isempty(group)
		for scar = group(2:end)'
			scars.sdata(group(1)).faces = [scars.sdata(group(1)).faces; scars.sdata(scar).faces];
			scars.sdata(group(1)).vertices = [scars.sdata(group(1)).vertices; scars.sdata(scar).vertices];
			scars.sdata(group(1)).neighbor_scars = [scars.sdata(group(1)).neighbor_scars; ...
												   scars.sdata(scar).neighbor_scars];
			scars.sdata(group(1)).br_ridges = [scars.sdata(group(1)).br_ridges, scars.sdata(scar).br_ridges];
		 
			scars.sdata(scar).faces = [];
			scars.sdata(scar).vertices = [];
			scars.sdata(scar).neighbor_scars = [];
			scars.sdata(scar).br_ridges = {};
			scars.GL(scars.GL == scar) = group(1);
			
			replace = find(ridges == scar);
			for j = 1:length(replace)
				index = replace(j);
				if index <= length(ridges)
					current = scars.scars_data{index, 2};
					current = sort([group(1), current(2)]);
					scars.scars_data{index, 2} = current;
				else
					current = scars.scars_data{index - length(ridges), 2};
					current = sort([group(1), current(1)]);
					scars.scars_data{index - length(ridges), 2} = current;
				end
			end
		end
		for scar = group'
		   scars.sdata(group(1)).neighbor_scars(scars.sdata(group(1)).neighbor_scars == scar) = [];
		end
		scars.sdata(group(1)).neighbor_scars = unique(scars.sdata(group(1)).neighbor_scars);
        for j = 1:length(scars.sdata)
            for scar = group(2:end)'
                scars.sdata(j).neighbor_scars(scars.sdata(j).neighbor_scars == scar) = group(1);
            end
            scars.sdata(j).neighbor_scars = unique(scars.sdata(j).neighbor_scars);
        end
    end
end

if nargin < 1
    fileName = [path name];
else 
    fileName = [path newName];
end
save(fileName, '-struct', 'scars');
end