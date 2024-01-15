function [ ResultMap ] = dataanalysis( data, keys )
%UNTITLED2 此处显示有关此函数的摘要

[NModels, NDatasets] = size(data);
Nkeys = numel(keys);
ResultMap = zeros(NModels, NDatasets, Nkeys);
TempMap = zeros(NModels, NDatasets, Nkeys);

% Get optimal model for each dataset. 
for iData = 1:NDatasets
    for iModel = 1:NModels
        r = data{iModel, iData};
        for iKey = 1:Nkeys
            m = r.(keys{iKey});
            if numel(m) > 1
                TempMap(iModel, iData, iKey) = m(1);
            else
                TempMap(iModel, iData, iKey) = m(1);
            end
        end
    end
end

[ ~, SortIndex ] = sort(TempMap, 1, 'descend');
for iData = 1:NDatasets
    for iModel = 1:NModels
        for iKey = 1:Nkeys
            t = SortIndex(iModel, iData, iKey);
            ResultMap(t, iData, iKey) = iModel;
        end
    end
end
end

