close all
clear

datasets = {'pascal07','corel5k', 'mirflickr', 'espgame', 'iaprtc12'};
missing_ratio = 0.5;
view_missing_ratio = 0.5;



run_num = 10;


for dd = 1 : length(datasets)
    dataset = datasets{dd}
    HL_result = zeros(1,run_num);
    RL_result = zeros(1,run_num);
    AP_result = zeros(1,run_num);
    AUC_result = zeros(1,run_num);
    
    
    
    for i =  1 : run_num
        mu = 5;
        maxIter = 200;
        r_seed = i;
        
        switch dataset
            case{'pascal07'}
                lambda = 1.5;
                
            case{'corel5k'}
                lambda = 0.4;
                
            case{'mirflickr'}
                lambda = 0.6;
                
            case{ 'espgame'}
                lambda = 0.2;
                
            case{ 'iaprtc12'}
                lambda = 0.2;
        end
        
        tic
        Data = data_cmp_func(dataset,r_seed,missing_ratio,view_missing_ratio);
        [iter,tempsigma,HL_result(i),RL_result(i),AP_result(i),AUC_result(i)] = main_final_func(Data,lambda,mu,maxIter,dataset,r_seed);
        toc
    end
    HL_result,RL_result,AP_result,AUC_result
    
    
    eval([dataset, '_HL_mean = mean(HL_result) * 100'])
    eval([dataset, '_RL_mean = mean(RL_result) * 100'])
    eval([dataset, '_AP_mean = mean(AP_result) * 100'])
    eval([dataset, '_AUC_mean = mean(AUC_result) * 100'])
    
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_HL_mean.mat'],[dataset, '_HL_mean'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_RL_mean.mat'],[dataset, '_RL_mean'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_AP_mean.mat'],[dataset, '_AP_mean'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_AUC_mean.mat'],[dataset, '_AUC_mean'])
    
    eval([dataset, '_HL_std = std(HL_result,1) * 100'])
    eval([dataset, '_RL_std = std(RL_result,1) * 100'])
    eval([dataset, '_AP_std = std(AP_result,1) * 100'])
    eval([dataset, '_AUC_std = std(AUC_result,1) * 100'])
    
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_HL_std.mat'],[dataset, '_HL_std'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_RL_std.mat'],[dataset, '_RL_std'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_AP_std.mat'],[dataset, '_AP_std'])
    save([dataset,'_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_AUC_std.mat'],[dataset, '_AUC_std'])
    
end





