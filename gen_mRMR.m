function []=gen_mRMR(datasets)
    
    % Generate max Relevancy Min Redundancy data for the datasets
    for i=1:size(datasets,2)
        fprintf('%s\n',datasets{i});
        data = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_data.mat'));
        
        % Load the train data
        x = data.train;
        t = data.trainLabel;
        
        % call mRMR
        maxRelMinRed(x,t,datasets{i});    
        fprintf('%s mRMR data generated and stored....\n',datasets{i});
    end
    
end