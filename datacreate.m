%creates a feature list & value of acuuracy of list out of 1(0-1)
function [data] = datacreate(n,num)
%n is the number of chromosomes we are working on
%num is the number of features

rng('shuffle');
max=int16(num*0.50);%number of features we have
min=int16(num*0.40);%number of features we take minimum
if(max+min>n)
    max=max-1;
    min=min-1;
end
data=int16(zeros(n,num));
for i=1:n
    x2=int16(abs(rand*(min)))+(max);%number of features we select at max will have 5 features less than maximum
    temp=rand(1,num);
    [~,temp]=sort(temp);
    for j= 1:x2
        data(i,temp(j))=1;
    end
    %fprintf('number of features incorrect : %d \n', (count-x));
    %fprintf('number of features : %d \n', sum(data(i,:)==1));
    clear x2 temp;
end
clear max min count;
data = data > 0.5;
end