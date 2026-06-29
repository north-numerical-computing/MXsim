function result = MXconvert_inv(MX_result, originalLength)
% MXCONVERT_INV Converts an MX format cell array back to standard floating-point.
%
%   RESULT = MXCONVERT_INV(MX_RESULT) converts a cell array of MX blocks
%   back to a standard floating-point column vector by multiplying each
%   block's private elements by its shared scale factor, then
%   concatenating the results.
%
%   RESULT = MXCONVERT_INV(MX_RESULT, ORIGINALLENGTH) additionally strips
%   any zero-padding added during conversion, returning a vector of length
%   ORIGINALLENGTH. This is useful when the original vector length was not
%   a multiple of MX.k.
%
%   MX_RESULT must be a cell array of MX block structures, each with fields:
%     MX_RESULT{i}.vector - private element vector of length MX.k.
%     MX_RESULT{i}.scale  - shared scale factor.
%

 n = length(MX_result);
 blocks = cell(n, 1);

 for i = 1 : n
    blocks{i} = backwardsConvert(MX_result{i});
 end

 % Concatenate all reconstructed blocks into one column vector
 result = vertcat(blocks{:});

 % Strip zero-padding if original length is known
 if nargin == 2 && ~isempty(originalLength)
    result = result(1 : originalLength);
 end
end

