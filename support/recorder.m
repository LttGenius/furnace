classdef recorder < handle
    %RECORDER Used to support recording of information
    % Method:
    %------------
    % obj = recorder(parameters_set, path, save_gap)
    % obj = Record(obj, value, index)
    % obj = suspend(obj, index)
    % save(obj)
    
    properties
        data; % recording
        parameters_index; % index of tunning parameters
        parameters_set; % range of tunning parameters
        path; % path to file storage
        cnt; % count
        save_gap; % gap
        best;
    end
    
    methods
        function obj = recorder(parameters_set, path, save_gap)
            obj.parameters_set = parameters_set;
            obj.data = cell(1,1);
            obj.data{1} = "Record of tunning";
            obj.path = path;
            obj.cnt = 0;
            obj.best = {};
            if ~exist("save_gap", "var")
                save_gap = 5;
            end
            obj.save_gap = save_gap;
        end
        
        function Record(obj, value, index)
            % recording information
            p = obj.parallel_computing_find_para(index);
            obj.data{end+1} = {p, value};
            if obj.cnt == 0
                obj.suspend(index);
            end
            obj.cnt = mod(obj.cnt + 1, obj.save_gap);
        end

        function suspend(obj, index)
            % save
            obj.parameters_index = index;
            obj.save();
        end

        function save(obj)
            parameters_set = obj.parameters_set;
            parameters_index = obj.parameters_index;
            data = obj.data;
            best = obj.best;
            save(obj.path, "parameters_set", "parameters_index", "data", "best");
        end

        function recordBest(obj, best_value, max_index)
            obj.best =  best_value;
            obj.suspend(max_index);
        end

        function p = parallel_computing_find_para(obj, index)
            p_set = obj.parameters_set;
            field = fieldnames(p_set);
            c = 1;
            p = struct();
            for i = 1:length(field)
                p.(field{i}) = p_set.(field{i}){index(c)}; % value
                c = c + 1;
            end
        end
    end
end

