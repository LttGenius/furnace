function print2terminal( t, T, varargin )

metrics = varargin{1}; 
num_metrics = numel(metrics);
model_name = varargin{2};
data_name = varargin{3};
performance = varargin{4};
isParallel = logical(varargin{5});

% Default value of metrics. 
if isempty(metrics)
    metrics = fieldnames(performance);
end

% Print 
if isParallel
    fprintf("Parallel>>>")
end
fprintf("Epoch: %d/%d, Model: %s, Dataset: %s\n", t, T, model_name, data_name);
for i = 1:num_metrics
    fprintf("%s: ", metrics{i});
    display(performance.(metrics{i}));
    fprintf('%c', 8);
end
end
