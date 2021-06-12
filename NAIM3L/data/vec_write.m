function vec_write(filename,x)
% This function writes a vec binary file
%
% Usage: vec_write(filename,M)
%   filename    the input filename
%   M           the matrix to store
%
% Currently supported extensions:
%   sqf, fvec(s), dvec(s), hvec(s), hvec(s)32

% get extension to infer header and data classes
is_vec = regexpi(filename,'^.*\.(\w*vec)s?([^\.]*)$','once');
is_sqf = regexpi(filename,'^.*\.sqf$','once');
is_sfd = regexpi(filename,'^.*\.sfd$','once');
if isempty(is_vec) && isempty(is_sqf) && isempty(is_sfd),
    error('Unknown file extension');
end

% set correct class_head and class_data for this extension
if isempty(is_sqf) && isempty(is_sfd),
    vec_ext = regexprep(filename,'^.*\.(\w*vec)s?([^\.]*)$','$1$2','ignorecase');
    switch lower(vec_ext),
        case 'fvec',
            class_head='uint32';
            class_data='single';
        case 'dvec',
            class_head='uint32';
            class_data='double';
        case 'hvec',
            class_head='uint16';
            class_data='uint16';
        case 'hvec32',
            class_head='uint32';
            class_data='uint32';
        otherwise,
            error('Unknown file format %s',vec_ext);
    end
else
    class_head='uint32';
    class_data='single';
    if ~isempty(is_sqf),
        x=squareform(x);
    end
end

% cast matrix in correct class
cl = str2func(class_data);
x = cl(x);

% get matrix size
[ n d ]=size(x);

% check that dimensions are representable in class_head
if d>intmax(class_head),
    error('Output format is not able to store your matrix');
end

% open file
fid = fopen(filename,'wb');

for i=1:n,
  % write header
  c1 = fwrite(fid, d, class_head);
  % write the vector content
  c2 = fwrite(fid, x(i,:), class_data);
  if (c1 ~= 1)||(c2 ~= length(x(i,:))), error('Error writing file %s', filen); end
end

% close file
fclose(fid);
