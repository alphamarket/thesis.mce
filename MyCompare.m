function [d,r] = MyCompare( x1,y1,x2,y2 )
dx=x2-x1;
dy=y2-y1;
d=sqrt((dx^2)+(dy^2));
phi1=atand(dy/dx);

if dx<0
    r=180+phi1;
else
    if dy<0
       r=360+phi1;
    else
        r=phi1;
    end
end
if dy==0 && dx==0
    r=0;
end
end

