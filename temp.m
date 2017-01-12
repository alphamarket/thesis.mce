        legend(gca,'show');
        tempfig=figure;
        testindex=1;
        for i=1:size(t{testindex}.group,2)
            clear temp;
            temp1=(t{testindex}.subtest{1}.group{i}.agent{1}.log.Avglength);
            for j=1:t{testindex}.subtestsize
                for agent=1:t{testindex}.group{i}.numberOfAgent
                    temp1=temp1+(t{testindex}.subtest{j}.group{i}.agent{1}.log.Avglength);
                end
            end
            temp1=temp1-(t{testindex}.subtest{1}.group{i}.agent{1}.log.Avglength);
            temp1=temp1/(t{testindex}.subtestsize*t{testindex}.group{i}.numberOfAgent);
            temp1=plot([1:10:size(temp1,2)],temp1(1:10:end),t{1}.group{i}.show,'DisplayName',t{1}.group{i}.name);
            hold on
        end
        legend(gca,'show');