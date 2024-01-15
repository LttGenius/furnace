function [ ResultsTable ] = performparallel( Print2Terminal, SaveFlag, SavePath, metrics, varargin )
%PERFORPARALLEL

% Initilization.
models = varargin{1};
datasets = varargin{2};
uCtrl = varargin{3};
sCtrl = varargin{4};
ShowBar = varargin{5};

% Linearization.
[ linearization_map, N, num_methods, num_datasets ] = linearization( varargin{1}, varargin{2} );

% Run in parallel.
results = cell(N, 1);
if ShowBar
    MyBar = parfor_progress(N);
end
parfor index = 1:N
% for index = 1:N
    method_index= linearization_map{index}(1);
    data_index = linearization_map{index}(2);
    data_name = datasets{data_index, 2};
    method_name = models{method_index, 2};

    [ performance ] = performmodel( models{method_index, 3}, ...
        datasets{data_index, 3}, ...
        uCtrl, ...
        sCtrl{method_index});

    % Print
    if Print2Terminal
        print2terminal( index, N, metrics, method_name, data_name, performance, 1 )
    end
    
    % Bar
    if ShowBar
        parfor_progress; 
    end

    %Save
    if SaveFlag
       savedata( 1, SavePath, performance, data_name, method_name );
    end

    results{index} = performance;
end

if ShowBar
    parfor_progress(0); % Clean up
end

% Get result as a Table. 
% Model  Data1  Data2
% ----   ----   ----
% M1     P11     P12
% M2     P21     P22
map_result = cell( num_methods, num_datasets );
for index = 1:N
    method_index= linearization_map{index}(1);
    data_index = linearization_map{index}(2);
    map_result{method_index, data_index} = results{index};
end
clear results
MNames = models(:, 2);
DNames = datasets(:, 2);
ResultsTable = cell2table(map_result, "VariableNames", DNames, 'RowNames',MNames);

end

