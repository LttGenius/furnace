function [ ResultsTable ] = performserial( Print2Terminal, SaveFlag, SavePath, metrics, varargin )
%PERFORMSERIAL 

% Initilization.
models = varargin{1};
datasets = varargin{2};
uCtrl = varargin{3};
sCtrl = varargin{4};
ShowBar = varargin{5};
BarInformation = varargin{6};

methods_flag = models(:, 1);
methods_name = models(:, 2); 
methods_file = models(:, 3); 

datasets_flag = datasets(:, 1);
datasets_name = datasets(:, 2);
datasets_file = datasets(:, 3);

nMethods = numel(methods_flag);
nDatasets = numel(datasets_flag);
N = nMethods * nDatasets;

% Run in serial.
map_result = cell( nMethods, nDatasets );
map_result{1, 1} = 'Methods';

% Per dataset. 
if ShowBar
    MyBar = waitbar(0, BarInformation);
end
for iData = 1:nDatasets

    % Per model.
    for iMethod = 1:nMethods
        method_name = methods_name{iMethod};
        [ performance ] = performmodel( methods_file{iMethod}, ...
            datasets_file{iData}, ...
            uCtrl, ...
            sCtrl{iMethod});
        
        index = (iData - 1) * nMethods + iMethod;
        % Print
        if Print2Terminal
            print2terminal( index, N, metrics, method_name, data_name, performance, 0 )
        end
        
        % Bar
        if ShowBar
            waitbar( index / N , MyBar);
        end

        %Save
        if SaveFlag
           savedata( 1, SavePath, performance, data_name, method_name );
        end
        
        map_result{iMethod, iData} = performance;
    end
end
if ShowBar
    close(MyBar);
end

% Get result as a Table. 
% Model  Data1  Data2
% ----   ----   ----
% M1     P11     P12
% M2     P21     P22
ResultsTable = cell2table(map_result, "VariableNames", datasets_name, 'RowNames', methods_name);

end

