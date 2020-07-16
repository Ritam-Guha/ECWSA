function [p]=encircle(Xp,c,A,D)
% encircling mechanism followed by humpback wghales
% follows Eqn. 10 of the paper 

    q = zeros(1,c);
    p = zeros(1,c);
    
    for i=1:c
        q(1,i)=Xp(1,i)-A(1,i)*D(1,i);
        if q(1,i)>1
            p(1,i)=1;
        else
            p(1,i)=0;
        end
    end
end