function broadcast(rep, indexOfData, methods_fieldnames, metrics)
    n = length(metrics);
    m = length(methods_fieldnames);
    fprintf(">>>>>>>>>>>>>>>>>>>>Index of dataset: %s<<<<<<<<<<<<<<<<<<<<\n", indexOfData)
    for i = 1:m
        fprintf("Method: %s, ", methods_fieldnames{i});
        for j = 1:n
            fprintf( ...
                strcat(metrics(j),': %.4f(%.4f)', "    "), ...
                rep.(methods_fieldnames{i}).(lower(metrics(j))));
        end
        fprintf("\n");
    end
end