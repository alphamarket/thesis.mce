function out = merge(group,subtestindex,groupIndex)
if strcmp(group.group{groupIndex}.type,'NewSA1')
    for agent=1:group.group{groupIndex}.numberOfAgent
       tmin=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen;
       tmin(find(tmin==-1))=inf;
       [tminv(agent,:),tmini(agent,:)]= min(tmin');
    end
    [minimumdistance,minimumdistanceindex]=min(tminv);
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
       minimumAction(i)=tmini(minimumdistanceindex(i),i);
    end
    for agent=1:group.group{groupIndex}.numberOfAgent
       [~,tq]= max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
       c(agent,:)=minimumAction==tq;
    end
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        if minimumdistance(i)==inf
            shockcount=0;
            for j=1:group.group{groupIndex}.numberOfAgent
                shockcount=shockcount+sum(group.subtest{subtestindex}.group{groupIndex}.agent{j}.Shock(i,:));
            end
            tempQ=zeros(1,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
            if shockcount>0
                for j=1:group.group{groupIndex}.numberOfAgent
                    tempQ=tempQ+((sum(group.subtest{subtestindex}.group{groupIndex}.agent{j}.Shock(i,:))/shockcount)*(group.subtest{subtestindex}.group{groupIndex}.agent{j}.q(i,:)));
                end
            else
                for j=1:group.group{groupIndex}.numberOfAgent
                    tempQ= tempQ +(1/group.group{groupIndex}.numberOfAgent)*(group.subtest{subtestindex}.group{groupIndex}.agent{j}.q(i,:));
                end
            end
            for j=1:group.group{groupIndex}.numberOfAgent
                group.subtest{subtestindex}.group{groupIndex}.agent{j}.q(i,:)=tempQ;
            end
        else
            %%
            compliant=find((c(:,i)')==1);
            shockcount=0;
            for j=1:size(compliant,2)
                shockcount=shockcount+group.subtest{subtestindex}.group{groupIndex}.agent{compliant(j)}.Shock(i,minimumAction(i));
            end
            tempQ=zeros(1,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
            if shockcount>0
                for j=1:size(compliant,2)
                    tempQ=tempQ+((group.subtest{subtestindex}.group{groupIndex}.agent{compliant(j)}.Shock(i,minimumAction(i))/shockcount)*(group.subtest{subtestindex}.group{groupIndex}.agent{compliant(j)}.q(i,:)));
                end
            else
                for j=1:size(compliant,2)
                    tempQ= tempQ +(1/size(compliant,2))*(group.subtest{subtestindex}.group{groupIndex}.agent{compliant(j)}.q(i,:));
                end
            end
            for j=1:size(compliant,2)
                group.subtest{subtestindex}.group{groupIndex}.agent{compliant(j)}.q(i,:)=tempQ;
            end
            %%
            contrary=find((c(:,i)')==0);
            shockcount=0;
            for j=1:size(contrary,2)
                [~,tq]= max(group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.q');
                shockcount=shockcount+group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.Shock(i,tq(i));
            end
            tempQ=zeros(1,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
            if shockcount>0
                for j=1:size(contrary,2)
                    [~,tq]= max(group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.q');
                    tempQ=tempQ+((group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.Shock(i,tq(i))/shockcount)*(group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.q(i,:)));
                end
            else
                for j=1:size(contrary,2)
                    tempQ= tempQ +(1/size(contrary,2))*(group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.q(i,:));
                end
            end
            for j=1:size(contrary,2)
                group.subtest{subtestindex}.group{groupIndex}.agent{contrary(j)}.q(i,:)=tempQ;
            end
        end
    end
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
            md(i,j)=inf;
            for agent=1:group.group{groupIndex}.numberOfAgent
               if md(i,j)>group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen(i,j) && group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen(i,j)>=0
                   md(i,j)=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen(i,j);
               end
            end
        end
    end
    for agent=1:group.group{groupIndex}.numberOfAgent
       group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen=md;
    end
end
if strcmp(group.group{groupIndex}.type,'NewSA')

    for agent=1:group.group{groupIndex}.numberOfAgent
       tmin=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen;
       tmin(find(tmin==-1))=100;
       [~,tmini]= min(tmin');
       [~,tq]= max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
       c(agent,:)=tmini==tq;
    end
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        qprin(i,:)=zeros(1,4);
        if sum(c(:,i))>0 && sum(c(:,i))< group.group{groupIndex}.numberOfAgent
           index=0;
           for agent=1:group.group{groupIndex}.numberOfAgent
               if c(agent,i)
                    index=index+1;
                    qprin(i,:)=qprin(i,:) + group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,:);
               end
           end
           qprin(i,:)=i;
        else
            for agent=1:group.group{groupIndex}.numberOfAgent
                qprin(i,:)=qprin(i,:) + group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,:);
            end
            qprin(i,:)=qprin(i,:)/group.group{groupIndex}.numberOfAgent;
        end
    end
    for agent=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q=qprin;
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end
if strcmp(group.group{groupIndex}.type,'min1')
    for agent=1:group.group{groupIndex}.numberOfAgent
         [~,policy]=sort(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
%          [~,min]=sort(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen','descend');
         tmp(agent,:)=sum(policy==min);
    end
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        qtmp(i,:)=zeros(1,4);
        if sum(tmp(:,i))~= 0
            for agent=1:group.group{groupIndex}.numberOfAgent
                qtmp(i,:)=qtmp(i,:)+(tmp(agent,i)/sum(tmp(:,i)))*group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,:);
            end
            for agent=1:group.group{groupIndex}.numberOfAgent
                group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,:)=qtmp(i,:);
            end
        end
    end
end
if strcmp(group.group{groupIndex}.type,'min')
    maintemp=ones(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction)*1001;
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        f(i)=0;
        for agent=1:group.group{groupIndex}.numberOfAgent
            if sum(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen(i,:)) > -4
                f(i)=1;
            end
            temp(i,:)=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.minlen(i,:);
            temp(find(temp==-1))=36;
            for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
                if maintemp(i,j)>temp(i,j)
                    maintemp(i,j)=temp(i,j);
                end
            end
        end
    end
    maintemp=1./maintemp;
    for agent=1:group.group{groupIndex}.numberOfAgent
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            if f(i)~=1
                group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq(i,:)=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,:);
            else
                group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq(i,:)=maintemp(i,:);
            end
        end
    end
end
if strcmp(group.group{groupIndex}.type,'ShockehBaba1')
    WSSType={'negative','AM','normal','absolute','gradian','positive'};
    for e=1:size(WSSType,2)
        for agent=1:group.group{groupIndex}.numberOfAgent
            temp(e,agent)=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.e(WSSType{e},group.group{groupIndex}.temperature);
        end
    end
    [~ , indexagent]=max(temp');
    tempq=zeros(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
    for e=1:size(WSSType,2)

        [~,policy]=max(group.subtest{subtestindex}.group{groupIndex}.agent{indexagent(e)}.q');

        for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            tempq(j,policy(j))=tempq(j,policy(j))+1;
        end
    end
    tempq=tempq+0.01;
    for  agent=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq=tempq;
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end
if strcmp(group.group{groupIndex}.type,'ShockehBaba2')
    temp=zeros(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
    for  agent=1:group.group{groupIndex}.numberOfAgent
        [~,policy]=max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            temp(i,policy(i))=temp(i,policy(i))+group.subtest{subtestindex}.group{groupIndex}.agent{agent}.Shock(i,policy(i));
        end
        temp(policy,:)=1;
    end
    temp=temp+0.01;
    for  agent=1:group.group{groupIndex}.numberOfAgent
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
            Difference(:,i)=abs(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.Shock(:,i)-max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.Shock')');
        end
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq=temp+(0.1*Difference);
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end
if strcmp(group.group{groupIndex}.type,'ShockehBaba')
    temp=zeros(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
    for  agent=1:group.group{groupIndex}.numberOfAgent
        [~,policy]=max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            temp(i,policy(i))=temp(i,policy(i))+group.subtest{subtestindex}.group{groupIndex}.agent{agent}.Shock(i,policy(i));
        end
        temp(policy,:)=1;
    end
    temp=temp+0.01;
    for  agent=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq=temp;
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end

if strcmp(group.group{groupIndex}.type,'ShockehBaba3')
    temp=zeros(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
    for  agent=1:group.group{groupIndex}.numberOfAgent
        [~,policy]=max(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q');
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            temp(i,policy(i))=temp(i,policy(i))+sum(group.subtest{subtestindex}.group{groupIndex}.agent{agent}.Shock(i,:));
        end
        temp(policy,:)=1;
    end
    temp=temp+0.01;
    for  agent=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.tempq=temp;
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end


if strcmp(group.group{groupIndex}.type,'single')
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end
if strcmp(group.group{groupIndex}.type,'Shock2')
    for k=1:group.group{groupIndex}.numberOfAgent
        for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
                temp(j,i)=boltzmannDistribution(group.subtest{subtestindex}.group{groupIndex}.agent{k}.Shock(j,:),i,0.4);
            end
        end
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            tmpcount(k,i)=0;
            for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
                tmpcount(k,i)=1/tmpcount(i)+(temp(i,j)*log(temp(i,j)));
            end
        end
    end
    tempshock=tmpcount;
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        tmp=sum(tempshock(:,i));
        out(i,:)=tempshock(1,i)/tmp* group.subtest{subtestindex}.group{groupIndex}.agent{1}.q(i,:);
           for agent=2:group.group{groupIndex}.numberOfAgent
                out(i,:)=out(i,:)+tempshock(1,i)/tmp* group.subtest{subtestindex}.group{groupIndex}.agent{1}.q(i,:);
           end
    end
end

if strcmp(group.group{groupIndex}.type,'Shock1')
    for k=1:group.group{groupIndex}.numberOfAgent
            for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
                tmpcount=0;
                for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
                    tmpcount=tmpcount+exp(group.subtest{subtestindex}.group{groupIndex}.agent{k}.Shock(i,j)/0.4);
                end
                tempshock(k,i)=1/exp(max(group.subtest{subtestindex}.group{groupIndex}.agent{k}.Shock(i,:))/0.4)/tmpcount;
            end
    end
        for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
            tmp=sum(tempshock(:,i));
            out(i,:)=tempshock(1,i)/tmp* group.subtest{subtestindex}.group{groupIndex}.agent{1}.q(i,:);
               for agent=2:group.group{groupIndex}.numberOfAgent
                    out(i,:)=out(i,:)+tempshock(1,i)/tmp* group.subtest{subtestindex}.group{groupIndex}.agent{1}.q(i,:);
               end
        end
end
if strcmp(group.group{groupIndex}.type,'Shock')
    for j=1:group.group{groupIndex}.numberOfAgent
        tempshock(j,:,:)=group.subtest{subtestindex}.group{groupIndex}.agent{j}.Shock;
    end
    for i=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState
        for j=1:group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction
%             [~ , tmpindex]=max(tempshock(:,i,j));
%             out(i,j)=group.subtest{subtestindex}.group{groupIndex}.agent{tmpindex}.q(i,j);
                out(i,j)=(tempshock(1,i,j)/sum(tempshock(1,i,j)))* group.subtest{subtestindex}.group{groupIndex}.agent{1}.q(i,j);
            for agent=2:group.group{groupIndex}.numberOfAgent

                out(i,j)=out(i,j)+(tempshock(agent,i,j)/sum(tempshock(1,i,j)))* group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q(i,j);
            end
        end
    end
end
if strcmp(group.group{groupIndex}.type,'MCE')
    WSSType={'negative','AM','normal','absolute','gradian','positive'};
    for e=1:size(WSSType,2)
        for agent=1:group.group{groupIndex}.numberOfAgent
            temp(e,agent)=group.subtest{subtestindex}.group{groupIndex}.agent{agent}.e(WSSType{e},group.group{groupIndex}.temperature);
        end
    end
    [~ , indexagent]=min(temp');
    tempq=zeros(group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfState,group.subtest{subtestindex}.group{groupIndex}.environment{1}.numberOfAction);
    for e=1:size(WSSType,2)
        clear data;
        for i=1:group.group{groupIndex}.numberOfAgent
            data{i}.e=group.subtest{subtestindex}.group{groupIndex}.agent{i}.e(WSSType{e},group.group{groupIndex}.temperature);
            data{i}.q=group.subtest{subtestindex}.group{groupIndex}.agent{i}.q;
        end
        % tempagent=group.subtest{subtestindex}.group{groupIndex}.agent{indexagent(e)}.merge(WSSType{e},data,group.group{groupIndex}.temperature);
        tempq=tempq + tempagent.q;
    end
    for i=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{i}.tempq=tempq;
    end
    out=group.subtest{subtestindex}.group{groupIndex}.agent;
end
if strcmp(group.group{groupIndex}.type,'WSS')
    for j=1:group.group{groupIndex}.numberOfAgent
        k=0;
        clear data;
        for i=1:group.group{groupIndex}.numberOfAgent
            if i==j
                k=1;
            else
                data{i-k}.e=group.subtest{subtestindex}.group{groupIndex}.agent{i}.e(group.group{groupIndex}.detail.type,group.group{groupIndex}.temperature);
                data{i-k}.q=group.subtest{subtestindex}.group{groupIndex}.agent{i}.q;
            end
        end
        group.subtest{subtestindex}.group{groupIndex}.agent{j}=group.subtest{subtestindex}.group{groupIndex}.agent{j}.merge(group.group{groupIndex}.detail.type,data,group.group{groupIndex}.temperature);
    end
end
if strcmp(group.group{groupIndex}.type,'SA')
    q=group.subtest{subtestindex}.group{groupIndex}.agent{1}.q;
    for agent=2:group.group{groupIndex}.numberOfAgent
        q=q+group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q;
    end
    q=q/group.group{groupIndex}.numberOfAgent;
    for agent=1:group.group{groupIndex}.numberOfAgent
        group.subtest{subtestindex}.group{groupIndex}.agent{agent}.q=q;
    end
end
out=group.subtest{subtestindex}.group{groupIndex}.agent;
end