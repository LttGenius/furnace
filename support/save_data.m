function save_data( dataset_name, path_dir, results, method_name, index )
    if(~exist(path_dir,'dir'))
        mkdir(path_dir);
    end
    if nargin < 4
        save_path = strcat(path_dir, "/", dataset_name, ".mat");
        save(save_path, "dataset_name", "results")
    elseif nargin < 5
        save_path = strcat(path_dir, "/", dataset_name, "_", method_name, ".mat");
        save(save_path, "dataset_name", "method_name", "results")
    else
        save_path = strcat(path_dir, "/", dataset_name, "_COMPARE", ".mat");
        save(save_path, "dataset_name", "index", "results")
    end
end

