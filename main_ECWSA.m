  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ECWSA source codes version 1.0                                   %
%                                                                   %
%  Developed in MATLAB R2016a                                       %
%                                                                   %
%   Main Paper: Guha, R., Ghosh, M., Mutsuddi, S. et al.            %
%   Embedded chaotic whale survival algorithm for filter–wrapper    %
%   feature selection. Soft Comput (2020).                          %
%   https://doi.org/10.1007/s00500-020-05183-1                      %
%                                                                   %                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = main_ECWSA()
% This is the driver function to run ECWSA

    global x t x2 t2 memory;
    global populationSize iteration fold k;

    % set the global paramters
    populationSize = 100;
    iteration = 25;
    fold = 3;
    k = 5; % number of neighbors to be considered for KNN
    chaos_version = 4; % 1 for circular, 2 for logistics, 3 for piecewise and 4 for tent chaotic map 

    % set the dataset names over here
    datasets={'BreastCancer','BreastEW','CongressEW','Exactly','Exactly2','HeartEW','Ionosphere','KrVsKpEW'};
    
    gen_mRMR(datasets); % generate and store mRMR data for local search
    
    for i =1:size(datasets,2)

        fprintf('\n======================================\n');
        fprintf('              %s                    \n',datasets{i});
        fprintf('======================================\n');
        
        % loading dataset
        data = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_data.mat'));
        x = data.train;
        t = data.trainLabel;
        x2 = data.test;
        t2 = data.testLabel;
        
        % checking accuracy without FS
        [per,~]=knnClassifier(ones(1,size(x,2)));        
        fprintf('Accuracy without FS - %f\n',per);
        
        % Creating folders for storing results
        % The format of the last file is
        % ECWSA_{chaos_version}_Pop_{populationSize}_Iter_{iteration}_KNN_{k}
        location = strcat('Results/',datasets{i},'/');
        folderName = strcat(location,'ECWSA_',int2str(chaos_version),'_Pop_',int2str(populationSize),'_Iter_',int2str(iteration),'_KNN_',int2str(k));          
        mkdir(folderName); 
        
        % calling ECWSA which is the main function implementing 
        % Embedded Chaotic Whale Survival Algorithm        
        ECWSA(datasets{i},chaos_version,k);
        
        % Storing results and showing the final performance
        displayMemory(memory);                    
        save(strcat(folderName,'/Final.mat'),'memory');     
        memory = null(1);

    end

end

function [] = displayMemory(memory)    
    
    % Display the final results stored in memory
    fprintf('\n\n--------------FINAL RESULT-------------\n');
    prey = memory.prey;
    prey_acc = memory.preyacc;
    accuracy = memory.accuracy;
    population = memory.features;
    popSize = size(accuracy,1);
    fprintf('Prey: Features-%d Accuracy-%f\n', sum(prey), prey_acc);
    for i=1:popSize
        fprintf('Whale %d: Features-%d Accuracy-%f\n',i, sum(population(i,:)), accuracy(i,1));
    end
end
