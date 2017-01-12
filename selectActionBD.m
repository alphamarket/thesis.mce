function  index=selectActionBD(arrayInput,temperature)
for i=1:size(arrayInput,2)
     temp(i)=boltzmannDistribution(arrayInput,i,temperature);
end
index=RouletteWheelSelection(temp);
if isempty(index)
    if rand()<0.05
        index=randi(4);
    else
        [~,index]=max(arrayInput);
    end
end
end

