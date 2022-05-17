classdef EMODD < ALGORITHM
    % <multi> <real> <multimodal>
    % Q. Yang, Z. Wang, et al, Balancing performance between the decision space
    % and the objective space in multimodal multiobjective optimization,
    % Memetic Computing, 2021, 13(1): 31-47.
    
    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
    % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
    % for evolutionary multi-objective optimization [educational forum], IEEE
    % Computational Intelligence Magazine, 2017, 12(4): 73-87".
    %--------------------------------------------------------------------------
    
    methods
        function main(Algorithm,Problem)
            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            [WX,~] = UniformX(Problem.N,Problem.D);
            
            %% Generate random population
            Population = Problem.Initialization();
            
            DA=UpdateDA([],Population,W,WX);         % initial DA
            Population=UpdateCA([],DA,W);
            
            %% Optimization;
            while Algorithm.NotTerminated(Population)
                %% calculate the proportion of non-dominated solutions in population
                [FrontNo,~]=NDSort(Population.objs,inf);
                NP=size(find(FrontNo==1),2);
                Pp=NP/length(Population);
                %% calculate the proportion of non-dominated solutions in DA
                [FrontNo,~]=NDSort(DA.objs,inf);
                ND=size(find(FrontNo==1),2);
                Pda=ND/length(DA);
                
                %% reproduction
                Q=[];
                for i=1:size(W,1)
                    if Pda > Pp
                        P1=MatingSelection(DA);
                    else
                        P1=MatingSelection(Population);
                    end
                    pf=rand();
                    if pf < Pda
                        P2=MatingSelection(DA);
                    else
                        P2=MatingSelection(Population);
                    end
                    MatingPool=[P1,P2];
                    Offspring  = OperatorGAhalf(MatingPool);
                    Q=[Q,Offspring];
                end
                %% update DA and Population
                DA=UpdateDA(DA,Q,W,WX);
                Population=UpdateCA(Population,DA,W);
            end
        end
    end
end