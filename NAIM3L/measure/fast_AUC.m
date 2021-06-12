function result=fast_AUC(test_targets,score)

[~,I]=sort(score);  
M=0;N=0;  
for i=1:length(score)  
    if(test_targets(i)==1)  
        M=M+1;  
    else  
        N=N+1;  
    end  
end  
sigma=0;  
for i=M+N:-1:1  
    if(test_targets(I(i))==1)  
        sigma=sigma+i;  
    end  
end  
result=(sigma-(M+1)*M/2)/(M*N);  