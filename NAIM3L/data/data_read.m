clear;clc

datasets = { 'corel5k', 'espgame', 'iaprtc12'};
dataset = {'pascal07','mirflickr'};
sets     = { 'test', 'train' };
path = 'D:\Documents\Matlab\Data\';                                        %change to your own path

for db = 1 : length(datasets)
    ds = datasets{db};

    
    for s = 1 : length(sets)
        str = sets{s};

        DenseSift_data = vec_read([ds '_' str '_DenseSift.hvecs']);
        DenseHue_data = vec_read([ds '_' str '_DenseHue.hvecs']);
        Gist_data = vec_read([ds '_' str '_Gist.fvec']);
        Hsv_data = vec_read([ds '_' str '_Hsv.hvecs32']);
        Rgb_data = vec_read([ds '_' str '_Rgb.hvecs32']);
        Lab_data = vec_read([ds '_' str '_Lab.hvecs32']);
        
        eval([ds '_' str '_DenseSift_data' '=' 'DenseSift_data',';']); 
        eval([ds '_' str '_DenseHue_data' '=' 'DenseHue_data',';']); 
        eval([ds '_' str '_Gist_data' '=' 'Gist_data',';']); 
        eval([ds '_' str '_Hsv_data' '=' 'Hsv_data',';']); 
        eval([ds '_' str '_Rgb_data' '=' 'Rgb_data',';']);
        eval([ds '_' str '_Lab_data' '=' 'Lab_data',';']); 
        
        file_name1 = [ds '_' str '_DenseSift.mat'];
        file_name2 = [ds '_' str '_DenseHue.mat'];
        file_name3 = [ds '_' str '_Gist.mat'];
        file_name4 = [ds '_' str '_Hsv.mat'];
        file_name5 = [ds '_' str '_Rgb.mat'];
        file_name6 = [ds '_' str '_Lab.mat'];
        
        save([path ds '_mat\', file_name1], [ds '_' str '_DenseSift_data']);
        save([path ds '_mat\', file_name2], [ds '_' str '_DenseHue_data']);
        save([path ds '_mat\', file_name3], [ds '_' str '_Gist_data']);
        save([path ds '_mat\', file_name4], [ds '_' str '_Hsv_data']);
        save([path ds '_mat\', file_name5], [ds '_' str '_Rgb_data']);
        save([path ds '_mat\', file_name6], [ds '_' str '_Lab_data']);

        annot = logical(vec_read([ds '_' str '_annot.hvecs']));
        eval([ds '_' str '_Label' '=' 'annot',';']); 
        save([path ds '_mat\', ds '_' str '_Label.mat'], [ds '_' str '_Label']);
    end
end



for db = 1 : length(dataset)
    ds = dataset{db};

    for s = 1 : length(sets)
        str = sets{s};

        DenseSift_data = vec_read([ds '_' str '_DenseSift.hvecs']);
        DenseHue_data = vec_read([ds '_' str '_DenseHue.hvecs']);
        Gist_data = vec_read([ds '_' str '_Gist.fvec']);
        Hsv_data = vec_read([ds '_' str '_Hsv.hvecs32']);
        Rgb_data = vec_read([ds '_' str '_Rgb.hvecs32']);
        Lab_data = vec_read([ds '_' str '_Lab.hvecs32']);
        
        eval([ds '_' str '_DenseSift_data' '=' 'DenseSift_data',';']); 
        eval([ds '_' str '_DenseHue_data' '=' 'DenseHue_data',';']); 
        eval([ds '_' str '_Gist_data' '=' 'Gist_data',';']);
        eval([ds '_' str '_Hsv_data' '=' 'Hsv_data',';']); 
        eval([ds '_' str '_Rgb_data' '=' 'Rgb_data',';']);
        eval([ds '_' str '_Lab_data' '=' 'Lab_data',';']); 
        
        
        file_name1 = [ds '_' str '_DenseSift.mat'];
        file_name2 = [ds '_' str '_DenseHue.mat'];
        file_name3 = [ds '_' str '_Gist.mat'];
        file_name4 = [ds '_' str '_Hsv.mat'];
        file_name5 = [ds '_' str '_Rgb.mat'];
        file_name6 = [ds '_' str '_Lab.mat'];
        
        
        save([path ds '_mat\', file_name1], [ds '_' str '_DenseSift_data']);
        save([path ds '_mat\', file_name2], [ds '_' str '_DenseHue_data']);
        save([path ds '_mat\', file_name3], [ds '_' str '_Gist_data']);
        save([path ds '_mat\', file_name4], [ds '_' str '_Hsv_data']);
        save([path ds '_mat\', file_name5], [ds '_' str '_Rgb_data']);
        save([path ds '_mat\', file_name6], [ds '_' str '_Lab_data']);

        load([ds '_' str '_Label.txt']);
        save([path ds '_mat\', ds '_' str '_Label.mat'],[ds '_' str '_Label']);
    end
end 

