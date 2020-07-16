function [p]=spiral(xp,x,c)
% Spiral motion of the whales
% Follows Eqn. 2 of the paper    

    p = zeros(1,c);
    e=2.7182;
    b=0.1597;
    for i=1:c
        l=2*rand()-1;        
        q=(abs(xp(1,i)-x(1,i)))*(e^(b*l))*cos(2*3.1415*l)+xp(1,i);
        if(q>0.5)
            p(1,i)=1;
        else
            p(1,i)=0;
        end
    end
end