function instance_F1 = Instance_F1(X,Y)

X(X<=0) = 0;
Y(Y<=0) = 0;
XandY = X&Y;

p=sum(XandY,2)./sum(X,2);
r=sum(XandY,2)./sum(Y,2);
f=2*p.*r./(p+r);
f(isnan(f))=0;
instance_F1 = mean(f);


end