function test = Run( test)
    countmq=0;
    for testindex=1:size(test,2)
        for subtestindex=1:test{testindex}.subtestsize
            disp(['Number of Subtitle ' num2str(subtestindex)]);
            for groupIndex=1:size(test{testindex}.group,2)
                disp(['Number of Method ' num2str(groupIndex)]);
                for agent=1:test{testindex}.group{groupIndex}.numberOfAgent
                    test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}=test{testindex}.environment();
                    test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=Q(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.numberOfState,test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.numberOfAction,test{testindex}.group{groupIndex}.beta,test{testindex}.group{groupIndex}.gamma,0,test{testindex}.group{groupIndex}.alpha);
                    test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.setstate(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.locationNumber(),1); test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.Changes{1}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.q;
                end
                disp(['Creates is successful']);
                counterindex=0;tempreward=0;
               tempmax=test{testindex}.group{groupIndex}.cooperativeLearningsize;
               for cooperativeLearningindex=1:tempmax
                   if mod(cooperativeLearningindex,10)==0
                       cooperativeLearningindex
                   end
                    for IndividualLearningindex=1:test{testindex}.group{groupIndex}.IndividualLearningsize
                        counterindex=counterindex+1;
                        for agent=1:test{testindex}.group{groupIndex}.numberOfAgent
                            test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex)=0;
                            if ~isempty(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.Qstar)
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.MSE(counterindex)=norm(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.Qstar-test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.index,:),1);
                            end
                            while ~test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.terminalState()  &&  test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex) < 1000
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex)=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex)+1;
                                [test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent},action]=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.move(test{testindex}.group{groupIndex}.temperature,test{testindex}.group{groupIndex}.SelectAction,test{testindex}.group{groupIndex}.micro);
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.update(action);
                                tempreward=tempreward+test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.reward;
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.learning(action,test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.reward,test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.locationNumber(),1);
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.Changes{end+1}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.templog;
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.setstate(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.locationNumber(),0);
                            end
                           
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.Avgreward(counterindex)=tempreward;
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.Avglength(counterindex)=sum(test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.length)/counterindex;
                           [test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent},action]=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.move(test{testindex}.group{groupIndex}.temperature,test{testindex}.group{groupIndex}.SelectAction,test{testindex}.group{groupIndex}.micro);
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.update(action);
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.learning(action,test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.reward,test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.locationNumber(),0);
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.reset();
                           test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.setstate(test{testindex}.subtest{subtestindex}.group{groupIndex}.environment{agent}.locationNumber(),0);
                           if test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex) < 1000 && test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.log.length(counterindex) > 0
                                test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.calculateMinlen(1);
                           else
                               test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.calculateMinlen(0);
                           end
                           tmin=test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen;
                           tmin(find(tmin==-1))=100;
                           [~,tmini]= min(tmin');
                           [~,tq]= max(test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
                           tmpindexs=find(test{testindex}.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen'==0);
                           if sum(tmini~=tq)
                               countmq=countmq+1;
                           end
                        end
                    end
                    test{testindex}.subtest{subtestindex}.group{groupIndex}.agent=merge(test{testindex},subtestindex,groupIndex);
                end
                counterindex=counterindex+1;
            end
        end
    end
        
        tempfig=figure;
        for i=1:size(test{testindex}.group,2)
            clear temp1;
            temp1=(test{testindex}.subtest{1}.group{i}.agent{1}.log.length);
            for j=1:test{testindex}.subtestsize
                for agent=1:test{testindex}.group{i}.numberOfAgent
                    temp1=temp1+(test{testindex}.subtest{j}.group{i}.agent{agent}.log.length);
                end
            end
            temp1=temp1-(test{testindex}.subtest{1}.group{i}.agent{1}.log.length);
            temp1=temp1/(test{testindex}.subtestsize*test{testindex}.group{i}.numberOfAgent);
            temp1=plot((temp1(1:end)),test{1}.group{i}.show,'DisplayName',test{1}.group{i}.name);
            hold on
        end
        legend(gca,'show');
        tempfig=figure;
        for i=1:size(test{testindex}.group,2)
            clear temp;
            temp=(test{testindex}.subtest{1}.group{i}.agent{1}.log.Avglength);
            for j=1:test{testindex}.subtestsize
                for agent=1:test{testindex}.group{i}.numberOfAgent
                    temp=temp+(test{testindex}.subtest{j}.group{i}.agent{1}.log.Avglength);
                end
            end
            temp=temp-(test{testindex}.subtest{1}.group{i}.agent{1}.log.Avglength);
            temp=temp/(test{testindex}.subtestsize*test{testindex}.group{i}.numberOfAgent);
            temp=plot([1:10:size(temp,2)],temp(1:10:end),test{1}.group{i}.show,'DisplayName',test{1}.group{i}.name);
            hold on
        end
        legend(gca,'show');
        tempfig=figure;
        for i=1:size(test{testindex}.group,2)
            clear temp1;
            temp1=(test{testindex}.subtest{1}.group{i}.agent{1}.log.Avgreward);
            for j=1:test{testindex}.subtestsize
                for agent=1:test{testindex}.group{i}.numberOfAgent
                    temp1=temp1+(test{testindex}.subtest{j}.group{i}.agent{agent}.log.Avgreward);
                end
            end
            temp1=temp1-(test{testindex}.subtest{1}.group{i}.agent{1}.log.Avgreward);
            temp1=temp1/(test{testindex}.subtestsize*test{testindex}.group{i}.numberOfAgent);
            temp1=plot(temp1(1:end),test{1}.group{i}.show,'DisplayName',test{1}.group{i}.name);
            hold on
        end
        legend(gca,'show');
end

