function [iter,tempsigma,HL_result,RL_result,AP_result,AUC_result] = main_final_func(Data,lamda,mu,maxIter,dataset,r_seed)
% clear;close all;
eval(['diary', ' result_', dataset, '.txt'])
diary on


X = Data.X;
Y = Data.Y;
P = Data.P;
traindata = Data.traindata;
train_Label = Data.train_Label;
testdata = Data.testdata;
test_Label = Data.test_Label;


X_K = Data.X_K;
Z_K = Data.Z_K;
Lamda_K = Data.Lamda_K;
leq_K = Data.leq_K;

ind_d = Data.ind_d;
d = Data.d;
C = Data.C;
View_num = Data.View_num;


%%%%%%%%%%%%main%%%%%%%%
Wt = rand(sum(d),C) * 2 -1;
tol = 1e-4;
t = 0.005;

temp_f_value_Ori = zeros(1,maxIter);
temp_f_value = zeros(1,maxIter);

tempsigma = zeros(1,maxIter);


RankingLoss = zeros(1,View_num);
AP = zeros(1,View_num);
AUC = zeros(1,View_num);
HammingLoss = zeros(1,View_num);

tic
w_bar = waitbar(0,'Start Optimization...');

Xk_sum1 = zeros(sum(d),sum(d));


parfor k =  1 : C
    Xk_sum1 = Xk_sum1 + X_K{1,k}' * X_K{1,k};
end


iter = 0;
while iter < maxIter
    t1 = toc;
    iter = iter + 1;
    
    %%%%%%%%%% Update W
    Xk_sum2 = zeros(sum(d),C);
    
    
    for k =  1 : C
        Xk_sum2 = Xk_sum2 + X_K{1,k}' * (mu * Z_K{1,k} - Lamda_K{1,k});
    end
    
    A = X' * Nuclearnorm_Subgradient(X * Wt,t);
    W = (mu * Xk_sum1) \ (lamda * A + Xk_sum2 - X'* (P.* (X * Wt - Y)));
    err = max(max(abs(W - Wt)));
    Wt = W;
    
    Nu_sum = 0;
    
    if  C > 100
        parfor k =  1 : C
            Nu_sum = Nu_sum + Nuclear_norm(X_K{1,k} * W, t);
        end
    else
        for k =  1 : C
            Nu_sum = Nu_sum + Nuclear_norm(X_K{1,k} * W, t);
        end
    end
    
    
    f_value_Ori = 1/2 * norm(P.* (X * W - Y),'fro')^2 + lamda * (Nu_sum -  Nuclear_norm(X * W, t));
    f_value1 = 1/2 * norm(P.* (X * W - Y),'fro')^2;
    f_value2 = Nu_sum - trace(W'* A);
    f_value = f_value1 + lamda * f_value2;
    
    temp_f_value_Ori(iter) = f_value_Ori;
    temp_f_value(iter) = f_value;
    
    %%
    %%%%%%%%%%% Update Zk
    stopC = ones(1,C);
    sigma_iter =  zeros(1,C);
    
    parfor k =  1 : C
        temp = X_K{1,k} * W + Lamda_K{1,k} / mu;
        [U,sigma,V] = svd(temp,'econ');
        sigma = diag(sigma);
        svp = length(find(sigma > lamda / mu));
        if svp >= 1
            sigma = sigma(1:svp) - lamda / mu;
        else
            svp = 1;
            sigma = 0;
        end
        tempz = U(:,1:svp) * diag(sigma) * V(:,1:svp)';
        stopC(k)= max(max(abs(tempz -Z_K{1,k})));
        Z_K{1,k} = tempz;
        sigma_iter(k) = sigma(1);
    end
    tempsigma(iter) = max(sigma_iter);
    
    if max(tempsigma) > 3 * 1e3
        disp('------------------------------mu is too small!---------------------------')
        break;
    end
    
    
    %%%%%%%% Update Lamda_k
    
    for  k =  1 : C
        leq_K{1,k} =  X_K{1,k} * W - Z_K{1,k};
    end
    
    err = max(max(stopC),err);
    if err < tol
        break;
    else
        for k =  1 : C
            Lamda_K{1,k} = Lamda_K{1,k} + mu * leq_K{1,k};
        end
    end
    
    
    t2 = toc;
    Str = ['Optimizing, wait please...',num2str(100*iter/maxIter),'%.',' Time remaining...', num2str((t2-t1)*(maxIter -iter)),'s'];
    waitbar(iter/maxIter,w_bar,Str)
end


pre_Value = cell(1,View_num);
pre_Label = cell(1,View_num);


disp('test test test')
tic
for  i =  1 : View_num
    if i == 1
        pre_Value{i} = testdata{i} * W(1 : ind_d(i),:);
        pre_Label{i} = sign(testdata{i} * W(1 : ind_d(i),:));
    else
        pre_Value{i} = testdata{i} * W(ind_d(i-1) + 1 : ind_d(i),:);
        pre_Label{i} = sign(testdata{i} * W(ind_d(i-1) + 1 : ind_d(i),:));
    end
end

parfor  i =  1 : View_num
    RankingLoss(i) = Ranking_loss(pre_Value{i}',test_Label{i}');
  
    AP(i) = Average_precision(pre_Value{i}',test_Label{i}');
  
    AUC(i) = My_AUC(pre_Value{i},test_Label{i});
 
    HammingLoss(i) = Hamming_loss(pre_Label{i}',test_Label{i}');
   
end
toc
disp('test test test')
%%

iter,f_value1,f_value2

f_diff = diff(temp_f_value);
find(f_diff>0);

%%
figure;
plot(tempsigma)
title(['sigma value ','lamda = ',num2str(lamda)])


figure;
plot(temp_f_value_Ori)
title(['Original object function loss ','lamda = ',num2str(lamda),', mu = ', num2str(mu)])

figure;
plot(temp_f_value)
title(['Surrogate object function loss ','lamda = ',num2str(lamda),', mu = ', num2str(mu)])


figure;
test_measure = [1-RankingLoss,AP,AUC,1-HammingLoss];
bar_x1 = 1:length(test_measure);
bar(bar_x1,test_measure);
title('test-result RankingLoss AP AUC HammingLoss')


HL_result = mean(1-HammingLoss)
RL_result = mean(1-RankingLoss)
AP_result = mean(AP)
AUC_result = mean(AUC)

close(w_bar);
diary off


save([dataset,'_',num2str(lamda),'_HL_result.mat'],'HL_result');
save([dataset,'_',num2str(lamda),'_RL_result.mat'],'RL_result');
save([dataset,'_',num2str(lamda),'_AP_result.mat'],'AP_result');
save([dataset,'_',num2str(lamda),'_AUC_result.mat'],'AUC_result');


save([dataset,'_',num2str(lamda),'_',num2str(r_seed),'_pre_Value.mat'],'pre_Value');
save([dataset,'_',num2str(lamda),'_',num2str(r_seed),'_pre_Label.mat'],'pre_Label');

pre_Yk = cell(1,C);
for ii = 1 : C
    pre_Yk{1,ii} = X_K{1,ii} * W;
end

save([dataset,'_',num2str(lamda),'_',num2str(r_seed),'_pre_Yk.mat'],'pre_Yk');





