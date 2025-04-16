function newPop = OperatorDiff(SourcePop) % 算法复杂度O(n*m)
    lambda = HP_MOGA.lambda;
    n_single = HP_MOGA.scatter_degree;   % 每个投影点投射出的数量（常量）
    n_castPop = numel(SourcePop);             % 投影点数量
    % 初始化 newPop 数组
    totalNewPop = n_single * n_castPop;
    newPop = repmat(SourcePop(1), 1, totalNewPop);  % 复制模板，仅用于结构初始化

    % 主循环，遍历每个投影点
    for i = 1:n_castPop
        baseDec = SourcePop(i).dec;          % 当前投影点的决策变量
        tmpList = SourcePop(i).add(1:n_single);  % 获取批量的投影目标
        
        % 生成所有新个体
        for d = 1:n_single
            idx = (i-1) * n_single + d; % 计算新个体的索引
            % 直接更新新个体的决策变量
            newPop(idx).dec = tmpList(d) + (baseDec - tmpList(d)) * lambda;
        end
    end
end
