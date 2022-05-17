function CrowdDis = CrowdingDistance(PopDec,FrontNo)
% Calculate the crowding distance in the decision space of each solution front by front

    [N,M]    = size(PopDec);
    CrowdDis = zeros(1,N);
    Fronts   = setdiff(unique(FrontNo),inf);
    for f = 1 : length(Fronts)
        Front = find(FrontNo==Fronts(f));
        Fmax  = max(PopDec(Front,:),[],1);
        Fmin  = min(PopDec(Front,:),[],1);
        for i = 1 : M
            [~,Rank] = sortrows(PopDec(Front,i));
            CrowdDis(Front(Rank(1)))   = inf;
            CrowdDis(Front(Rank(end))) = inf;
            for j = 2 : length(Front)-1
                CrowdDis(Front(Rank(j))) = CrowdDis(Front(Rank(j)))+(PopDec(Front(Rank(j+1)),i)-PopDec(Front(Rank(j-1)),i))/(Fmax(i)-Fmin(i));
            end
        end
    end
end