function instance_AUC = Instance_AUC(labels,scores)

%Yuri Wu, 2016-04-10

[n,m]=size(labels);


instance_AUC=0;
valid_instances=0;
for i=1:n
    if size(unique(labels(i,:)),2)==2
        %[~,~,~,temp]=perfcurve(labels(i,:),scores(i,:),1);
        temp=fast_AUC(labels(i,:),scores(i,:));
        instance_AUC=instance_AUC+temp;
        valid_instances=valid_instances+1;
    end
end
instance_AUC=instance_AUC/valid_instances;



end