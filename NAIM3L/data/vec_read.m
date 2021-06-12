function v = vec_read(filename)
% This function reads a vec binary file
%
% Usage: M = vec_read(filename)
%   filename    the input filename
%
% Returned values
%   M           the stored matrix
%
% Currently supported extensions:
%   fvec(s), dvec(s), hvec(s), hvec(s)32

% get extension to infer header and data classes
is_vec  = regexpi(filename,'^.*\.(\w*vec)s?([^\.]*)$','once');
is_sqf  = regexpi(filename,'^.*\.sqf$','once');
is_svec = false;
is_sfd  = regexpi(filename,'^.*\.sfd$','once');
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
        case 'svec32',
            is_svec=true;
            class_head='uint32';
            class_data='uint32';
        otherwise,
            error('Unknown file format %s',vec_ext);
    end
else
    class_head='uint32';
    class_data='single';
end

% open the file and count the number of descriptors
fid = fopen(filename, 'rb');

if is_svec,
    fread(fid, 1, 'int');
end
d = fread(fid, 1, class_head); % take the first header for histogram size
if is_svec,
    d=d+1;
end

% check the size of class_head and class_data
o=zeros(1,1,class_head);
s=whos('o');
bytes_head = s.bytes;
o=zeros(1,1,class_data);
s=whos('o');
bytes_data = s.bytes;

% get the number of rows in the file by looking at its size
fseek(fid, 0, 1);
n = ftell (fid) / (1 * bytes_head + d * bytes_data);
fseek(fid, 0, -1);

% pre-allocate memory for efficiency
v = zeros(n, d, class_data);

% read the elements
if is_svec,
    for i = 1:n
        v(i,1) = fread(fid, 1, 'int');
        d = fread(fid, 1, class_head);
        v(i,2:end) = fread(fid, d, class_data);
    end
else
    for i = 1:n
        d = fread(fid, 1, class_head);
        v(i,:) = fread(fid, d, class_data);
    end
end

% close the file
fclose(fid);

if ~isempty(is_sqf),
    v=sqform(v);
end

