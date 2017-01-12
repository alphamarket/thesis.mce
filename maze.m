classdef maze
    properties
        earth;
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
        function  obj = maze()
            obj.index=[1 2 3 4 5 6 10 11 12 13 14 15 16 19 20 21 22 23 24 25 26 30 31 32 33 34 35 36];
            %obj.Qstar=[2.10469924812030,0.894229323308272,0.894229323308272,0.894229323308272;2.17982456140351,0.961842105263159,2.01922932330827,0.961842105263159;2.23684210526316,1.01315789473684,2.10469924812030,1.01315789473684;2.17982456140351,2.26315789473684,2.17982456140351,1.03684210526316;2.10469924812030,2.23684210526316,2.23684210526316,1.01315789473684;0.961842105263159,2.17982456140351,2.17982456140351,0.961842105263159;2.23684210526316,74.4933333333334,1.01315789473684,2.23684210526316;2.17982456140351,1.03684210526316,2.26315789473684,2.17982456140351;1.01315789473684,1.01315789473684,2.23684210526316,2.10469924812030;100.000000000000,100.000000000000,100.000000000000,100.000000000000;82.4000000000000,82.4000000000000,100.000000000000,89.0000000000000;74.4933333333334,74.4933333333334,91.0000000000000,80.9000000000000;73.1600000000000,82.4000000000000,82.4000000000000,2.26315789473684;82.4000000000000,91.0000000000000,89.0000000000000,100.000000000000;74.4933333333334,82.4000000000000,91.0000000000000,91.0000000000000;82.4000000000000,73.1600000000000,82.4000000000000,82.4000000000000;91.0000000000000,80.9000000000000,74.4933333333334,74.4933333333334;100.000000000000,89.0000000000000,82.4000000000000,89.0000000000000;100.000000000000,100.000000000000,100.000000000000,100.000000000000;82.4000000000000,100.000000000000,89.0000000000000,91.0000000000000;80.9000000000000,91.0000000000000,91.0000000000000,82.4000000000000;89.0000000000000,82.4000000000000,89.0000000000000,100.000000000000;100.000000000000,100.000000000000,100.000000000000,100.000000000000;82.4000000000000,89.0000000000000,100.000000000000,82.4000000000000;74.4933333333334,80.9000000000000,91.0000000000000,80.9000000000000;74.4933333333334,73.1600000000000,82.4000000000000,73.1600000000000;82.4000000000000,73.1600000000000,74.4933333333334,73.1600000000000;80.9000000000000,80.9000000000000,74.4933333333334,91.0000000000000];
            obj.numberOfState=36;
            obj.numberOfAction=4;
            obj.earth=ones(6,6);
            obj.earth(2,1:3)=0;
            obj.earth(3,5:6)=0;
            obj.earth(5,3:5)=0;
            obj.rewards=1./[8,7,6,5,6,7;-1,-1,-1,4,5,6;10,1,2,3,-1,-1;1,2,3,2,1,10;1,2,-1,-1,-1,1;10,1,2,3,3,2];%obj.earth-1;
            obj.rewards(3,1)=10;
            obj.rewards(4,6)=10;
            obj.rewards(6,1)=10;
            obj.NOC=6;
            obj.NOR=6;
            obj.NOA=4;
            obj.Goals=[3 4 6;1 6 1];
            obj.GoalsReward=[10 10 10];
            obj.numberOfActiveState=sum(sum(obj.earth));
            i=randi(obj.NOR);
            j=randi(obj.NOC);
            while obj.earth(i,j) ~= 1
                i=randi(obj.NOR);
                j=randi(obj.NOC);
            end
            obj.location=[i j];
        end
        function out=terminalState(obj)
            Lia = ismember(obj.location,obj.Goals', 'rows');
            if Lia==1
                out=logical(1);
            else
                out=logical(0);
            end
        end
        function out=locationNumber(obj)
            out=(obj.location(1)-1)*obj.NOC+obj.location(2);
        end
        function obj=reset(obj)
            i=randi(obj.NOR);
            j=randi(obj.NOC);
            while obj.earth(i,j) ~= 1
                i=randi(obj.NOR);
                j=randi(obj.NOC);
            end
            obj.location=[i j];
        end
        function obj=update(obj,action)
            [Lia, Locb] = ismember(obj.location,obj.Goals', 'rows');
            if Lia==1
                obj.reward=obj.GoalsReward(Locb);
            else
                switch action
                    case 1
                        tmpi=obj.location(1);
                        tmpj=obj.location(2)+1;
                    case 2
                        tmpi=obj.location(1)+1;
                        tmpj=obj.location(2);
                    case 3
                        tmpi=obj.location(1);
                        tmpj=obj.location(2)-1;
                    case 4
                        tmpi=obj.location(1)-1;
                        tmpj=obj.location(2);
                end
                if tmpi>0 && tmpi<=obj.NOR && tmpj<=obj.NOC && tmpj>0
                    obj.reward=obj.rewards(tmpi,tmpj);
                    if  obj.earth(tmpi,tmpj)==1 || obj.earth(tmpi,tmpj)==10
                        obj.location=[tmpi,tmpj];
                    end
                else
                    obj.reward=-1;
                end
            end
        end
    end
    
end

