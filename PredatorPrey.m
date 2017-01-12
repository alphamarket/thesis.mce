classdef PredatorPrey
    properties
        Predator;
        Prey;
        height;
        width;
        actionset;
        rewards;
        location;
        reward;
        NOC;
        NOR;
        NOA;
        Goals;
        GoalsReward;
        numberOfState;
        numberOfActiveState;
        numberOfAction;
        Qstar;
        index;
    end
    
    methods
        function  obj = PredatorPrey()
            
            obj.index=[1:17];
            obj.NOA=16;
            obj.GoalsReward=[10];
            obj.numberOfState=17;
            obj.numberOfActiveState=obj.numberOfState;
            obj.numberOfAction=16;
            %obj.Qstar=zeros(obj.numberOfState,obj.numberOfAction);
            obj.width=10;
            obj.height=10;
            obj.Predator(1)=randi(2*obj.width)/2;
            obj.Predator(2)=randi(2*obj.height)/2;
            obj.Prey(1)= randi(2*obj.width)/2;
            obj.Prey(2)=randi(2*obj.height)/2;
             while 1
                [d r]=MyCompare(obj.Predator(1),obj.Predator(2),obj.Prey(1),obj.Prey(2));
                if d > 1
                    obj.location=17;
                    break;
                else
                    obj.location=fix(r/45)+1;
                    if d <= 0.5
                        obj.Predator(1)=randi(2*obj.width)/2;
                        obj.Predator(2)=randi(2*obj.height)/2;
                        obj.Prey(1)= randi(2*obj.width)/2;
                        obj.Prey(2)=randi(2*obj.height)/2;
                    else
                        obj.location=obj.location+8;
                        break;
                    end
                end
            end
            obj.actionset=[0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1 1 1 1 1 1 1 1;0    45    90   135   180   225   270   315    0    45    90   135   180   225   270   315];
        end
        function out=terminalState(obj)
            [d r]=MyCompare(obj.Predator(1),obj.Predator(2),obj.Prey(1),obj.Prey(2));
            if d <=0.5
                out=logical(1);
            else
                out=logical(0);
            end
        end
        function out=locationNumber(obj)
            out=obj.location;
        end
        function obj=reset(obj)
            obj.Predator(1)=randi(2*obj.width)/2;
            obj.Predator(2)=randi(2*obj.height)/2;
            obj.Prey(1)= randi(2*obj.width)/2;
            obj.Prey(2)=randi(2*obj.height)/2;
            while 1
            [d r]=MyCompare(obj.Predator(1),obj.Predator(2),obj.Prey(1),obj.Prey(2));
            if d > 1
                obj.location=17;
                break;
            else
                obj.location=fix(r/45)+1;
                if d <= 0.5
                    obj.Predator(1)=randi(2*obj.width)/2;
                    obj.Predator(2)=randi(2*obj.height)/2;
                    obj.Prey(1)= randi(2*obj.width)/2;
                    obj.Prey(2)=randi(2*obj.height)/2;
                else
                    obj.location=obj.location+8;
                    break;
                end
            end
            end
        end
        function obj=update(obj,action)
            %prey is doing action
            actionofprey=datasample([1:8],1);
            temp(1)=obj.Prey(1)+obj.actionset(1,actionofprey)*cosd(obj.actionset(2,actionofprey));
            temp(2)=obj.Prey(2)+obj.actionset(1,actionofprey)*sind(obj.actionset(2,actionofprey));
            if temp(1)>= 0 && temp(1)<= obj.width && temp(2)>= 0 && temp(2)<= obj.height
                obj.Prey=temp;
            end
            %predator is doing action
            temp(1)=obj.Predator(1)+obj.actionset(1,action)*cosd(obj.actionset(2,action));
            temp(2)=obj.Predator(2)+obj.actionset(1,action)*sind(obj.actionset(2,action));
            if temp(1)>= 0 && temp(1)<= obj.width && temp(2)>= 0 && temp(2)<= obj.height
                obj.Predator=temp;
            end
            %
            [d r]=MyCompare(obj.Predator(1),obj.Predator(2),obj.Prey(1),obj.Prey(2));
            obj.reward=-0.1;
            if d > 1
                obj.location=17;
            else
                obj.location=fix(r/45)+1;
                if d <= 0.5
                    obj.reward=10;
                else
                    obj.location=obj.location+8;
                end
            end
        end
        function newstate=feedback(obj,action)
            newstate(1)=obj.Predator(1)+obj.actionset(1,action)*cosd(obj.actionset(2,action));
            newstate(2)=obj.Predator(2)+obj.actionset(1,action)*sind(obj.actionset(2,action));
        end
    end
    
end

