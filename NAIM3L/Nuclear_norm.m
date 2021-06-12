function [a] = Nuclear_norm(X,t)
%  Summary of this function goes here
%  X is a m*n matrix, t is threshold(usually a small number, 0.005 in our paper)
A = X'* X;         % if n < m
% A = X * X';      % if n > m
[~,S] = eig(A);
S(S < t) = 0;
a = sum(sqrt(diag(S)));
% a = trace(sqrt(S));
end

