function [Data] = data_cmp_func(dataset,r_seed,missing_ratio,view_missing_ratio)
tic

%% data  preprocessing

rng(r_seed);

                                                      
path = 'C:\Users\Administrator\Desktop\NAIM3L\data\';                       % replace the path of your own(windows version) 
a = dir(fullfile([path,dataset,'_mat\'], '*.mat'));                         % windows version (for linux version, change \ to / )

for i = 1:length(a)
    load(a(i).name);
end

View_num = 6;



AllY = [double(eval([dataset,'_train_Label']));double(eval([dataset, '_test_Label']))];
AllY(AllY == 0) = -1;
[num, C]= size(AllY);


All_num = 1 : num;
test_label_ratio = 0.3;                                                                 %30% for testing
test_num = floor(num * test_label_ratio);

index_train_keep = zeros(1,C);                                                          %ensure there is at least one sample for each label 
for i = 1 : C
    temp = find(AllY(:,i)==1);
    index_train_keep(i) = temp(1);
end

index_train_keep = unique(index_train_keep);
All_num(index_train_keep)=[];
test_index = All_num(randperm(numel(All_num),test_num));
train_index = 1 : num;
train_index(test_index) = [];
train_num = length(train_index);
trainY_index = setdiff(train_index,index_train_keep);                                   %only missing features in the training set 
train_missing_num = length(trainY_index);                                  



Observe_Y = AllY(train_index,:);
train_Gt = AllY(train_index,:);
rank_train = rank(train_Gt);


for  i =  1 : C                                                                          % 50% of positive and negative labels are missing respectively 
    p_index = find(Observe_Y(:,i) == 1);
    p_del = p_index(randperm(length(p_index), floor(length(p_index) * missing_ratio)));
    n_index = find(Observe_Y(:,i) == -1);
    n_del = n_index(randperm(length(n_index), floor(length(n_index) * missing_ratio)));
    all_del = [p_del;n_del];
    Observe_Y(all_del,i) = 0;
end


num_missing = floor(train_num * view_missing_ratio);
index_del = zeros(View_num - 1, num_missing);
for  i =  1 : View_num - 1
    index_del(i,:) = trainY_index(randperm(train_missing_num, num_missing));
end

index_del_all = reshape(index_del,1, (View_num - 1) * num_missing);
[frequence,index_label] = hist(index_del_all,unique(index_del_all));

index_keep = index_label(frequence == (View_num - 1));                                    % ensure there is at least one view
index_new = setdiff(trainY_index,index_keep);

index_del = [index_del;index_new(randperm(length(index_new),num_missing))];               % the missing index of each view


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Alldata = cell(1,View_num);
traindata = cell(1,View_num);
testdata = cell(1,View_num);
test_Label = cell(1,View_num);
trainY = cell(1,View_num);
trainP = cell(1,View_num);
train_Label = cell(1,View_num);



Alldata{1} = [double(eval([dataset,'_train_DenseHue_data']));double(eval([dataset,'_test_DenseHue_data']))];               % Original data set, samples are aligned
Alldata{2} = [double(eval([dataset,'_train_DenseSift_data']));double(eval([dataset,'_test_DenseSift_data']))];
Alldata{3} = [double(eval([dataset,'_train_Gist_data']));double(eval([dataset,'_test_Gist_data']))];

Alldata{4} = [double(eval([dataset,'_train_Hsv_data']));double(eval([dataset,'_test_Hsv_data']))];
Alldata{5} = [double(eval([dataset,'_train_Rgb_data']));double(eval([dataset,'_test_Rgb_data']))];
Alldata{6} = [double(eval([dataset,'_train_Lab_data']));double(eval([dataset,'_test_Lab_data']))];


for i = 1 : View_num
    clo = sum(Alldata{i},1);
    del_clo = clo == 0;
    Alldata{i}(:,del_clo) = [];
    
    
    [~,score,~] = pca(Alldata{i});
    Alldata{i} = score(:,1 : 50);
    Alldata{i} = Normalize_row(Alldata{i});                                % normalize by row(sample)
end


%%

d = zeros(1,View_num);
test_Gt = AllY(test_index,:);
rank_test = rank(test_Gt);

for  i =  1 : View_num
    trainY{i} = Observe_Y;
    train_Label{i} = train_Gt;
    test_Label{i} = test_Gt;
    Alldata{i}(index_del(i,:),:) = 0;                                      
  
    
    traindata{i} = Alldata{i}(train_index,:);
    index0 = find(all(traindata{i}==0,2));
    trainY{i}(index0,:) = [];
    train_Label{i}(index0,:) = [];
    traindata{i}(index0,:) = [];
    traindata{i} = [traindata{i} ones(size(traindata{i},1),1)];
    testdata{i} = Alldata{i}(test_index,:);
    testdata{i} = [testdata{i} ones(test_num,1)];
    d(i) = size(traindata{i},2);
    
    train_perm = randperm(size(traindata{i},1));                           % random shuffle, samples are not aligned
    test_perm = randperm(test_num);
    traindata{i} = traindata{i}(train_perm,:);
    testdata{i} =  testdata{i}(test_perm,:);
    trainY{i} = trainY{i}(train_perm,:);
    train_Label{i} = train_Label{i}(train_perm,:);
    test_Label{i} = test_Label{i}(test_perm,:);
    
    trainP{i} = ones(size(traindata{i},1), C);
    trainP{i}(trainY{i}==0) = 0;
end




%%

n = ones(1,View_num) * (size(traindata{i},1));

trainXk = cell(View_num,C);
trainYk = cell(View_num,C);


nk = zeros(View_num,C);
for i = 1 : View_num
    for j = 1 : C
        trainXk{i,j} = traindata{i}(trainY{i}(:,j)==1,:);                  % calculate the sample sub-matrix Xk of each view
        trainYk{i,j} = trainY{i}(trainY{i}(:,j)==1,:);
        nk(i,j) = size(trainXk{i,j},1);
    end
end


X = zeros(sum(n), sum(d));
Y = zeros(sum(n),C);
P = zeros(sum(n),C);

ind_n = cumsum(n);
ind_d = cumsum(d);
ind_nk = cumsum(nk);

for i =  1 : View_num
    X(ind_n(i) - n(i) + 1 : ind_n(i),ind_d(i) - d(i) + 1 : ind_d(i)) =  traindata{i};
    Y(ind_n(i) - n(i) + 1 : ind_n(i),1 : C) = trainY{i};
    P(ind_n(i) - n(i) + 1 : ind_n(i),1 : C) = trainP{i};
end

X = sparse(X);

X_K = cell(1,C);
Z_K = cell(1,C);
Lamda_K = cell(1,C);
leq_K = cell(1,C);


for k =  1 : C
    tempXk = zeros(ind_nk(View_num,k),sum(d));
    for i =  1 : View_num
        tempXk(ind_nk(i,k) - nk(i,k) + 1 : ind_nk(i,k),ind_d(i) - d(i) + 1 : ind_d(i)) = trainXk{i,k};
        tempXk = sparse(tempXk);
    end
    X_K{1,k} = tempXk;
    Z_K{1,k} = zeros(ind_nk(View_num,k),C);
    Lamda_K{1,k} = zeros(ind_nk(View_num,k),C);
    leq_K{1,k} = zeros(ind_nk(View_num,k),C);
end


Data.X = X;
Data.Y = Y;
Data.P = P;
Data.traindata = traindata;
Data.train_Label = train_Label;
Data.testdata = testdata;
Data.test_Label = test_Label;


Data.X_K = X_K;
Data.Z_K = Z_K;
Data.Lamda_K = Lamda_K;
Data.leq_K = leq_K;

Data.ind_d = ind_d;
Data.d = d;
Data.C = C;
Data.View_num = View_num;

save([dataset,'_',num2str(r_seed),'_','_V',num2str(view_missing_ratio),'_L',num2str(missing_ratio),'_Data.mat'],'Data')
toc


