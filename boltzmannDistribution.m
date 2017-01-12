function pro = boltzmannDistribution(setOfAction,n,t)
    s=0;
    for i=1:size(setOfAction,2)
        s=s+exp(setOfAction(i)/t);
    end
    pro=exp(setOfAction(n)/t)/s;
end

