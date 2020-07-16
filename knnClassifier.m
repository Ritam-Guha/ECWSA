function [performance,knnModel]=knnClassifier(whale)
% function to implement k-nearest neighbor classifier

    global x t x2 t2;
    if(sum(whale(1,:)==1)~=0)
        tempx2=x2(:,whale(:)==1);
        tempx=x(:,whale(:)==1);

        s=size(t,1);
        label=zeros(1,s);
        for i=1:s
            label(1,i)=find(t(i,:),1);
        end

        knnModel=fitcknn(tempx,label,'NumNeighbors',5,'Standardize',1);   
        [label,~] = predict(knnModel,tempx2);


        s=size(t2,1);
        lab=zeros(s,1);
        for i=1:s
            lab(i,1)=find(t2(i,:),1);        
        end    
        c = sum(lab ~= label)/s; % mis-classification rate

        performance=1-c;

    else
        performance=0;    
    end
    
    performance = performance*100;
end