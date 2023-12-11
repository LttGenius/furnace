function parallel_broadcast(data_name, method_name, result, metrics)
    fprintf("PARALLEL>>>>Dataset: %s, Method: %s", data_name, method_name);
    len_metrics = numel(metrics);
    for i = 1:len_metrics
        str_metric = lower(metrics(i));
        fprintf(", %s: %.4f(%.4f)", str_metric, result.(str_metric));
    end
    fprintf("\n");
end