function micro_F1 = Micro_F1(X,Y)

X(X<=0) = 0;
Y(Y<=0) = 0;
XandY = X&Y;

Precision=sum(XandY(:))/sum(X(:));
Recall=sum(XandY(:))/sum(Y(:));
micro_F1=2*Precision*Recall/(Precision+Recall);
if isnan(micro_F1)
    fprintf('micro F1 is NaN');
    micro_F1=0;
end


end