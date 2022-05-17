function UpdatedPopulation=UpdateCA(Population,DA,W)
% Update CA
% CA is the Archive that has not been updated.
% Q is the set of offspring.

    S=[];           % S is the set used for output                                                   % Sc is used to collect feasible solutions
    Population=[Population,DA];  
    N = size(W,1);
    if length(Population) == N
        S = Population;
    else        
        S = EnvironmentSelection(Population,N);
    end
    UpdatedPopulation = S;
end