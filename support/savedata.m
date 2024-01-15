function savedata( model, path_dir, results, varargin )
    if(~exist(path_dir,'dir'))
        mkdir(path_dir);
    end
    % MODEL 0
    if model == 0
        DataName = varargin{1};
        save_path = strcat(path_dir, "/", DataName, ".mat");
        save(save_path, "DataName", "results")

    % MODEL 1
    elseif model == 1
        DataName = varargin{1};
        MethodName = varargin{2};
        save_path = strcat(path_dir, "/", DataName, "_", MethodName, ".mat");
        save(save_path, "DataName", "MethodName", "results")

    % MODEL 2
    elseif model == 2
        TASK = varargin{1};
        datasets = varargin{2};
        methods = varargin{3};
        parametersets = varargin{4}; 

        save_path = strcat(path_dir, "/", TASK, "_", ...
            string(datetime('now', 'Format', 'dd_MM_y_H_mm_ss')), ".mat");
        save(save_path, "methods", "datasets", "parametersets", "results")
    
    %  MODEL 3
    elseif model == 3
        TASK = varargin{1};
        datasets = varargin{2};
        methods = varargin{3};

        save_path = strcat(path_dir, "/", TASK, "_", ...
            string(datetime('now', 'Format', 'dd_MM_y_H_mm_ss')), ".mat");
        save(save_path, "methods", "datasets", "results")
    end
end

