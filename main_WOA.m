%harness to run the optimisation function
function [] = main_WOA()
global x t x2 t2 memory;
global populationSize iteration fold;
% populationSize = 100;
% iteration = 25;
fold = 3;
%all datatset names

 datasets={'BreastCancer','BreastEW','CongressEW','Exactly','Exactly2','HeartEW','Ionosphere','KrVsKpEW'};

%%{
for i =1:count
    for j = 1:4
        for population = 20:20:100
            for iter = 10:5:30
                for k=5:5:5
                    fprintf('\n======================================\n');
                    fprintf('              %s                    \n',datasets{i});
                    fprintf('======================================\n');
                    x = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_train','.mat'));
                    x = x.input;
                    t = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_train_label','.mat'));
                    t = t.input1;
                    x2 = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_test','.mat'));
                    x2 = x2.test;
                    t2 = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_test_label','.mat'));
                    t2 = t2.test1;             
                    [per,~]=knnClassifier(ones(1,size(x,2)));
                    fprintf('Total performance - %f\n',per);
                    location = strcat('Results/',datasets{i},'/');
                    folderName = strcat(location,'WOA_',int2str(j),'_Pop_',int2str(population),'_Iter_',int2str(iter),'_KNN_',int2str(k));          
                    mkdir(folderName);
                    populationSize = population;
                    iteration = iter;
                    WOA(datasets{i},j,k);
                    displayMemory(memory);                    
                    save(strcat(folderName,'/Final.mat'),'memory');
                end
            end
        end
    end
    %%}
end
%}
% extractResults(datasets);
end

function [] = displayMemory(memory)
global x
disp('FINAL RESULT');
fprintf('NUM-%d ACC-%f\n',(sum(memory.features)/size(x,2))*100,memory.accuracy*100);
end
% 
% function [] = extractResults(datasets)
% count = size(datasets,2);
% for i =1:count
%     memory = load(strcat('Results/',datasets{i},'_memory.mat'));
%     memory = memory.memory;
%     fprintf('%f\t%d\n',memory.accuracy,sum(memory.features));
% end
% end