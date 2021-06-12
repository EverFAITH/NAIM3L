function macro_F1 = Macro_F1(X,Y)

X(X<=0) = 0;
Y(Y<=0) = 0;
XandY = X&Y;

p=sum(XandY,1)./sum(X,1);
r=sum(XandY,1)./sum(Y,1);
f=2*p.*r./(p+r);
f(isnan(f))=0;
macro_F1 = mean(f);


end