function [population]=local_search(population,pop_size,str)
relevancy=importdata(strcat('Data/',str,'/relevancy.mat'));
redundancy=importdata(strcat('Data/',str,'/redundancy.mat'));
for i=1:pop_size
    id1=1+int16(rand(1)*(pop_size-1));
    while(id1==i)
        id1=1+int16(rand(1)*(pop_size-1));
    end
    id2=1+int16(rand(1)*(pop_size-1));
    while(id2==id1 || id2==i)
        id2=1+int16(rand(1)*(pop_size-1));
    end
    diff=difference(population(id1,:),population(id2,:));
    neighbor1=union(population(i,:),diff);
    neighbor2=difference(population(i,:),diff);
    [fitness]=evaluate(population(i,:),relevancy,redundancy);
    if(isnan(fitness))
        continue;
    end
    [fitness1]=evaluate(neighbor1(1,:),relevancy,redundancy);
    if(isnan(fitness1))
        continue;
    end
    [fitness2]=evaluate(neighbor2(1,:),relevancy,redundancy);
    if(isnan(fitness2))
        continue;
    end
    fprintf('prev_fitness=%f\n',fitness);
    if(fitness1>fitness)
        fitness=fitness1;
        population(i,:)=neighbor1(1,:);
    end
    if(fitness2>fitness)
        fitness=fitness2;
        population(i,:)=neighbor2(1,:);
    end
    fprintf('new_fitness=%f\n\n',fitness);
end
end

function[pop]=complement(pop)
for i=1:size(pop,2)
    pop(1,i)=1-pop(1,i);
end
end

function[pop]=intersection(population1,population2)
pop=zeros(1,size(population1,2));
for i=1:size(pop,2)
    if(population1(1,i)*population2(1,i)==1)
        pop(1,i)=1;
    end
end
end

function[pop]=union(population1,population2)
pop=zeros(1,size(population1,2));
for i=1:size(pop,2)
    if(population1(1,i)==1 || population2(1,i)==1)
        pop(1,i)=1;
    end
end
end

function[pop]=difference(population1,population2)
pop=population1;
population2=complement(population2);
pop=intersection(pop,population2);
end

function [val]=evaluate(temp,relevancy,redundancy)
featureIndex=find(temp);
num=size(featureIndex,2);
d=0.0;
for i=1:num
    d = d + relevancy(featureIndex(i));
end
d=d/num;
r=0;
for i=1:num-1
    for j=i+1:num
        r = r + redundancy(featureIndex(i),featureIndex(j));
    end
end
r = r / ((num*(num-1))/2);
val = d - r;
end