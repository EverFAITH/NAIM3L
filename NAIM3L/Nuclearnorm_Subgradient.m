function [Ns] = Nuclearnorm_Subgradient(W,t)
%SUB_GRADIENT Summary of this function goes here
%   Input: An m * n matrix W, t is threshold(usually a small number, 0.005 in our paper)
%   Output: The subgradient of nuclearnorm of W


A = W'* W;                 % if n < m
% A = W * W';              % if n > m
[V,S] = eig(A);
S(S < t) = 0;
S(S ~= 0) = 1./S(S ~= 0);
SS = sqrt(S);

U = W * V * SS;

U = U(:,diag(S) > 0);
U = fliplr(U);
V = V(:,diag(S) > 0);
V = fliplr(V);

Ns = U * V';

end
