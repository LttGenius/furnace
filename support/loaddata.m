function [ datasets ] = loaddata( varargin )
%LOADDATA load data

narginchk( 1, 1 );
datasets_flag_name_file = varargin{1};
dataset_flag = datasets_flag_name_file(:, 1);
dataset_name = datasets_flag_name_file(:, 2);
datsets_file = datasets_flag_name_file(:, 3);
num_datasets = numel( datsets_file );
datasets_array = cell(num_datasets, 1); 
for data_index = 1:num_datasets
    % whether path
    if isstring(datsets_file{data_index}) || ischar(datsets_file{data_index})
        datasets_array{data_index} = load(datsets_file{data_index});
    else
        datasets_array{data_index} = datsets_file{data_index};
    end
end
datasets(:, 1) = dataset_flag;
datasets(:, 2) = dataset_name;
datasets(:, 3) = datasets_array;
end

