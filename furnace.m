classdef furnace < handle
    %FURNACE An open-source tool for machine learning model. 
    %
    %Properties
    %- datasets
    %- models
    %- status
    %- InputParameters
    %- ReportTable
    %
    %Methods
    % +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    %- exa = furnace( datasets, models )
    % `datasets` and `models` are cells (n x 3). The first, second, and 
    %  third columns are tag, name, and data (path, numerical,
    %  function_hanle). E.g.
    % >> datasets
    %  3x3 cell
    %    {1, '3source', './datasets/3source.mat'}
    %    {2, 'BBCSport', { MultiviewData, gt }
    %    {2, 'ORL', X}
    % >> models
    %  2x3cell
    %    {1, 'PGP', @runPGP}
    %    {2, 'RWLTA', @runRWLTA}
    % Example
    % --------
    %  furn = furnace( datasets, models ) creats a example with datasets
    %  and models. 
    %
    %  furn = furnace() creats a example without data. 
    %
    % +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    %- [ Performance ] = exa.compara(...
    %                             'parallel', NUMBER_OF_CORES,...
    %                             'print', { ... },...
    %                             'uCtrl', uCtrl,...
    %                             'sCtrl', { ... },...
    %                             'savepath', '...' ,...
    %                             'waitbar' )
    % Before running `exa.compara`, you must execute exa = furnace(
    % datasets, models )`, `exa.compara` is dependent on `datasets' and
    % `models`. 
    % Example
    % --------
    %   [ Performance ] = exa.compara() performs comparative experiments 
    % on all datasets for all datasets in serial. 
    %
    %   [ Performance ] = exa.compara('parallel', NUMBER_OF_CORES) 
    % performs comparative experiments on all datasets for all datasets 
    % in parallel with `NUMBER_OF_CORES` thread. `NUMBER_OF_CORES` is 
    % optional, if `NUMBER_OF_CORES` is absent, the number of thread is the
    % maximum number of cores for the device. 
    %
    %   [ Performance ] = exa.compara( __, 'print', { ... } ) enables 
    % Print-to-Screen. The following `{ ... }` is a cell with each element
    % denotes the displayed fields.  
    % E.g. exa.compara( __, 'print', { "acc", "nmi" } )
    % >> Epoch: 1/200, Model: RWLTA, Dataset: 3source
    % >> acc: 98.21   0
    % >> nmi: 97.13   0
    %
    %   [ Performance ] = exa.compara( __, 'uCtrl', uCtrl ) transmits 
    % `uCtrl` into performmodel(models{i, 3}, data, uCtrl. sCtrl{i})
    %
    %   [ Performance ] = exa.compara( __, 'sCtrl', sCtrl ) transmits 
    % `sCtrl{i}` into performmodel(models{i, 3}, data, uCtrl. sCtrl{i})
    % 
    %   [ Performance ] = exa.compara( __, 'savepath', '...' ) can save 
    % the results of each step (certain model on certain dataset). The 
    % '...' is the path to save. 
    % 
    %   [ Performance ] = exa.compara( __, 'waitbar' ) enables the waitbar.
    % Return
    % --------
    % Performance is a table as follows. 
    % >>Performance
    %
    % Performance = 
    %
    % n x m table
    %
    %               dataset_name_1      dataset_name_2      ...     dataset_name_m
    %               --------------      --------------              --------------
    % Model_name_1    1x1 struct          1x1 struct                  1x1 struct
    % Model_name_2    1x1 struct          1x1 struct                  1x1 struct
    %      .
    %      .
    %      .
    % Model_name_n    1x1 struct          1x1 struct                  1x1 struct
    % +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    %
    %- [  Performance, ParameterSetIndex ] = exa.gridsearch(...
    %                              ParameterSet,...
    %                             'parallel', NUMBER_OF_CORES,...
    %                             'print', { ... },...
    %                             'uCtrl', uCtrl,...
    %                             'savepath', '...' ,...
    %                             'waitbar' )
    %
    % Before running `exa.gridsearch`, you must execute exa = furnace(
    % datasets, models )`, `exa.gridsearch` is dependent on `datasets' and
    % `models`. Note that, `models` can only be set as a 1x3 cell for one
    % model. `ParameterSet` is a structure with each field is a set of
    % parameters. E.g.
    % ParameterSet.lambda = { ... };
    % ParameterSet.gamma =  { ... };
    % ParameterSet.mu = { ... };
    %
    % Example
    % --------
    % [  Performance, ParameterSetIndex ] = exa.gridsearch( ParameterSet ) performs 
    % grid search on all datasets in serial. 
    %
    % [  Performance, ParameterSetIndex ] = exa.gridsearch( __, 'parallel', NUMBER_OF_CORES) 
    % performs grid search on all datasets for all datasets 
    % in parallel with `NUMBER_OF_CORES` thread. `NUMBER_OF_CORES` is 
    % optional, if `NUMBER_OF_CORES` is absent, the number of thread is the
    % maximum number of cores for the device. 
    %
    %   [ Performance, ParameterSetIndex ] = exa.gridsearch( __, 'print', { ... } ) enables 
    % Print-to-Screen. The following `{ ... }` is a cell with each element
    % denotes the displayed fields.  
    % E.g. exa.gridsearch( __, 'print', { "acc", "nmi" } )
    % >> Epoch: 1/200, Model: Model_g1, Dataset: 3source
    % >> acc: 98.21   0
    % >> nmi: 97.13   0
    %
    %   [ Performance, ParameterSetIndex ] = exa.gridsearch( __, 'uCtrl', uCtrl ) transmits 
    % `uCtrl` into performmodel(models{i, 3}, data, uCtrl. sCtrl{i})
    %
    %   [ Performance, ParameterSetIndex ] = exa.gridsearch( __, 'sCtrl', sCtrl ) transmits 
    % `sCtrl{i}` into performmodel(models{i, 3}, data, uCtrl. sCtrl{i})
    % 
    %   [ Performance, ParameterSetIndex ] = exa.gridsearch( __, 'savepath', '...' ) can save 
    % the results of each step (certain model on certain dataset). The 
    % '...' is the path to save. 
    % 
    %   [ Performance, ParameterSetIndex ] = exa.gridsearch( __, 'waitbar' ) enables the waitbar.
    %
    % Return
    % --------
    % Performance is a table as follows. 
    % >>Performance
    %
    % Performance = 
    %
    % n x m table
    %
    %               dataset_name_1      dataset_name_2      ...     dataset_name_m
    %               --------------      --------------              --------------
    % Model_g1        1x1 struct          1x1 struct                  1x1 struct
    % Model_g2        1x1 struct          1x1 struct                  1x1 struct
    %      .
    %      .
    %      .
    % Model_g2        1x1 struct          1x1 struct                  1x1 struct
    %
    % ParameterSetIndex is a cell as follows. 
    % >>ParameterSetIndex
    %
    % ParameterSetIndex = 
    %
    % n x 1 cell
    %
    % { index_1 }
    % { index_2 }
    %      .
    %      .
    %      .
    % { index_n }
    % Each element of ParameterSetIndex denotes the index of a combination
    % of parameters. 
    % +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    %
    %- [ filetext ] = exa.getlatextable(...
    %                              FormatFile,...
    %                              'format', '...'
    %                              'optimal', {"...", ...},...
    %                              'metrics', {"...", ...},...
    %                              'analysis', @function,...
    %                              'datanickname', {'...', '...'; ...},...
    %                              'modelnickname', {'...', '...'; ...},...
    %                              'source', '...',...
    %                              'savepath', '...')
    % 
    % Example
    % --------
    % [ filetext ] = exa.getlatextable(FormatFile, 'format', '...').
    % FormatFile is a text file that contains the LATEX Table Style.
    % 'format', '...' is the format of the output string, e.g.
    % '%.2f(%.2f)'. 
    %
    % [ filetext ] = exa.getlatextable( __, 'optimal', {"...", ...},...
    %                                       'metrics', {"...", ...},...
    %                                       'analysis', @function).
    % enables Sorting Analysis for descending ordering, the i-th element 
    % of {"...", ...} is i-th sorting style, e.g. {"$\mathcal{*}$",
    % "$\mathcal{*}$"}. 'metrics', {"...", ...} must be given, `{"...",
    % ...}` indicates the required sorting fields. 'analysis', @function is
    % the function_handle for analysis, if 'analysis' is not given, the
    % default is dataanalysis (See ./support/dataanalysis). 
    %
    % [ filetext ] = exa.getlatextable( __, 'datanickname', {'...', '...'; ...} ). 
    % will replace dataset names. E.g. {'Data1', '3source'; 'Data2',
    % 'ORL'}. 
    %
    % [ filetext ] = exa.getlatextable( __, 'modelnickname', {'...', '...'; ...} ). 
    % will replace dataset names. E.g. {'Model1', 'PGP'; 'Model2',
    % 'RWLTA'}. 
    %
    % [ filetext ] = exa.getlatextable( __, 'source', '...' ). 
    % will load data from '...'. If exa.compara or exa.gridsearch is not 
    % executed before, 'source' and '...' must be given. 
    %
    % [ filetext ] = exa.getlatextable( __, 'savepath', '...' ) can save 
    % the results in path '...'. 
    %
    % [ filetext ] = exa.getlatextable( __, 'savepath', '...' ) can save 
    % the results in path '...'. 
    %
    % Return
    % --------
    % filetext is a string as follows. 
    % \begin{table}[ht]
    %        \centering
    %        \begin{tabular}{*{3}{c}}
    %            \hline
    %            Models & 3source & BBCSport \\
    %            \hline
    %            RMSC & 0.62(0.02) & 0.82(0.05)\\
    %            tSVDMSC & $\mathbf{0.89(0.02)}$ & $\mathbf{0.90(0.02)}$\\
    %            \hline
    %        \end{tabular}
    %    \end{table}
    % +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    % 
    % Format of the model is as `model( data, uCtrl, sCtrl{i} )`. If
    % perform `furnace.gridsearch`, `sCtrl{i}` will be replaced by a
    % combination of parameters as `sCtrl{i} = struct('lambda', 1, 'gamma'
    % [1 1 2], 'mu', 0.5)`. `data' must contain all information of
    % datasets. 
    %-----------------------------------------------------------------------
    %|  Author: xinyu-pu                            Last update: 15.01.2024|
    %-----------------------------------------------------------------------
    %   For more information, see <a href=
    %   "https://github.com/xinyu-pu/furnace">xinyu-pu/furnace</a>.

    properties(Access = protected)
        PATH_NAME = '/support';
        ALL_MODE = {'parallel', 'print', 'uCtrl', 'sCtrl', 'SavePath', 'waitbar' };
        SAVE_MODEL_NAME = {'', 'GRIDSEARCH','COMPARA'};
        TEXT_PRE = 'furnace';
        TEXT_SPLIT = '.';
        ALL_TEX_MODE = {'optimal', 'datanickname', 'modelnickname',...
    'source', 'metrics', 'savepath', 'format', 'analysis'};
    end
    properties(Access = public)
        datasets;
        models;
        status;
        InputParameters = struct();
        ReportTable;
    end
    
%%%%%%%%%%%%%%%%%%%% Private methods %%%%%%%%%%%%%%%%%%%%
    methods(Access = private)
%% LOADMODELS  
        function loadmodels( obj, varargin )
            models = varargin{1};
            if ~isstring(models)
                obj.models = models;
            end
        end

 %% LOADDATASETS
        function loaddatasets( obj, varargin )
            datasets = varargin{1};
            if ~isstring(datasets)
                obj.datasets = datasets;
            else
                obj.datasets = autoload( datasets, '.mat' );
            end
            obj.datasets = loaddata( obj.datasets );
        end
    end

%%%%%%%%%%%%%%%%%%%% Public methods %%%%%%%%%%%%%%%%%%%%
    methods
        function obj = furnace( varargin )

            % Add path of support. 
            fullpath = mfilename('fullpath'); 
            [path,~]=fileparts(fullpath);
            support_path = [ path, obj.PATH_NAME ];
            addpath(genpath( support_path ));
            obj.status = 0;

            % LOAD 
            N = numel(varargin);
            if N >= 1
                obj.loaddatasets( varargin{1} );
            end
            if N >= 2
                obj.loadmodels( varargin{2} );
            end
        end

%% compara
        function [ result ] = compara( obj, varargin )
        % COMPARA description:
        % --------------------------
        % Conducting comparative experiments.
        %
        % Example:
        % --------------------------
        % datasets = {'BBC4', 'bbcsport', 'Caltech7', 'coil-20', 'leaves', 'ORL', 'UCI_3VIEW', 'yale'};
        % dataDir = 'Dataset';
        % for i = 1:length(datasets)
        %     dataname = datasets{i};
        %     dataset_file = fullfile(dataDir, strcat(dataname,'_Per0.mat'));
        %     data{i, 1} = i;
        %     data{i, 2} = dataname;
        %     data{i, 3} = dataset_file;
        % end
        % methods{1, 1} = 1;
        % methods{1, 2} = 'Model1';
        % methods{1, 3} = @MyModel;
        % methods{2, 1} = 2;
        % methods{2, 2} = 'Model2';
        % methods{2, 3} = @BaselineModel2;
        %  ......
        % 
        % methods{n, 1} = n;
        % methods{n, 2} = 'Modeln';
        % methods{n, 3} = @BaselineModeln;
        %
        % furn = furnace( datasets, methods )
        % uCtrl = ...;
        % sCtrl = ...;
        % path  = '...';
        % NUMBER_OF_CORES = ...;
        % Performance = furn.COMPARA( 'parallel', NUMBER_OF_CORES,...
        %               'print', {"acc", "nmi", "purity"},...
        %               'uCtrl', uCtrl,...
        %               'sCtrl', sCtrl,...
        %               'savepath', path,...
        %               'waitbar')
        % The above formality shows the all parameters of FURN.COMPARA. It
        % performs in parallel with NUMBER_OF_CORES cores (NUMBER_OF_CORES 
        % must be less than the maximum number of cores. ), 'print' enable 
        % output to the terminal where three fields {"acc", "nmi",
        % "purity"} and corresponding values are shown in MATLAB terminal. 
        % uCtrl denotes the unified control parameter, sCtrl 
        % (A n-dimensional cell) denotes the specific control parameter.
        % 'savepath' enables saving of single-step results as mat files in
        % PATH. 'waitbar' enables waitbar, note that 'print' is invalid if
        % 'waitbar' and 'parallel' are valid. 
        %
        % All parameters of FURN.COMPARA are optional. If uCtrl or sCtrl is
        % absent, FURN.COMPARA will set them to a empty array and a empty
        % cell (n x 1). 
        % Performance = furn.COMPARA( 'savepath', path,...
        %               'waitbar')
        % It saves the single-step results, shows the waitbar, and performs
        % in serial. 
        %
        % Performance = furn.COMPARA()
        % It runs in serial and no results are displayed and saved. 
        %
        % The returned Performance is a Table as follows. 
        % >>Performance
        %
        % Performance = 
        %
        % n x m table
        %
        %               dataset_name_1      dataset_name_2      ...     dataset_name_m
        %               --------------      --------------              --------------
        % Model_name_1    1x1 struct          1x1 struct                  1x1 struct
        % Model_name_2    1x1 struct          1x1 struct                  1x1 struct
        %      .
        %      .
        %      .
        % Model_name_n    1x1 struct          1x1 struct                  1x1 struct
        %
        % Each 1x1 struct is the returned value of a model. 
        % For interface and return value specification of each model see
        % README.md or annotations of FURNACE. 

            % Set status
            if obj.status == 0
                obj.status = 3;
            end

            [ InputsFlags, ParallelThread, metrics, uCtrl, sCtrl, SavePath, ShowBar ] = ParseInputs( varargin{:} );

            % Check inputs
            SaveFlag = InputsFlags(5);
            Print2Terminal = InputsFlags(2);
            if InputsFlags(1) && Print2Terminal && ShowBar
                warning('PRINT is invalid due to waitbar is turned on when executing programs in parallel!')
                Print2Terminal = false;
                InputsFlags(2) = false;
            end
            
            % Set BarInformation
            switch obj.status
                case 2
                    BarInformation = 'Performing girdsearch...';
                case 3
                    BarInformation = 'Performing compara...';
                otherwise
                    error('Unknown operational status!');
            end
            
            % Set sCtrl
            if ~InputsFlags(4)
                sCtrl = cell( size(obj.models, 1), 1 );
            end

            % Whether parallel. 
            if InputsFlags(1)
                try % check the parpool
                    p = parpool(ParallelThread);
                catch  ME
                    if ME.identifier == "parallel:convenience:ConnectionOpen"
                       delete(gcp('nocreate'));
                       p=parpool(ParallelThread);
                    end
                end

                % run
                result = performparallel( Print2Terminal, SaveFlag, SavePath, metrics,...
                    obj.models, obj.datasets, uCtrl, sCtrl, ShowBar, BarInformation );

                delete(p);
            else
                result = performserial( Print2Terminal, SaveFlag, SavePath, metrics,...
                    obj.models, obj.datasets, uCtrl, sCtrl, ShowBar, BarInformation );
            end

            % save final results
            if SaveFlag && obj.status == 3
                savedata( obj.status, SavePath, result, obj.SAVE_MODEL_NAME{obj.status}, obj.datasets, obj.models )
            end

            obj.InputParameters.InputsFlags = InputsFlags;
            obj.InputParameters.ParallelThread = ParallelThread;
            obj.InputParameters.print = metrics;
            obj.InputParameters.uCtrl = uCtrl;
            obj.InputParameters.sCtrl = sCtrl;
            obj.InputParameters.SavePath = SavePath;
            obj.InputParameters.ShowBar = ShowBar;
            obj.ReportTable = result;
        end

%% GRIDSEARCH
function [ result, ParameterSetIndex ] = gridsearch( obj, ParameterSet, varargin )
        % GRIDSEARCH description:
        % --------------------------
        % Finding the optimal parameters. 
        %
        % Example:
        % --------------------------
        % datasets = {'BBC4', 'bbcsport', 'Caltech7', 'coil-20', 'leaves', 'ORL', 'UCI_3VIEW', 'yale'};
        % dataDir = 'Dataset';
        % for i = 1:length(datasets)
        %     dataname = datasets{i};
        %     dataset_file = fullfile(dataDir, strcat(dataname,'_Per0.mat'));
        %     data{i, 1} = i;
        %     data{i, 2} = dataname;
        %     data{i, 3} = dataset_file;
        % end
        % methods{1, 1} = 1;
        % methods{1, 2} = 'MyModel';
        % methods{1, 3} = @MyModel;
        %
        % furn = furnace( datasets, method )
        % uCtrl = ...;
        % sCtrl = ...;
        % path  = '...';
        % NUMBER_OF_CORES = ...;
        %
        % ParameterSet.lambda = { ... };
        % ParameterSet.gamma =  { ... };
        % ParameterSet.mu = { ... };
        % [ Performance, ParameterSetIndex ] = furn.GRIDSEARCH(ParameterSet)
        %
        % Compared to COMPARA, GRIDSEARCH has only one more parameter
        % ParameterSet. ParameterSet is a structure where each fields
        % denotes a set of parameters used for tuning. E.g.,
        % ParameterSet.lambda is a cell where each element is a certain
        % parameter. 
        %
        % [ Performance, ParameterSetIndex ] = furn.GRIDSEARCH( ParameterSet,...
        %               'parallel', NUMBER_OF_CORES,...
        %               'print', {"acc", "nmi", "purity"},...
        %               'uCtrl', uCtrl,...
        %               'sCtrl', sCtrl,...
        %               'savepath', path,...
        %               'waitbar')
        %
        % It performs in parallel with NUMBER_OF_CORES cores (NUMBER_OF_CORES 
        % must be less than the maximum number of cores. ), 'print' enable 
        % output to the terminal where three fields {"acc", "nmi",
        % "purity"} and corresponding values are shown in MATLAB terminal. 
        % uCtrl denotes the unified control parameter, sCtrl 
        % (A n-dimensional cell) denotes the specific control parameter.
        % 'savepath' enables saving of single-step results as mat files in
        % PATH. 'waitbar' enables waitbar, note that 'print' is invalid if
        % 'waitbar' and 'parallel' are valid. 
        %
        % All parameters of FURN.GRIDSEARCH are optional. If uCtrl or sCtrl is
        % absent, FURN.GRIDSEARCH will set them to a empty array and a empty
        % cell (n x 1). 
        %
        % [ Performance, ParameterSetIndex ] = furn.GRIDSEARCH( 'savepath',
        %               path,...
        %               'waitbar')
        %
        % It saves the single-step results, shows the waitbar, and performs
        % in serial. 
        %
        % Performance = furn.GRIDSEARCH()
        % It runs in serial and no results are displayed and saved. 
        %
        % The returned Performance is a Table as follows. 
        % >>Performance
        %
        % Performance = 
        %
        % n x m table
        %
        %               dataset_name_1      dataset_name_2      ...     dataset_name_m
        %               --------------      --------------              --------------
        % MyModel_g1      1x1 struct          1x1 struct                  1x1 struct
        % MyModel_g2      1x1 struct          1x1 struct                  1x1 struct
        %      .
        %      .
        %      .
        % MyModel_gn      1x1 struct          1x1 struct                  1x1 struct
        %
        % The returned ParameterSetIndex is a cell as follows. 
        % >>ParameterSetIndex
        %
        % ParameterSetIndex = 
        %
        % n x 1 cell
        %
        % { index_1 }
        % { index_2 }
        %      .
        %      .
        %      .
        % { index_n }
        %
        % Each index_i is an index of the parameter set, e.g. index_i = [ a
        % b c ] corresponds to the ParameterSet.lambda(a), 
        % ParameterSet.gamma(b), and ParameterSet.mu(c)
        %
        % n is the maximum number of combinations, e.g. n =
        % numel(ParameterSet.lambda) * numel(ParameterSet.gamme) *
        % numel(ParameterSet.mu). 
        % Each 1x1 struct is the returned value of a model with 
        % combinations of parameters, e.g. a combination of lambda
        % (ParameterSet.lambda{i}), gamma (ParameterSet.lambda{j}), and mu 
        % (ParameterSet.lambda{k}). 
        % For interface and return value specification of model, please see
        % README.md or annotations of FURNACE. 

            % Set status
            obj.status = 2;

            field = fieldnames(ParameterSet);

            % Get number of search.
            max_num_run = 1;
            max_index = ones(1, length(field));
            for i = 1:length(field)
                max_index(i) = length(ParameterSet.(field{i}));  
                max_num_run = max_num_run * max_index(i);
            end

            % Grid initialization. 
            methods = cell( max_num_run, 3 );
            index = ones(1, length(field));
            ParameterSetIndex = cell(max_num_run, 1);
            for i = 1:max_num_run
                
                % Get index of parameters. 
                p = struct();
                for j = 1:length(field)
                    p.(field{j}) = ParameterSet.(field{j}){index(j)}; % value
                end
                ParameterSetIndex{i} = index;
                sC{i} = p;

                % Get method with given parameters. 
                methods{i, 1} = obj.models{1, 1};  
                methods{i, 2} = strcat(obj.models{1, 2}, '_g', num2str(i));
                methods{i, 3} = obj.models{1, 3}; 

                % Increase index
                index = indexincrease(index, max_index);
            end
            obj.models = methods;

            % grid search
            result = obj.compara( varargin{:}, 'sCtrl', sC );

            if obj.InputParameters.InputsFlags(5) && obj.status == 2 
                savedata( obj.status, obj.InputParameters.SavePath, result, obj.SAVE_MODEL_NAME{obj.status}, obj.datasets, obj.models, sC );
            end
        end

%% GETLATEXTABLE
        % Transform RESULT TABLE into LATEX TABLE
        function [ filetext ] = getlatextable(obj, FormatFile, varargin)
        % GETLATEXTABLE description:
        % --------------------------
        % Transform Performance to LATEXT TABLE. 
        % The format of Performance is as follows.
        % >>Performance
        %
        % Performance = 
        %
        % n x m table
        %
        %               dataset_name_1      dataset_name_2      ...     dataset_name_m
        %               --------------      --------------              --------------
        % Model_name_1    1x1 struct          1x1 struct                  1x1 struct
        % Model_name_2    1x1 struct          1x1 struct                  1x1 struct
        %      .
        %      .
        %      .
        % Model_name_n    1x1 struct          1x1 struct                  1x1 struct
        %
        % Example:
        % --------------------------
        % ALL_TEX_MODE = {'optimal', 'datanickname', 'modelnickname',...
        %'source', 'metrics', 'savepath', 'format', 'analysis'};
        % furn = furnace()
        % FormatFile = '...';
        % source = 'xxx.mat';
        % savepath = '...';
        %
        % [ TexTable ] = furn.GETLATEXTABLE( FormatFile,...
        %                'optimal', {'$\mathbf{*}$', '{*}', '*'},...
        %                'metrics', {"acc", "nmi", "purity"},...
        %                'analysis', @myAnalysis,...
        %                'datanickname', {'Data1', '3source'; 'Data2', 'BBCSport'},...
        %                'modelnickname', {'Model1', 'RMSC'; 'Model2', 'tSVDMSC'},...
        %                'source', source,...
        %                'savepath', savepath,...
        %                'format', '%.2f(%.2f)')
        %
        % The description of the parameters is as follows. 
        % FormatFile is a path which gives the format of latex table, e.g.
        %
        % >>fileread(FormatFile.txt)
        %
        %    ans =
        %
        %'\begin{table}[ht]
        %     \centering
        %     \begin{tabular}{*{3}{c}}
        %         \hline
        %         Models & Data1 & Data2 \\
        %         \hline
        %         Model1 & furnace.Model1.Data1.acc & furnace.Model1.Data2.acc\\
        %         Model2 & furnace.Model2.Data1.acc & furnace.Model2.Data2.acc\\
        %         \hline
        %     \end{tabular}
        % \end{table}',
        %
        % where 'furnace', 'Model1', 'Data1', and 'acc' are prefix tag of
        % furnace, tag of model, tag of dataset, and tag of field,
        % repectively. The prefix tag 'furnace' indicates that
        % 'furnace.xxx.xxx.xxx' is a target substring. 
        % The generalized form is
        % 'furnace.model_name.dataset_name.field_name'. 'model_name' and
        % 'dataset_name' are correspond to the RowNames and VariableNames
        % of Performance. 'field_name' is a field of certarin element in
        % Performance. 
        %
        % 'optimal' enables data analytics, the following cell 
        % {'$\mathbf{*}$', '{*}', '*'} denotes the specific formats of 
        % first, second, and third values in descending order. 
        % Real value will be replaced '*'. 
        %
        % 'metrics' and the following {"acc", "nmi", "purity"} denote
        % "acc", "nmi", and "purity" is the field required to analyze. 
        %
        % 'analysis' and given @myAnalysis are the function used to analyze
        % Performance. The default 'analysis' function is dataanalysis in
        % path ./support. 
        %
        % 'datanickname' and 'modelnickname' are m x 2 cell and n x 2 cell
        % respectively. m(n) represents the number of datasets(models)
        % which need to change names. E.g. 'datanickname', 
        % {'Data1', '3source'; 
        %  'Data2', 'BBCSport'}
        % The first column is the names in Performance, the second column
        % is the nicknames. Same with 'modelnickname'. 
        %
        % 'source', source is the path to the MAT file containing
        % Performance. The structure of file is 
        %
        %>> load(source)
        %   data  n x m table
        %
        % The file must contain a variab a variable with the name 'data'.
        % This variab is the Performance used in example. If source is
        % not given, GETLATEXTABLE looks to find out if it was executed
        % COMPARA or GRIDSEARCH, if not, the program will be interrupted. 
        %
        % 'savepath', savepath is the path to save final results.
        %
        % 'format', '%.2f(%.2f)' denotes the form of replacement, e.g. 
        % '%.2f(%.2f)' for 'furnace.model_name.dataset_name.field_name'
        % [0.5 0.4]. '%.2f(%.2f)' can be replaced by any other formatted 
        % strings. 
        %
        % For GETLATEXTABLE, FormatFile and 'format' must be given. 
        % [ TexTable ] = furn.GETLATEXTABLE( FormatFile,...
        %                'format', '%.2f(%.2f)')
        %
        % The returned TexTable is a string as follows. 
        %
        % \begin{table}[ht]
        %        \centering
        %        \begin{tabular}{*{3}{c}}
        %            \hline
        %            Models & 3source & BBCSport \\
        %            \hline
        %            RMSC & 0.62(0.02) & 0.82(0.05)\\
        %            tSVDMSC & $\mathbf{0.89(0.02)}$ & $\mathbf{0.90(0.02)}$\\
        %            \hline
        %        \end{tabular}
        %    \end{table}
        %
        % For interface and return value specification of model, please see
        % README.md or annotations of FURNACE. 

            % Check parameters. 
            narginchk(2, inf);
            validateattributes(FormatFile, {'char', 'string'}, {}, mfilename, 'FormatFile', 1); 
            [ InputsFlags, marks, DataNickname,...
              ModelNickname, source, keys,...
              path, StringFormat, analysisfunction ] = ParseInputs2( varargin{:} );
            if InputsFlags(1) && ~InputsFlags(5)
                error('optimal is given without metrics')
            end
            if obj.status == 0 && ~InputsFlags(4)
                error('Please perform COMPARA or GRIDSEARCH first, or give source!')
            end
            
            % Defination any2str. 
            any2str = @(x) sprintf(StringFormat, x);

            % Read file
            filetext = fileread(FormatFile);
            if InputsFlags(4)
                UsedData = load(source).data;
            else
                UsedData = obj.ReportTable;
            end
            
            % Data analysis
            if InputsFlags(1)
                OrderMap = analysisfunction( UsedData, keys );
            end

            % Set marks. 
            [NModels, NDatasets] = size(UsedData);
            for i = 1: NModels - numel(marks)
                marks{end+1} = '{*}';
            end

            % Transform
            for iData = 1:NDatasets
                for iModel = 1:NModels

                    % R is the results of a certain method with a specific dataset. 
                    r = UsedData{iModel, iData};
                    fNames = fieldnames(r); % Get field names of structure. 
                    nFilednames = numel(fNames);

                    % Iterate over fields to search the corresponding
                    % fields in FILETEXT. 
                    for iFilename = 1:nFilednames
                        fname = fNames{iFilename};

                        % Target field in FILETEXT, e.g.
                        % furnace.method_name.data_name.acc
                        tar = strcat( obj.TEXT_PRE, obj.TEXT_SPLIT,...
                                      UsedData.Row{iModel}, obj.TEXT_SPLIT,...
                                      UsedData.Properties.VariableNames{iData}, obj.TEXT_SPLIT,...
                                      fname );

                        % Whether TAR appears in FILETEXT. 
                        if contains(filetext, tar)
                            
                            % Replace furnace.model_name.data_name.key with real value. 
                            if InputsFlags(1)
                                [ l, p ] = ismember( fname, keys );
                                if l 

                                    % Specified format. 
                                    MarksIndex = OrderMap(iModel, iData, p);
                                    ReplaceFormat = marks{MarksIndex};
                                end
                            else

                                % Default format. 
                                ReplaceFormat = '{*}';
                            end
                            ReplaceFormat = strrep( ReplaceFormat, ...
                                    '*', any2str(r.(fname)) );

                            % Replace FILETEXT. 
                            filetext = strrep( filetext, tar, ReplaceFormat );
    
                        end
                    end
                end
            end
            
            % Replace names of datasets with nick names. 
            if InputsFlags(2)
                tar = DataNickname(:, 1);
                nickname = DataNickname(:, 2);
                nTar = numel(tar);
                for i = 1:nTar
                    filetext = strrep( filetext, tar{i}, nickname{i} );
                end
            end
            
            % Replace names of methods with nick names. 
            if InputsFlags(3)
                tar = ModelNickname(:, 1);
                nickname = ModelNickname(:, 2);
                nTar = numel(tar);
                for i = 1:nTar
                    filetext = strrep( filetext, tar{i}, nickname{i} );
                end
            end

            % Save.
            fid = fopen(path, 'w');
            fwrite(fid, filetext);
            fclose(fid);
        end
    end
end


%% The following are support functions for FURNACE, 
% including ParseInputs, indexincrease, autoload, ParseInputs2

%% Parse inputs of compara. 
function [ InputsFlags,...
           ParallelThread,...
           print,...
           uCtrl,...
           sCtrl,...
           SavePath,...
           ShowBar ] = ParseInputs( varargin )
    % PARSEINPUTS is used to parse the inputs from compara. 
    % InputsFlags is a 6x1 logical vector, where each element denotes
    % whether corresponding parameter is imported. 
    % ParallelThread denotes the number of threads for performance in
    % parallel. 
    % print denotes the displayed fields of each result. 
    % uCtrl denotes the unified control parameter. 
    % sCtrl is a n x 1 or 1 x n cell, where n is the number of models.
    % sCtrl{i} denotes the i-th specific control parameter of i-th model. 
    % SavePath denotes the path for storing single-step results. 
    % ShowBar denotes whether waitbar is valid. Note that print is invalid
    % if ShowBar is valid and running in parallel. 

    % Initialization
    nVar = numel(varargin);
    cnt = 1;
    ParallelThread = 0;
    print = [];
    uCtrl = [];
    sCtrl = {};
    SavePath = [];
    ShowBar = false;
    InputsFlags = false(6, 1);

   % Preprocess the operation mode string to detect abbreviations. 
   allString = {'parallel', 'print', 'uCtrl', 'sCtrl', 'SavePath', 'waitbar' };
   
   % Parse inputs.
   while cnt <= nVar
       v = varargin{ cnt };
       idx = find(strcmp(allString, v));
       cnt = cnt + 1;
       if ~isempty(idx)
           switch idx
                
               % For parallel. 
               case 1
                   if isnumeric( varargin{ cnt } )
    
                       % Given number of cores fo parallel.  
                       ParallelThread = varargin{ cnt };
                       cnt = cnt + 1;
                   else
    
                       % Defualt number of cores for parallel. 
                       ParallelThread = feature('numCores');
                   end
                   if ParallelThread > 0
                       InputsFlags(idx) = 1;
                   end
    
               % For PRINT
               case 2
    
                   % Check type of PRINT
                   validateattributes(varargin{ cnt }, {'cell', 'string'}, {}, mfilename, 'print', cnt);
                   print = varargin{ cnt };
                   cnt = cnt + 1;
                   InputsFlags(idx) = 1;
    
               % For uCtrl
               case 3
                   uCtrl = varargin{ cnt };
                   cnt = cnt + 1;
                   InputsFlags(idx) = 1;
    
               % For sCtrl
               case 4
                    
                   % Check type of sCtrl
                   validateattributes(varargin{ cnt }, {'cell'}, {}, mfilename, 'sCtrl', cnt);
                   sCtrl = varargin{ cnt };
                   cnt = cnt + 1;
                   InputsFlags(idx) = 1;
    
               % For SavePath
               case 5
                   validateattributes(varargin{ cnt }, {'string', 'char'}, {}, mfilename, 'sCtrl', cnt);
                   SavePath = varargin{ cnt };
                   cnt = cnt + 1;
                   InputsFlags(idx) = 1;
    
                % For waitbar
               case 6
                   ShowBar = true;
                   InputsFlags(idx) = 1;
    
               otherwise
                   error('The %d-th paramter is unknow!', cnt - 1);
           end
       else
           error('The %d-th paramter is unknow!', cnt - 1)
       end
   end
end

%% For gird search
function [ index, isOverflow ] = indexincrease(old_index, max_index)
% INDEXINCREASE is utilized to implement addition of arrays. 
% E.g., old_index = [ 1 1 1 ], max_index = [ 3 4 5 ],
% index = indexincrease(old_index, max_index), the value of index is [ 1 1
% 2]. If old_index = [ 1 1 5 ], the value of index is [ 1 2 1 ]. If
% old_index = [ 1 4 5 ], index is equal to [ 2 1 1 ]. If old_index = [ 3 4
% 5 ], index = [ 4 1 1 ], and isOverflow = true. 
    isOverflow = false;
    index = old_index;
    index(end) = index(end) + 1;
    if index(end) > max_index(end)
        flag = 1;
    else
        flag = 0;
    end
    cnt = length(index);
    while flag
        index(cnt) = 1;
        cnt = cnt - 1;
        index(cnt) = index(cnt) + 1;
        if (index(cnt) > max_index(cnt)) && (cnt > 1)
            flag = 1;
        else
            flag = 0;
        end
    end

    % Overflow
    if (index(cnt) > max_index(cnt)) && (cnt == 1)
        isOverflow = true;
    end
end

%% Load data from a dir. 
function [ datasets_flag_name_path ] = autoload( path, FileType )

allFiles = dir(fullfile(path, FileType));
N = numel(allFiles);
datasets_flag_name_path = cell(N, 3);
for i = 1:N
    datasets_flag_name_path{i, 1} = i;
    datasets_flag_name_path{i, 2} = strrep(allFiles(i).name,FileType,'');
    datasets_flag_name_path{i, 3} = allFiles(i).folder;
end
end

%% Parse inputs of GETLATEXTABLE. 
function [ InputsFlags,...
           marks,...
           DataNickname,...
           ModelNickname,...
           source,...
           Metrics,...
           path,...
           StringFormat,...
           analysisfunction ] = ParseInputs2( varargin )

% Initialization
nVar = numel(varargin);
InputsFlags = false(8, 1);
marks = {};
DataNickname = {};
ModelNickname = {};
source = '';
Metrics = {};
path = '';
StringFormat = '';
analysisfunction = @dataanalysis;

% Preprocess the operation mode string to detect abbreviations. 
allString = {'optimal', 'datanickname', 'modelnickname',...
    'source', 'metrics', 'savepath', 'format', 'analysis'};

% Parse inputs.
cnt = 1;
while cnt <= nVar
    v = varargin{ cnt };
    idx = find(strcmp(allString, v));
    cnt = cnt + 1;
    if ~isempty(idx)
        switch idx

            % marks
            case 1
                validateattributes(varargin{ cnt }, {'cell'}, {}, mfilename, 'optimal', cnt);
                marks = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;
            
            % DataNickname
            case 2
                validateattributes(varargin{ cnt }, {'cell'}, {}, mfilename, 'DataNickname', cnt);
                DataNickname = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;
            
            % ModelNickname
            case 3
                validateattributes(varargin{ cnt }, {'cell'}, {}, mfilename, 'ModelNickname', cnt);
                ModelNickname = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;

            % source
            case 4
                validateattributes(varargin{ cnt }, {'string', 'char'}, {}, mfilename, 'source', cnt);
                source = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;
            
            % metrics
            case 5
                validateattributes(varargin{ cnt }, {'cell'}, {}, mfilename, 'Metrics', cnt);
                Metrics = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;
             
            % savepath
            case 6
                validateattributes(varargin{ cnt }, {'string', 'char'}, {}, mfilename, 'savepath', cnt);
                path = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;

            % format
            case 7
                validateattributes(varargin{ cnt }, {'string', 'char'}, {}, mfilename, 'format', cnt);
                StringFormat = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;

            % analysis
            case 8
                validateattributes(varargin{ cnt }, {'function_handle'}, {}, mfilename, 'analysis', cnt);
                analysisfunction = varargin{ cnt };
                cnt = cnt + 1;
                InputsFlags(idx) = true;

            otherwise
                 error('The %d-th paramter is unknow!', cnt - 1);
        end
    else
        error('The %d-th paramter is unknow!', cnt - 1);
    end

end

end