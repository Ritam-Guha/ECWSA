function [p]=chaotic(p,type)
if type==1
    p=circle(p);
elseif type==2
    p=logistics(p);
elseif type==3
    p=piecewise(p);
elseif type==4
    p=tent(p);
end

end

function [p]=circle(p)
a=0.5;
b=0.2;
pi=3.1415;
p=mod(p+b-(a/(2*pi))*sin(2*pi*p),1);
end

function [p]=logistics(p)
a=4;
p=a*p*(1-p);
end

function [p]=piecewise(p)
a=0.4;
if (p>=0 && p<a)
    p=p/a;
elseif (a<=p && p<0.5)
    p=(p-a)/(0.5-a);
elseif (p>=0.5 && p<(1-a))
    p=(1-a-p)/(0.5-a);
elseif (p>=(1-a) && p<1)
    p=(1-p)/a;
end
end

function [p]=tent(p)
if(p<0.7)
    p=p/0.7;
else
    p=(10*(1-p))/3;
end
end