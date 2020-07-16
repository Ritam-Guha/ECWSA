function [population]=local_search(population,pop_size,str)
% function to implement mRMR-based local search
% Please refer to Algorithm 1 of the paper for the complete pseudocode of
% the local search procedure
    
    relevancy=importdata(strcat('Data/',str,'/relevancy.mat'));
    redundancy=importdata(strcat('Data/',str,'/redundancy.mat'));
    for i=1:pop_size
        final_id = 0;
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
        
        if(fitness1>fitness)
            final_id = 1;            
        end
        
        if(fitness2>fitness)
            final_id = 2;           
        end
        
        if(final_id == 1)
            population(i,:) = neighbor1(1,:);            
            fprintf("whale %d gets replaced by neighbor %d\n", i, final_id);
            
        elseif(final_id == 2)
            population(i,:) = neighbor2(1,:);            
            fprintf("neighbor %d replaces whale %d\n", i, final_id);
        
        else
            fprintf("whale %d remains unchanged\n",i);
        end
                
    end
end

function[pop]=complement(pop)
    % complement operation
    for i=1:size(pop,2)
        pop(1,i)=1-pop(1,i);
    end
end

function[pop]=intersection(population1,population2)
    % set intersection operation
    pop=zeros(1,size(population1,2));
    for i=1:size(pop,2)
        if(population1(1,i)*population2(1,i)==1)
            pop(1,i)=1;
        end
    end
end

function[pop]=union(population1,population2)
    % set union operation
    pop=zeros(1,size(population1,2));
    for i=1:size(pop,2)
        if(population1(1,i)==1 || population2(1,i)==1)
            pop(1,i)=1;
        end
    end
end

function[pop]=difference(population1,population2)
    % set difference operation
    pop=population1;
    population2=complement(population2);
    pop=intersection(pop,population2);
end

function [val]=evaluate(temp,relevancy,redundancy)
    % evaluation based on max relevancy min redundancy
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