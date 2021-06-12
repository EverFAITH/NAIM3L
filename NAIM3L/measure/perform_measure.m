function [measure]=perform_measure(y_pred,v_pred,y_true,required_measures)
y_pred(y_pred==0)=-1;
y_true(y_true==0)=-1;

for i=1:length(required_measures)
    measure_name=required_measures{i};
    switch(measure_name)
        case 'hamming loss'
            measure.hamming_loss=Hamming_loss(y_pred',y_true');
        case 'average precision'
            measure.average_precision=Average_precision(v_pred',y_true');
        case 'ranking loss'
            measure.ranking_loss=Ranking_loss(v_pred',y_true');
        case 'one-error'
            measure.one_error=One_error(v_pred,y_true);
        case 'coverage'
            measure.coverage=Coverage(v_pred',y_true');
        case 'macro-F1'
            measure.macro_F1=Macro_F1(y_pred,y_true);
        case 'micro-F1'
            measure.micro_F1=Micro_F1(y_pred,y_true);
        case 'instance-F1'
            measure.instance_F1=Instance_F1(y_pred,y_true);
        case 'macro-AUC'
            measure.macro_AUC=Macro_AUC(y_true,v_pred);
        case 'micro-AUC'
            measure.micro_AUC=Micro_AUC(y_true,v_pred);
        case 'instance-AUC'
            measure.instance_AUC=Instance_AUC(y_true,v_pred);  
    end
    
end

end