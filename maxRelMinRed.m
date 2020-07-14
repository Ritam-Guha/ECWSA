function [] = maxRelMinRed(data,class,str)
temp = zeros(size(class,1),1);
for i=1:size(data,1)
    temp(i,1)=find(class(i,:),1);
end
class = temp;
clear temp;
% if nargin == 0
%     data = importdata('dlbcl_1.csv');
%     
%     class=data(:,end);
%     data=data(:,1:end-1);
%     %data = data(:,1:20);
% end
bin = 10;

num = size(data,2);
chr = zeros(1,num);
redundancy = zeros(num);
relevance = zeros(1,num);

% data normalised
mean_feature = repmat(mean(data),size(data,1),1);
min_feature = repmat(min(data),size(data,1),1);
max_feature = repmat(max(data),size(data,1),1);
data = (data-mean_feature)./(max_feature-min_feature);
data = (data+1)/2; % from -1 to 1 => 0 to 1

%disp(data);
clear max_feature min_feature mean_feature;

for i=1:num
    for j=1:i-1
        redundancy(i,j) = mutualInformationf(data(:,i),data(:,j),bin);
        redundancy(j,i) = redundancy(i,j);
    end
end
for i=1:num
    relevance(1,i) = mutualInformationfC(data(:,i),class,bin);
end
save(strcat('Data/',str,'/redundancy.mat'),'redundancy');
save(strcat('Data/',str,'/relevancy.mat'),'relevance');
end

function [val] = mutualInformationf(xi,xj,bin)
val = entropy(xi,bin) + entropy(xj,bin) - jointEntropy(xi,xj,bin);
end

function [val] = mutualInformationfC(xi,class,bin)
val = entropy(xi,bin) + entropyClass(class) - jointEntropyClass(xi,class,bin);
end

function [val] = jointEntropy(xi,xj,bin)
if(isnan(xi))
    val=0;
    return;
end
if(isnan(xj))
    val=0;
    return;
end
    edges = 0:(1.0/bin):1;
    count = zeros(bin);
     fprintf('xi\n');
     disp(xi');
    listi = discretize(xi',edges);
    listj = discretize(xj',edges);
     disp(listi)
    if (sum(isnan(listi)) || sum(isnan(listj)))
        disp('error');
    end
    % disp(listi);
    % disp(size(listj));
    % disp(size(xi));
    for i=1:size(xi,1)
        count(listi(i),listj(i)) = count(listi(i),listj(i))+1;
    end
    count=count/(size(xi,1));
    count=reshape(count,1,(bin^2));
    val=0;
    for i=1:size(count,2)
        if count(1,i)~=0
            val = val + (count(1,i)*log(count(1,i)));
        end
    end
    val=-val;

end

function [val] = jointEntropyClass(xi,class,bin)
if(isnan(xi))
    val=0;
    return;
end
    edges = 0:(1.0/bin):1;
    listi = discretize(xi',edges);

    if min(class)==0
        class=class+1;
    end
    num = max(class);
    count = zeros(bin,num);

    if (sum(isnan(listi)) || sum(isnan(class)))
        disp('error');
    end
    for i=1:size(xi,1)
        count(listi(i),class(i)) = count(listi(i),class(i))+1;
    end
    count=count/(size(xi,1));
    count=reshape(count,1,(bin*num));
    val=0;
    for i=1:size(count,2)
        if count(1,i)~=0
            val = val + (count(1,i)*log(count(1,i)));
        end
    end
    val=-val;
end


function [val] = entropy(xi,bin)
edges = 0:(1.0/bin):1;
list = discretize(xi',edges);
if sum(isnan(list))
    disp('error');
end
count = zeros(1,bin);
for i=1:bin
    count(1,i) = sum(list==i);
end
count=count/size(xi,1);
val=0;
for i=1:size(count,2)
    if count(1,i)~=0
        val = val + (count(1,i)*log(count(1,i)));
    end
end
val=-val;
end

function [val] = entropyClass(class)
if min(class) == 0
    class=class+1;
end
bin=max(class);
count = zeros(1,bin);
for i=1:bin
    count(1,i) = sum(class==i);
end
count=count/size(class,1);
val=0;
for i=1:size(count,2)
    if count(1,i)~=0
        val = val + (count(1,i)*log(count(1,i)));
    end
end
val=-val;
end
