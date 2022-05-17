function [W,N] = UniformX(N,D)

    H1 = 1;
    while nchoosek(H1+D,D-1) <= N
        H1 = H1 + 1;
    end
    W = nchoosek(1:H1+D-1,D-1) - repmat(0:D-2,nchoosek(H1+D-1,D-1),1) - 1;
    W = ([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])/H1;
    if H1 < D
        H2 = 0;
        while nchoosek(H1+D-1,D-1)+nchoosek(H2+D,D-1) <= N
            H2 = H2 + 1;
        end
        if H2 > 0
            W2 = nchoosek(1:H2+D-1,D-1) - repmat(0:D-2,nchoosek(H2+D-1,D-1),1) - 1;
            W2 = ([W2,zeros(size(W2,1),1)+H2]-[zeros(size(W2,1),1),W2])/H2;
            W  = [W;W2/2+1/(2*D)];
        end
    end
    W = max(W,1e-6);
    N = size(W,1);
    
end