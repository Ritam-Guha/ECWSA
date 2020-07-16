function [per]=crossValidation(whale,k)
% Crossvalidates the agents with (k-1) folds for training, 1 fold for testing     
    
    global x t fold selection;
    rng('default');

    rows=size(x,1);    
    accuracy=zeros(1,fold);
    data=x(:,whale==1);
    if (size(data,2)==0)
        per = 0;
        return;
    end
    for i=1:fold    
        chr=zeros(rows,1);%0 training, 1 test;
        for j=1:rows
            if selection(j)==i
                chr(j,1)=1;
            end
        end
        ch = 1;
        if (ch==1)
            accuracy(1,i) = knnClassify(data,t,chr,k);
        elseif (ch==2)
            accuracy(1,i) = svmClassify(data,t,chr,k);
        else
            accuracy(1,i) = mlpClassify(data,t,chr,k);
        end
    end

    per = mean(accuracy);
    per = per * 100;
end

function [performance]=knnClassify(x,t,chr,k)

    % This function implements knn classifier but it uses
    % only training dataset for classification thereby
    % preserving the test data only for the final accuracy computation
    
    x2=x(chr(:)==1,:);
    t2=t(chr(:)==1,:);
    x=x(chr(:)==0,:);
    t=t(chr(:)==0,:);

    s=size(t,1);
    label=zeros(1,s);
    for i=1:s
        label(1,i)=find(t(i,:),1);
    end

    knnModel=fitcknn(x,label,'NumNeighbors',k,'Standardize',1);
    [label,~] = predict(knnModel,x2);
    s=size(t2,1);
    lab=zeros(s,1);
    for i=1:s
        lab(i,1)=find(t2(i,:),1);
    end
    c = sum(lab ~= label)/s; % mis-classification rate
    performance=1-c;
end

