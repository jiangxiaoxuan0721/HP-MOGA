classdef HP_MOGA < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none>
properties(Access = public,Constant)
     scatter_degree = 3;    % 每个个体能投射出的个体数，在个体空间维度大的情况下，值越大PF越准确，性能开销越大
     lambda = 0.0625;    % 模拟波长因子
end

methods
    function main(Algorithm,Problem)
       %% 得到初始化水波
        WaveFront = Problem.Initialization();
        [WaveFront,F,cd] = EnvironmentalSelection(WaveFront,Problem.N);    
       %% 迭代优化
        while Algorithm.NotTerminated(WaveFront)
            
            % 遗传操作得到看作波源的个体
            MatingPool = TournamentSelection(2,Problem.N,F,-cd);   
            SourcePop  = OperatorGA(Problem,WaveFront(MatingPool));      
            
            % 给波源个体确定传播方向
            n_Cast = numel(SourcePop);
            [WaveFront,~,~] = EnvironmentalSelection([WaveFront,SourcePop],n_Cast+Problem.N);
            DirectionFinder(SourcePop,WaveFront);
            
            % 生成新一轮水波波前
            FrontPop = OperatorDiff(SourcePop);
            [WaveFront,F,cd] = EnvironmentalSelection([WaveFront,FrontPop],Problem.N);
        end
    end
end

end