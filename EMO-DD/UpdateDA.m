function UpdatedDA=UpdateDA(DA,Q,W,WX)

    S=[];                                                       % S is the set used for output
    DA=[DA,Q];
    N=size(W,1);
    Nx = size(WX,1);
    S_index = zeros(Nx);
    lower = min(DA.decs);
    upper = max(DA.decs);
    X = (DA.decs - lower)./(upper - lower);
    [~,Region_DA] = max(1 - pdist2(real(X),WX,'cosine'),[],2); %allocate the solutions in DA with each subregion in decision space
    for i = 1:Nx
        cp = find(Region_DA == i);
        k = 1;
        if isempty(cp) ~= 1
            O = DA(cp);
            [~,Region_O] = max(1 - pdist2(real(O.objs),W,'cosine'),[],2);
            Z = min(O.objs,[],1);
            g_tch=max(abs(O.objs-repmat(Z,length(O),1))./W(Region_O,:),[],2);      
            [~,order] = min(g_tch);
            S_index(i) = k;
            k = k + 1;
            S = [S, O(order(1))];
        end
    end
    DA = setdiff(DA,S); 

    if length(S) < N
        
        %% g1 = 1/Dis        
        X = (DA.decs - lower)./(upper - lower);
        [~,Region_DA] = max(1 - pdist2(real(X),WX,'cosine'),[],2); %associat the solutions in DA with modified X
        Dis = [];
        for i = 1 : Nx
            cp = find(Region_DA == i);
            if isempty(cp)~= 1
                O = DA(cp);
                Dis(cp) = sqrt(sum((O.decs-repmat(S(S_index(i)).dec,length(O),1)).^2,2));
            end
        end

        %% g2 = TCH of individuals in DA
        [~,Region_DA] = max(1 - pdist2(real(DA.objs),W,'cosine'),[],2);
        Z = min(DA.objs,[],1);
        da_tch=max(abs(DA.objs-repmat(Z,length(DA),1))./W(Region_DA,:),[],2);
        
        g1 = (1./Dis)';
        g2 = da_tch;
        PopObj = [g1,g2];
        [FrontNo,MaxNo] = NDSort(PopObj,inf);
        for i = 1 : MaxNo
            S = cat(2,S,DA(FrontNo == i));
            if length(S) >= N
                last = i;
                break;
            end
        end
        F_last = DA(FrontNo == last);
        delete_n = length(S) - N;   
        
        %% trim off the exceed solution with largest g2
        [~,index] = sort(g2(FrontNo == last),'descend');       
        x_worst = F_last(index(1:delete_n));
        S = setdiff(S,x_worst); 
    end                 
    UpdatedDA= S;        
end