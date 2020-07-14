function []=WOA(str,chaos,k)
rng('shuffle');
global x memory;
global iteration populationSize ;
createDivision();
totalPop = populationSize;
[~,c]=size(x);
%% generating initial population

population=datacreate(populationSize,c);
p=0.3;
decrement_ratio=0.8;
fitness = zeros(1,populationSize);
%% calculating fitness value of each solution
for i=1:populationSize
    [fitness(i,1)]=crossValidation(population(i,:),k);
end
[best,id]=sort(fitness,'descend');
%% assiging fittest solution as prey
prey=population(id(1,1),:);
preyacc=best(1,1);
init_best_acc=preyacc;
init_best_feat=prey;
fprintf('INITAL PERCENTAGE OF FEATURE SELECTED = %f\n',(sum(prey)*100/c)*100);
fprintf('INITIAL BEST ACCURACY TILL NOW = %f\n',preyacc*100);

%% for each iteration
tic
updatedPopulation = zeros(populationSize,c);
 new_fitness = zeros(populationSize,1);
for q=1:iteration
    fprintf('\n');
    fprintf('========================================\n');
    fprintf('             Iteration - %d\n',q);
    fprintf('========================================\n\n');
    
    location = strcat('Results/',str,'/');
    folderName = strcat(location,'WOA_',int2str(chaos),'_Pop_',int2str(totalPop),'_Iter_',int2str(iteration),'_KNN_',int2str(k));    
    for i=1:populationSize
        p=chaotic(p,chaos);
        %         fprintf('p=%f\n',p);
        if p<0.5
            a=2-q*(2/iteration);
            r=rand(1,c);
            C=2*r;
            A=calculate(a,r,c);
            if modulas(A,c)<1
                D=dista(C,population(i,:),prey,c);
                %                 fprintf('---------Encircle--------\n');
                updatedPopulation(i,:)=encircle(prey,c,A,D);
            else
                sagent=round((populationSize-1)*(rand()))+1;
                D=dista(C,population(i,:),population(sagent,:),c);
                %                 fprintf('---------Exploration--------\n');
                updatedPopulation(i,:)=encircle(population(sagent,:),c,A,D);
            end
        else
            %             fprintf('---------Spiral--------\n');
            updatedPopulation(i,:)=spiral(population(i,:),prey,c);  % using spiral equation to update the position
        end
    end
    fprintf('\n================local search starts=================\n');
    [updatedPopulation]=local_search(updatedPopulation,populationSize,str);
    fprintf('\n================local search ends===================\n');
    
   
    for i=1:populationSize
        [new_fitness(i,1)]=crossValidation(updatedPopulation(i,:),k);
    end
    [nbest,nid]=sort(new_fitness,'descend');
    new_fitness=new_fitness(nid,:);
    updatedPopulation = updatedPopulation(nid,:);
    if nbest(1,1) > preyacc
        prey=updatedPopulation(nid(1,1),:);
        preyacc=nbest(1,1);
    end
    
    
    populationSize=max(15,int16(decrement_ratio*populationSize));
    population(1:populationSize,:)=updatedPopulation(1:populationSize,:);
	fitness(1:populationSize,1)=new_fitness(populationSize,1);
    fprintf('BEST ACCURACY TILL CURRENT ITERATION-%f\n',preyacc*100);
    save(strcat(folderName,'/Iteration_',int2str(q),'.mat'),'prey','preyacc');
end

fprintf('\n\n---------------------BEST RESULT------------------\n');
fprintf('INITIAL BEST ACCURACY:%f\n',init_best_acc*100);
fprintf('PERCENTAGE OF INITIAL FEATURE SELECTED=%f\n',sum(init_best_feat)*100/c);
fprintf('BEST ACCURACY:%f\n',preyacc*100);
fprintf('PERCENTAGE OF FEATURE SELECTED=%f\n',sum(prey)*100/c);
fprintf('--------------------------------------------------\n');
time=toc;
memory(1,:).accuracy = preyacc;
memory(1,:).features = prey;
memory.accuracy(2:(1+size(new_fitness,1)),:) = new_fitness;
memory.features(2:(1+size(new_fitness,1)),:) = updatedPopulation;
memory.time=time;
% save(strcat('Results/',str,'/Final_WOA_',int2str(chaos),'_Pop_',int2str(populationSize),'_Iter_',int2str(iteration),'_KNN_',int2str(k),'.mat'),'population','fitness','memory');
end
function [P]=calculate(a,r,c)
for i=1:c
    P(1,i)=2*a*r(1,i)-a;
end
end
function [m]=modulas(A,c)
s=0;
for i=1:c
    s=s+A(1,i)*A(1,i);
end
m=sqrt(s);
end
function [d]=dista(C,X,Xp,c)
for i=1:c
    d(1,i)=abs(C(1,i)*Xp(1,i)-X(1,i));
end
end
%% division of crossvalidation
function [] = createDivision()
global t fold selection;
rows = size(t,1);
s=size(t,1);
labels=zeros(1,s);
for i=1:s
    labels(1,i)=find(t(i,:),1);
end
l = max(labels);
selection=zeros(1,rows);
% disp(size(selection));
for k=1:l
    count1=sum(labels(:)==k);
    samplesPerFold=int16(floor((count1/fold)));
    for j=1:fold
        count=0;
        for i=1:rows
            if(labels(i)==k && selection(i)==0)
                selection(i)=j;
                count=count+1;
            end
            if(count==samplesPerFold)
                break;
            end
        end
    end
    j=1;
    for i=1:rows
        if(selection(i)==0 && labels(i)==k)
            selection(i)=j;%sorts any extra into rest
            j=j+1;
        end
    end
end
end