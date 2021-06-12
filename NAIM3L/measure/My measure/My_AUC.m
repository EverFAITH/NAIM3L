function [AUC] = My_AUC(prevalue,Y)
[tpr,fpr] = mlr_roc(prevalue, Y);
[AUC, ~] = mlr_auc(fpr,tpr);
end

