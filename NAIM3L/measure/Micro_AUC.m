function micro_AUC = Micro_AUC(labels,scores)

%Yuri Wu, 2016-04-10

micro_AUC=fast_AUC(labels(:),scores(:));

end