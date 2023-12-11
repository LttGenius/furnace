function [ report, IndexOfReport ] = racetrack( methods, data, rules) 
% Functional description:
% ------------------------
% Conducting comparative experiments
% 
% Formality:
% ------------------------
% methods.WTNNM = @(X, varargin)RUN_WTNNM(x, y, k, lambda, gamma, varargin{:});
% methods.KMEANS = @(X, varargin)RUN_KMEANS(x, y, k, 10, varargin{:});
% methods.myMethods = @(X, varargin)myMethod(x, y, parameters, varargin{:})
%
% X = load(Dataset_path);
%
% rules.parallel = 'on';
% rules.UnifiedCtrl = 1; % 
% rules.SpecificCtrl = {1, 2, 3}; % UnifiedCtrl and SpecificCtrl{i} will be
% used as `methods.WTNNM(X, rules.UnifiedCtrl, rules.SpecificCtrl{1})`
% 
% results = RACETRACK( methods, X, rules )
%
% Parameters
% ------------
%   $ methods $:
%     A structure with each value is a function. 
%     E.g. 
%           ` methods: 
%                     WTNNM:   RUN_WTNNM(X, varargin);
%                     KMEAMS:  RUN_KMEAMS(X, varargin)
%           `
%
%   $ X $:
%     The datasets used for the experiment.
%     Generally, `X` should contain the real data, the label and other
%     extra parameters. X is a (n x 2) cell, the first column contains names of datasets and the
%     second column contains entities of datasets. t
%
%   $ rules $:
%     Arguments of experiment (type - structure). Can set
%     {'parallel','threads','metrics', 'UnifiedCtrl', 'SpecificCtrl', 'SaveResults'， 'path_dir'}. 
%
%     `parallel`: "off"
%                 "on" 
%
%     `threads`: Maximum number of cores (default); 
%               Works only when `parallel` is "on"
%
%     `metrics`: The metrics used to compare the performance of each
%     method.
%
%     `UnifiedCtrl` and `SpecificCtrl`: the parameters used to control
%     methods. They are used as `method(data, {dataset_name, UnifiedCtrl},
%     SpecificCtrl{index_of_method})`.
%   
%     `SaveResults`: true
%                    false
%     `path_dir`: The folder where the file is stored.
%                 ../racetrack_default_dir (default)
%
% Output
% ------------
%   Return a cell $ report $ with size num_of_datasets x num_of_methods.
%   Return a structure $ IndexOfReport $ used to get the index of `report` by
%   names of datasets and methods. 
%
%-----------------------------------------------------------------------
%|  Author: LttGenius       Version: 1.0.7      Last update: 10.12.2023|
%-----------------------------------------------------------------------
%   For more information, see <a href=
%   "https://github.com/LttGenius/furnace">LttGenius/furnace</a>.

    %% import support functions
%     currentFolder = pwd;
    fullpath = mfilename('fullpath'); 
    [path,~]=fileparts(fullpath);
    support_path = [path, '/support'];
    addpath(genpath( support_path ));
    %% preprocessing
     methods_fieldnames = fieldnames(methods); % get names of methods.
     num_methods = length(methods_fieldnames); % get number of methods.

    %% param setting
    % check the parameter (rules)
    if ~exist('rules','var')
        rules = struct();
    end
    rules_list = isfield(rules, {'parallel','threads','metrics', 'UnifiedCtrl', 'SpecificCtrl', 'SaveResults', 'path_dir'});
     c = 1;
     for i = rules_list
         if i == 0
             switch(c)
                 case 1
                     parallel = "off";
                 case 2
                     parallel_threads = feature('numCores');
                 case 3
                     metrics = ["ACC"];
                 case 4
                     UnifiedCtrl = 0;
                 case 5
                     SpecificCtrl = zeros(num_methods, 1);
                 case 6
                     SaveResults = true;
                 case 7
                     path_dir = strcat(pwd, "/racetrack_default_dir");
             end
         else
            switch(c)
                 case 1
                     parallel = rules.parallel;
                 case 2
                     parallel_threads = rules.threads;
                case 3
                    metrics = rules.metrics;
                case 4
                     UnifiedCtrl = rules.UnifiedCtrl;
                 case 5
                     SpecificCtrl = rules.SpecificCtrl;
                case 6
                    SaveResults = logical(rules.SaveResults);
                case 7
                     path_dir = rules.path_dir;
            end
         end
         c = c + 1;
     end

     %% loda data
     % load data into cell
     num_datasets = size(data, 1);
     datasets = data(:, 2);
     datasets_names = data(:, 1);
     clear data c; 
    
     %% preprocessing
     report = cell(num_datasets, num_methods); % create cell to save.

     %% run
     if parallel == "off"
         % serial
         for k = 1:num_datasets 
             % load
             if isstring(datasets{k}) || ischar(datasets{k})
                 oriData = load(datasets{k});
             else
                 oriData = datasets{k};
             end
             res = struct();
             % run each method
             for i = 1:num_methods
                 res.(methods_fieldnames{i}) = methods.(methods_fieldnames{i})(oriData, {datasets_names{k}, UnifiedCtrl}, SpecificCtrl{i});
                 report{k, i} = res.(methods_fieldnames{i});
             end
             broadcast(res, datasets_names{k}, methods_fieldnames, metrics);
             if SaveResults % save
                save_data( datasets_names{k}, path_dir, res );
             end
         end

     elseif parallel == "on"
         % parallel
        try % check the parpool
            p=parpool(parallel_threads);
        catch  ME
            if ME.identifier == "parallel:convenience:ConnectionOpen"
               delete(gcp('nocreate'));
               p=parpool(parallel_threads);
            end
        end
        % linearization
        len_datasets_times_methods = num_methods * num_datasets;
        linearization_dict = cell(len_datasets_times_methods, 1);
        datasets_array = cell(num_datasets, 1); % for parallel computing
        rand_datasets = randperm(num_datasets);
        rand_methods = randperm(num_methods);
        for i = rand_datasets
            for j = rand_methods
                linearization_dict{ (i - 1) * num_methods + j } = {...
                    [i , j], ...
                    datasets_names{ i },...
                    methods_fieldnames{ j },...
                    methods.(methods_fieldnames{j})};
            end
            if isstring(datasets{i}) || ischar(datasets{i})
                 datasets_array{i} = load(datasets{i});
            else
                datasets_array{i} = datasets{i};
            end
        end
        clear datasets;
        datasets = datasets_array;
        clear datasets_array;

        % run 
        par_report = cell(len_datasets_times_methods, 1);
        parfor i = 1:len_datasets_times_methods
            [ index, dName, mName, method ]= linearization_dict{i}{:}; % get index, dName, mName, method of data and method
            res = method( datasets{ index(1) }, {dName, UnifiedCtrl}, SpecificCtrl{ index(2) } ); % get result
            if SaveResults % save
                save_data( dName, path_dir, res, mName );
            end
            parallel_broadcast(dName, mName, res, metrics); % log
            par_report{i} = {index, res};
        end
        % trans
        for i = 1:len_datasets_times_methods
            [index, res] = par_report{i}{:};
            report{index(1), index(2)} = res;
        end
         delete(p);
     end
     IndexOfReport.column = datasets_names;
     IndexOfReport.row = methods_fieldnames;
     % save
     save_data(strcat("RACETRACK_FINAL_", string(datetime('now', 'Format', 'dd_MM_y_H_mm_ss'))), path_dir, report, " ", IndexOfReport);
     rmpath(support_path)
  end