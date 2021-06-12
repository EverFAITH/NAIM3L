function macro_AUC = Macro_AUC(labels,scores)

%Yuri Wu, 2016-04-10

[n,m]=size(labels);
macro_AUC=0;
valid_labels=0;
for i=1:m
    if size(unique(labels(:,i)),1)==2
        %[~,~,~,temp]=perfcurve(labels(:,i),scores(:,i),1);
        temp=fast_AUC(labels(:,i),scores(:,i));
        macro_AUC=macro_AUC+temp;
        valid_labels=valid_labels+1;
    end
end
macro_AUC=macro_AUC/valid_labels;

end