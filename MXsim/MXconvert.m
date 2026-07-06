function result = MXconvert(V,MX)
% MXCONVERT Converts a vector of any length to OCP MX format.
%
%   RESULT = MXCONVERT(V, MX) converts the input vector V to MX format
%   using the configuration specified in MX. The vector is split into
%   blocks of length MX.k, each converted independently using
%   BLOCKCONVERT. If the length of V is not a multiple of MX.k, V is
%   zero-padded to the nearest multiple.
%
%   RESULT is a cell array of structures, where each element corresponds
%   to a single MX block with fields:
%     RESULT{i}.vector - vector of private elements of length MX.k.
%     RESULT{i}.scale  - shared scale factor for the block.
%
%   MX is a configuration struct. If a field is not set, it defaults to
%   its value in MXE4M3. Use 'help cpfloat' to see available format
%   options for MX.element_opts.



 V= V(:);
 k = MX.k;
 n = length(V);

 if mod(n,k) ~= 0
    padSize = k - mod(n, k);
    V = [V; zeros(padSize, 1)];
 end 

 n = length(V) / k; % n will be number of MX vectors.

 % Separate k sized blocks.
 V = reshape(V,k, []);

 for i = 1 : n 
    result{i} = BlockConvert(V(:,i), MX);
 end 
end