function result = backwardsConvert(A)
% BACKWARDSCONVERT Converts a single MX block to standard floating-point.
%
%   RESULT = BACKWARDSCONVERT(A) multiplies the private elements of a
%   single MX block by its shared scale factor, returning a vector of
%   standard floating-point values.
%
%   A must be a structure in BlockConvert format, with fields:
%     A.vector - vector of private elements of length k.
%     A.scale  - shared scale factor for the block.
%

result = (a.scale*a.vector); 

end