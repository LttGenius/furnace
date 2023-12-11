function show2screen(iter, max_iter, metrics, metrics_value, index, dis)
% display the information
    if ~exist("dis", "var")
        dis = 1;
    end
    if dis == 1
        fprintf("Times: %d/%d  "+metrics+": %3.4f with parameters index (", iter, max_iter, metrics_value);
        fprintf("%d ", index);
        fprintf(")\n");
    elseif dis == 2
        global backNum;
        if iter == 1
            backNum = 0;
            backNum = backNum + fprintf("Times: %d/%d  "+metrics+": %3.4f with parameters index (", iter, max_iter, metrics_value);
            backNum = backNum + fprintf("%d ", index);
            backNum = backNum + fprintf(")\n");
        else
            fprintf(repmat('\b',1,backNum));
            backNum = 0;
            backNum = backNum + fprintf("Times: %d/%d  "+metrics+": %3.4f with parameters index (", iter, max_iter, metrics_value);
            backNum = backNum + fprintf("%d ", index);
            backNum = backNum + fprintf(")\n");
        end
    end
end

