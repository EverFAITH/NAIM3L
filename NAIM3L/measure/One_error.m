function OneError=One_error(Outputs,test_target)

err_cnt=0;
for i=1:size(Outputs,1)
    [~,idx]=max(Outputs(i,:));
    if test_target(i,idx)~=1
        err_cnt=err_cnt+1;
    end 
end
OneError=err_cnt/size(Outputs,1);

end
