function x = Normalize_row(x)
[n,~] = size(x);
for i = 1 : n
    if norm(x(i,:)) == 0
        x(i,:) = 0;
    else
    x(i,:) = x(i,:) / norm(x(i,:));    % Normalize by row
    end
end