function [ linearization_map, N, num_methods, num_datasets ] = linearization( varargin )
%UNTITLED linearization for parallel. 

narginchk( 2, 2 );

methods_name_file = varargin{1};
% methods_fieldnames = methods_name_file{1}; % get names of methods.
methods_file = methods_name_file(:, 3); % get files of methods.

datasets_flag_name_file = varargin{2};
dataset_flag = datasets_flag_name_file(:, 1);
% dataset_name = datasets_flag_name_file{2};
% datsets_file = datasets_flag_name_file{3};

num_methods = numel( methods_file );
num_datasets = numel( dataset_flag );

% Get linearization. 
N = num_methods * num_datasets;
linearization_map = cell( N, 1 );
rand_datasets = randperm( num_datasets );
rand_methods = randperm( num_methods );
for method_index = 1:num_methods
    for datasets_index = 1:num_datasets
        linearization_map{ (method_index - 1) * num_datasets + datasets_index  } =...
            [rand_methods(method_index), rand_datasets(datasets_index)];
    end
end

