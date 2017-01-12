classdef Q
    properties
        NOS;     %number of state
        NOA;     %number of action
        q;          %q table
        tempq;
        location; %current location
        log;        %report
        gamma;
        alpha;
        weight;
        Shock;
        beta;
        length;
		ntrial;
        repeat;
        templog;
        lastaction;
        minlen;
    end
    methods
        function obj= Q (numberOfState,numberOfAction,pAlpha,pGamma,Type,beta)
            obj.log.rewards(1)=0;
            obj.length=0;
            obj.beta=beta;
            obj.NOS=numberOfState;
            obj.NOA=numberOfAction;
            obj.repeat=zeros(1,obj.NOS);
            obj.q=rand(numberOfState,numberOfAction) * Type;
            obj.tempq=obj.q;
            obj.Shock=zeros(numberOfState,numberOfAction);
            obj.Shock(13,:)=1;
            obj.Shock(24,:)=1;
            obj.Shock(31,:)=1;
            obj.alpha=pAlpha;
            obj.gamma=pGamma;
            obj.weight.positive=0;
            obj.weight.normal=0;
            obj.weight.negative=0;
            obj.weight.absolute=0;
            obj.weight.gradian=0;
			obj.ntrial(1)=0;
            obj.lastaction=zeros(3,numberOfState);
            obj.minlen=zeros(numberOfState,numberOfAction)-1;
        end
        
        function obj=calculateMinlen(obj,type)
            if type==1
                tmpindexs=find(obj.lastaction(3,:)>0);
                for i=1:size(tmpindexs,2)
                    [~,tmp]= max(obj.lastaction(3,:));
                    if obj.minlen(tmp,obj.lastaction(1,tmp))==-1 || obj.minlen(tmp,obj.lastaction(1,tmp))> i
                        obj.minlen(tmp,obj.lastaction(1,tmp))=i;
                    end
                    obj.lastaction(3,tmp)=-1;
                end
            end
            obj.lastaction=zeros(3,size(obj.lastaction,2));
        end
        
        function obj=setstate(obj,l,flg)
            if flg==1
                obj.weight.gradian=0;
            end
            obj.location=l;
        end
        
        function tmpcount=Entropy(obj,Temperature)
            for j=1:obj.NOS
                for i=1:obj.NOA
                    temp(j,i)=boltzmannDistribution(obj.q(j,:),i,Temperature);
                end
            end
            for i=1:obj.NOS
                tmpcount(i)=0;
                for j=1:obj.NOA
                    tmpcount(i)=tmpcount(i)+(temp(i,j)*log(temp(i,j)));
                end
            end
        end
         function obj=merge(obj,type,data,Temperature)
             for i=1:size(data,2)
                 if data{i}.e>e(obj,type,Temperature)
                     w(i)=data{i}.e - e(obj,type,Temperature);
                 else
                     w(i)=0;
                 end
             end
             out = (1- obj.beta)*obj.q;
             if sum(w(i)) >0
                w(i)=w(i)/sum(w(i));
             end
             w(i)=w(i)*obj.beta;
             for i=1:size(data,2)
                 out=out+w(i)*data{i}.q;
             end
        end
        function out=e(obj,type,Temperature)
            if strcmp(type,'AM')==1
                out=(sum(obj.ntrial)/size(obj.ntrial,2)^-1);
            end
            if strcmp(type,'positive')==1
                out=obj.weight.positive;
            end
            if strcmp(type,'normal')==1
                out=obj.weight.normal;
            end
            if strcmp(type,'negative')==1
                out=obj.weight.negative;
            end
            if strcmp(type,'absolute')==1
                out=obj.weight.absolute;
            end
            if strcmp(type,'gradian')==1
                out=obj.weight.gradian;
            end
            if strcmp(type,'certainty')==1
                out=sum(sum(certainty(obj,Temperature)));
            end
            if strcmp(type,'Entropy')==1
                out=sum(sum(Entropy(obj,Temperature)));
            end
            if strcmp(type,'SA')==1
                out=1;
            end
            if strcmp(type,'Shock')==1
                out=sum(sum(obj.Shock));
            end
        end
        function out=shock(obj)
            tmp=sum(obj.Shock');
                for j=1:obj.NOA
                    out(:,j)=obj.Shock(:,j)/tmp';
                end
        end
        function out=certainty(obj,Temperature)
            for i=1:obj.NOS
                tmpcount=0;
                for j=1:obj.NOA
                    tmpcount=tmpcount+exp(obj.q(i,j)/Temperature);
                end
                out(i)=exp(max(obj.q(i,:))/Temperature)/tmpcount;
            end
        end
        function [obj,action] =move(obj,Temperature,type,micro)
           obj.length=obj.length+1;
            if type==1
                for i=1:obj.NOA
                     temp1(i)=boltzmannDistribution(obj.q(obj.location,:),i,0.4);
                end
                tmin=obj.minlen(obj.location,:);
                tmin(find(tmin==-1))=100;
                for i=1:obj.NOA
                     temp2(i)=boltzmannDistribution(1./tmin,i,Temperature);
                end
                action=RouletteWheelSelection(micro*temp2+(1-micro)*temp1);
                if isempty(action)
                    action
                end
            end
            if type==0
               action=selectActionBD(obj.q(obj.location,:),Temperature);
            end
            if type==2
                action=selectActionBD(obj.tempq(obj.location,:),Temperature);
                if isempty(action)
                    [~,action]=max(obj.tempq(obj.location,:));
                end
            end
        end
        function obj =learning(obj,action,reward,newState,type)
            
            if type
                obj.lastaction(1,obj.location)=action;
                obj.lastaction(2,obj.location)=newState;
                obj.lastaction(3,obj.location)=max(obj.lastaction(3,:))+1;
            end
			obj.ntrial(end)=obj.ntrial(end)+1;
            obj.log.rewards(end+1)=obj.log.rewards(end)+reward;
            if reward>0
                obj.weight.positive=obj.weight.positive+reward;
                obj.weight.absolute=obj.weight.absolute+reward;
            end
            if reward<0
                obj.weight.negative=obj.weight.negative+(reward * (-1));
                obj.weight.absolute=obj.weight.absolute+(reward * (-1));
            end
            obj.weight.normal=obj.weight.normal+reward;
            obj.weight.gradian=obj.weight.gradian+reward;%error
            obj.templog.location=obj.location;
            obj.templog.action=action;
            obj.templog.reward=reward;
            obj.templog.newState=newState;
            [tmpv tmpi]=max(obj.q(newState,:));
            if obj.Shock(newState,tmpi)>0
                obj.Shock(obj.location,action)= obj.Shock(obj.location,action)+1;
            end
            temp=obj.q(obj.location,action);
            obj.q(obj.location,action) = obj.q(obj.location,action) + obj.alpha * (reward + obj.gamma* tmpv - obj.q(obj.location,action));
            if temp == obj.q(obj.location,action)
                obj.repeat(obj.location)=obj.repeat(obj.location) + 1;
            end
            obj.templog.value=obj.q(obj.location,action);
        end
    end
end

