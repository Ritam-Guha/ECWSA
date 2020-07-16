function []=ECWSA(str,chaos,k)
% Function implementing the entire ECWSA procedure

    fprintf("ECWSA starting......\n\n");
    pause(3);
    rng('shuffle');
    global x memory;
    global iteration populationSize ;
    createDivision(); % function to separate the dataset into folds for crossvalidation
    totalPop = populationSize;
    [~,featCount]=size(x);

    %% generating initial population
    population=datacreate(populationSize,featCount);
    p=0.3; % inital chaos value
    decrement_ratio=0.8; % death     

    %% calculating fitness value of each solution
    [fitness, population] = rankPopulation(population);
    fprintf("==============Initial population of whales===============\n")
    displayPopulation(population)

    %% assiging fittest solution as prey
    prey=population(1,:);
    preyacc=fitness(1,1);
    init_best_acc=preyacc;
    init_best_feat=prey;
    fprintf('Initial percentage of selected features = %f\n',(sum(prey)*100)/featCount);
    fprintf('Initial best accuracy = %f\n',preyacc*100);

    %% for each iteration
    tic    
    
    % For the complete psudo code, please refer to Algorithm 2 of the paper
    for q=2:iteration+1
        fprintf('\n');
        fprintf('========================================\n');
        fprintf('             Iteration - %d\n',q-1);
        fprintf('========================================\n\n');

        location = strcat('Results/',str,'/');
        folderName = strcat(location,'ECWSA_',int2str(chaos),'_Pop_',int2str(totalPop),'_Iter_',int2str(iteration),'_KNN_',int2str(k));    

        for i=1:populationSize
            p=chaotic(p,chaos); 

            if p<0.5
                a=2-q*(2/iteration);
                r=rand(1,featCount);
                C=2*r;
                A=calculate_A(a,r,featCount);  

                if modulas_A(A,featCount)<1                    
                    % Exploitation using shrinking encircling
                    fprintf("Whale %d follows exploitation through encircling\n", i);
                    D=dista(C,population(i,:),prey,featCount);                                        
                    updatedPopulation(i,:)=encircle(prey,featCount,A,D); % update according to Eqn. 3     
                else
                    % Exploration using shrinking encircling
                    fprintf("Whale %d follows exploration through encircling\n", i);
                    sagent=round((populationSize-1)*(rand()))+1;
                    D=dista(C,population(i,:),population(sagent,:),featCount);                    
                    updatedPopulation(i,:)=encircle(population(sagent,:),featCount,A,D);    % update according to Eqn. 8     
                end
            else
                % Spiral Motion
                fprintf("Whale %d follows spiral motion\n", i);
                updatedPopulation(i,:)=spiral(population(i,:),prey,featCount);  % using spiral motion (Eqn. 2) to update the position
            end            
        end
        
        % performing mRMR-based local search
        fprintf('\n================local search starts=================\n\n');
        [updatedPopulation]=local_search(updatedPopulation,populationSize,str);       
        fprintf('\n================local search ends===================\n\n');

        % whale survival - less fit whales die due to starvation
        % Here the base population size is set to 15, change it if necessary
        populationSize=max(15,int16(decrement_ratio*populationSize));

        % updating the population and prey based on the new population        
        [new_fitness,updatedPopulation] = rankPopulation(updatedPopulation);        
        if new_fitness(1,1) > preyacc
            prey=updatedPopulation(1,:);
            preyacc=new_fitness(1,1);
        end

        population=updatedPopulation;       
        fprintf("Population after iteration %d...\n",q-1);
        displayPopulation(population);

        % displaying peformance of the best whale
        fprintf('Best accuracy till current iteration-%f\n',preyacc);
        save(strcat(folderName,'/Iteration_',int2str(q-1),'.mat'),'prey','preyacc');
    end
    
    % Displaying best result obtained after all iterations are done
    fprintf('\n\n---------------------BEST RESULT------------------\n');
    fprintf('Initial best accuracy:%f\n',init_best_acc);
    fprintf('Percentage of features selected initially=%f\n',sum(init_best_feat)*100/featCount);
    fprintf('Best aacuracy:%f\n',preyacc);
    fprintf('Percentage of selected features=%f\n',sum(prey)*100/featCount);
    fprintf('--------------------------------------------------\n');
    time=toc;
    
    % Applying final population of whales over test data 
    % Storing the results in memory
    fprintf("Till now test data is not considered while evaluating whales...\n");
    fprintf("Now the final set of whales are introduced to the test data...\n");
    final_acc = zeros(populationSize,1);
    for i=1:populationSize
        final_acc(i,1) = knnClassifier(updatedPopulation(i,:));
    end
    preyacc = knnClassifier(prey);
    [~,nid]=sort(final_acc,'descend');
    final_acc=final_acc(nid,:);
    updatedPopulation = updatedPopulation(nid,:);
    
    if(preyacc<final_acc(1,1))
        preyacc = final_acc(1,1);
        prey = updatedPopulation(1,:);
    end
    
    memory.preyacc = preyacc;
    memory.prey = prey;
    memory.accuracy(1:populationSize,:) = final_acc;
    memory.features(1:populationSize,:) = updatedPopulation;    
    memory.time=time;

end

function [P]=calculate_A(a,r,featCount)
    % Calculate A using Eqn. 4   
    P = zeros(1, featCount);
    for i=1:featCount
        P(1,i)=2*a*r(1,i)-a;
    end    
end

function [m]=modulas_A(A,featCount)
    s=0;
    for i=1:featCount
        s=s+A(1,i)*A(1,i);
    end
    m=sqrt(s);
end

function [d]=dista(C,X,Xp,featCount)
    % Calculate distance according to Eqn. 5
    d = zeros(1, featCount);
    for i=1:featCount
        d(1,i)=abs(C(1,i)*Xp(1,i)-X(1,i));
    end
end

function [per, pop] = rankPopulation(population)
    % Sort the population of whales according to fitness scores
    global populationSize k;
    [popSize,~]  = size(population);
    acc = zeros(popSize,1); 
    for i=1:popSize
        acc(i,1) = crossValidation(population(i,:),k);        
    end
    [~,nid]=sort(acc,'descend');
    acc=acc(nid,:);
    population = population(nid,:);
    per = acc(1:populationSize,1);
    pop = population(1:populationSize,:);
end

function [] = displayPopulation(population)
    % Display the population of whales at any point
    [popSize,~] = size(population);
    fprintf("Current population size - %d\n", popSize)
    [acc, pop] = rankPopulation(population);
    for i=1:popSize
        fprintf("Whale %d: Features-%d\t Accuracy-%f\n",i, sum(pop(i,:)), acc(i,1));
    end
    fprintf('\n\n');
end

%% division of crossvalidation
function [] = createDivision()

% This function assigns each training sample to a particular fold
% The variable selection contains the fold value for each sample

    global t fold selection;
    rows = size(t,1);
    s=size(t,1);
    labels=zeros(1,s);
    for i=1:s
        labels(1,i)=find(t(i,:),1);
    end
    l = max(labels);
    selection=zeros(1,rows);

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
                selection(i)=j; % sorts any extra into rest
                j=j+1;
            end
        end
    end
end