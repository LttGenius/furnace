function [ best_param ] = alchemy( run_model, x, y, p_set, tunne_arg )
% Functional description:
% ------------------------
% Finding the optimal parameters 
%
% Formality:
% ------------------------
% best_param = ALCHEMY( run_model, x, y, p_set, tunne_arg )
%
% Parameters
% ------------
%   $ run_model $:
%     It must be of the form: `res = run_model(x, y, p)` where `x`, `y`, `p` denote data,
%     groundthruth and parameters respectively. The types of `x`, `y` and
%     `p` are cell (1 x V or V x 1), array (double) and structure,
%     respectively. 
%     The returned value (res) must be a structure with keywords of metrics ( res.(tunne_arg.metrics) = [average, standard deviation] ). E.g., res.ACC = [0.99, 0.01],
%     res.NMI = [0.99, 0.01]. 
%
%   $ tunne_arg $:
%     Arguments of ALCHEMY. Can set {'logging','show',
%     'threshold','path','metrics','bar','index','parallel','parallel_thread','save_gap'}.
%
%     `logging`: Controlling the logging of information, can be set as
%                "shutdown" (Shutdown logging); 
%                "every" (Logging everyone); 
%                "threshold" (Items which exceed the threshold are recorded); 
%                "best" (Recording when the best result is updated). 
%                The default value of 'logging' is "every". 
%     It is worth noting that if `tunne_arg.logging` is not equal to `shutdown` and `parallel` is `on`, whole information in the calculation will be recorded, causing additional memory overheads.
%     
%
%     `show`: Controlling the display of information, can be set as
%             "shutdown" (Shutdown on-screen display); 
%             "every" (Showing everyone in screen); 
%             "threshold" (Items that exceed the threshold are shown); 
%             "best" (Show when the best result is updated). 
%             The default value of 'show' is "every". 
%      It is worth noting that `tunne_arg.show` can only be selected as `shutdown`, "every" or "threshold" when `parallel` is `on`.
%
%     `threshold`: It works when `logging` or `show` is set to "threshold". | 0 (default) 
%
%     `path`: The path of logging file. Notice that it must be a mat file. | './tunneLOG.mat' (default) 
%
%     `metrics`: Metrics used for alignment {"ACC" "NMI" "Purity"  "P" "R"
%     "F" "RI" "AR", ....}. | "ACC" (default)
%   
%      `bar`: Display progress bar | "on" (default) "off"
%       Invalid when `parallel` is `on`. 
%
%      `index`: Specifying the initial parameter with index.
%
%      `parallel`: "off" (default)
%                  "on" (Enabling Parallel Computing)
%
%      `parallel_thread`: Maximum number of cores (default)
%               
%      `save_gap`: The gap of saving results of searching. The default
%      value is 1 (Every record is saved). Set to a larger value to reduce
%      consumption of IO. It is worth noting that is is invalid when
%      `parallel` is `on`. 
%
% Output
% ------------
%   Return a struct $ best_param $
%   $ best_param.p $:
%     Optimal parameter values
%
%   $ best_param.avg_measurement $:
%      Average value with best parameters
%
%   $ best_param.std_measurement $:
%     Standard deviation with best parameters
%
%-----------------------------------------------------------------------
%|  Author: LttGenius       Version: 1.0.7      Last update: 10.12.2023|
%-----------------------------------------------------------------------
%   For more information, see <a href=
%   "https://github.com/LttGenius/furnace">LttGenius/furnace</a>.


    %% param setting
    % check the parameter (tunne_arg)
    if ~exist('tunne_arg','var')
        tunne_arg = struct();
    end
    tunne_arg_list = isfield(tunne_arg, ...
        {'logging','show', 'threshold','path','metrics','bar','index','parallel','parallel_thread','save_gap'} ...
        );
     c = 1;
     for i = tunne_arg_list
         if i == 0
             switch(c)
                 case 1
                     logging = "every";
                 case 2
                     show = "every";
                 case 3
                     threshold = 0;
                 case 4
                     path = './tunneLOG.mat';
                 case 5
                     metrics = 'acc';
                 case 6
                     bar = "on";
                 case 8
                    parallel = "off";
                 case 9
                    parallel_thread = feature('numCores');
                 case 10
                    save_gap = 1;
             end
         else
            switch(c)
                 case 1
                     logging = tunne_arg.logging;
                 case 2
                     show = tunne_arg.show;
                 case 3
                     threshold = tunne_arg.threshold;
                 case 4
                     path = tunne_arg.path;
                 case 5
                     metrics = tunne_arg.metrics;
                case 6
                    bar = tunne_arg.bar;
                case 7
                    index = tunne_arg.index;
                case 8
                    parallel = tunne_arg.parallel;
                case 9
                    parallel_thread = tunne_arg.parallel_thread;
                case 10
                    save_gap = tunne_arg.save_gap;
             end
         end
         c = c + 1;
     end
    if logging ~= "shutdown"
        myRecord = recorder(p_set, path, save_gap);
    end
    if bar == "on" && parallel == "off"
        display_bar = waitbar(0,'Initialization...');    % waitbar
    elseif bar == "on"
        bar = "off";
    end
    %% Initialization
    % Computing the maximum number of runs
    field = fieldnames(p_set);
    c = 1;
    max_num_run = 1;
    max_index = ones(1, length(field));
    for i = 1:length(field)
        max_index(c) = length(p_set.(field{i}));  % get maximum index
        max_num_run = max_num_run * max_index(c);
        c = c + 1;
    end
    % Set the `index`
    if ~exist("index","var") % if continue 
        index = ones(1, length(field));
        times = 1;
    else
        tmp = fliplr(cumprod(fliplr(max_index)));
        tmp = [tmp(2:end), 1];
        times = tmp * (index - 1)' + 1;
        clear tmp;
    end
    % other parameter
    best_mean = -100;
    best_std = 100;
    best_param = struct();
    best_param.p = 0;
    %% run
    tic;
    if parallel == "off"
        while times <= max_num_run
            
            % set parameters of run_model
            c = 1;
            p = struct();
            for i = 1:length(field)
                p.(field{i}) = p_set.(field{i}){index(c)}; % value
                c = c + 1;
            end
            
            % run
            res = run_model(x, y, p);
            change_best = 0;
            if res.(metrics)(1) >= best_mean
                if res.(metrics)(1) == best_mean && res.(metrics)(2) < best_std
                     best_std = res.(metrics)(2);
                     best_param.p = p;
                else 
                     best_mean = res.(metrics)(1);
                     best_std = res.(metrics)(2);
                     best_param.p = p;
                end
                change_best = 1;
            end
    
            % display bar
            cost_time = toc;
            if bar == "on"
                waitbar_str=['In progress...',num2str(100*times/max_num_run),'% (Cost: ',num2str(cost_time),'s)']; 
                waitbar(times/max_num_run,display_bar,waitbar_str)  
            end

            % log
            switch(logging)
                case "every"
                    myRecord.Record(res, index);
                case "threshold"
                    if res.(metrics)(1) >= threshold
                        myRecord.Record(res, index);
                    end
                case "best"
                    if change_best
                        myRecord.Record(res, index);
                    end
            end
    
            % display on screen
            switch(show)
                case "every"
                    show2screen(times, max_num_run, metrics, res.(metrics)(1), index, 1)
                case "threshold"
                    if res.(metrics)(1) >= threshold
                        show2screen(times, max_num_run, metrics, res.(metrics)(1), index, 1)
                    end
                case "best"
                    if change_best
                        show2screen(times, max_num_run, metrics, best_mean, index, 1)
                    end
            end
     
            % index_p change
            index(end) = index(end) + 1;
            promotion = find(max_index < index);
            if times ~= max_num_run 
                while promotion 
                    index(promotion) = 1;
                    index(promotion - 1) = index(promotion - 1) + 1;
                    promotion = find(max_index < index);
                end
            end
            times = times + 1;
        end
    else
        % update on 11.16 2023
        endi = max_num_run - times + 1;
        index_map = cell(1,endi);
        index_map{1} = index;
        for i = times+1:max_num_run
            % get index map
            index_map{i - times + 1} = add_index(index_map{i - times}, max_index);
        end
        try 
            % open parapllel
            open_core=parpool(parallel_thread);
        catch  ME
            if ME.identifier == "parallel:convenience:ConnectionOpen"
                 delete(gcp('nocreate'));
                 open_core=parpool(parallel_thread);
            end
        end
        mean_map = zeros(endi,1);
        std_map = zeros(endi,1);
        res_map = cell(endi,i);
        parfor i = 1:endi
            p = parallel_computing_find_para(p_set, field,  index_map{i});
            res = run_model(x, y, p);
            mean_map(i) = res.(metrics)(1);
            std_map(i) = res.(metrics)(2);
            if logging ~= "shutdown"
                res_map{i} = res;
            end
            if show ~= "shutdown" && mean_map(i) > threshold
               show2screen(i+times-1, max_num_run, metrics, mean_map(i), index_map{i}, 1);
            end
        end
        delete(open_core);
        % computing results
        [~, beat_mean_map_index] = max(mean_map);
        [~, beat_std_map_index] = min(std_map(beat_mean_map_index));
        best_index = beat_mean_map_index(beat_std_map_index);
        if length(best_index) > 1
            best_index = best_index(1);
        end
        best_mean = mean_map(best_index);
        best_std = std_map(best_index);
        best_param.p = parallel_computing_find_para(p_set, field, index_map{best_index});
        % logging
        if logging ~= "shutdown"
            if logging == "every"
                for i = 1:endi
                    myRecord.Record(res_map{i}, index_map{i});
                end
            elseif logging == "threshold"
                for i = 1:endi
                    if res_map{i}.(metrics)(1) >= threshold
                        myRecord.Record(res_map{i}, index_map{i});
                    end
                end
            elseif logging == "best"
                tmp_best_mean = -inf;
                tmp_best_std = inf;
                for i = 1:endi
                    if res_map{i}.(metrics)(1) > tmp_best_mean
                        myRecord.Record(res_map{i}, index_map{i});
                        tmp_best_mean = res_map{i}.(metrics)(1);
                        tmp_best_std = res_map{i}.(metrics)(2);
                    elseif res_map{i}.(metrics)(1) == tmp_best_mean && res_map{i}.(metrics)(2) < tmp_best_std
                        myRecord.Record(res_map{i}, index_map{i});
                        tmp_best_std = res_map{i}.(metrics)(2);
                    end
                end
            end
        end
    end
    % show results
    cost_time = toc;
    if show ~= "shutdown"
        fprintf( ...
            [ ...
            repmat('-',1,100),'\n', ...
            '| Total time consumption: %.2f\n', ...
            '| The best performance: %.4f\n',...
            '| The optimal parameters: ',...
            ], ...
            cost_time, ...
            best_mean);
        disp(best_param.p);
        fprintf(['\n',repmat('-',1,100),'\n']);
    end
    % return results
    best_param.avg_measurement = best_mean;
    best_param.std_measurement = best_std;
    % logging results when parallel != "off"
    if logging ~= "shutdown"
        myRecord.recordBest(best_param, max_index);
    end
    if bar == "on"
        close(display_bar);
    end
end

function p = parallel_computing_find_para(p_set, field, index)
    c = 1;
    p = struct();
    for i = 1:length(field)
        p.(field{i}) = p_set.(field{i}){index(c)}; % value
        c = c + 1;
    end
end

function index = add_index(old_index, max_index)
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
end