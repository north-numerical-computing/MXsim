


function result = BlockDot(A,B, MX)
% BLOCKDOT Computes the dot product of two single MX format blocks.
%
%   RESULT = BLOCKDOT(A, B, MX) computes the dot product of two MX
%   blocks A and B, as defined in Section 6.1 of the OCP MX
%   specification. The shared scale factors of A and B are multiplied
%   together, and the sum of products of the private elements is
%   accumulated recursively in the precision specified by
%   MX.accumulator_opts. The result is rounded to the output precision
%   specified by MX.output_opts.
%
%   A and B must be structures in MX block format, with fields:
%     A.vector, B.vector - private element vectors of length MX.k.
%     A.scale,  B.scale  - shared scale factors.
%
%   MX is a configuration struct. If a field is not set, it defaults to
%   its value in MXE4M3. Use 'help cpfloat' to see available format
%   options.
%


 %multiply scale factors
 scaleFactor = (A.scale * B.scale);

 k = length(A.vector);
 dotProduct = 0; 

 %Calculate products
 for i = 1: k;
    product = A.vector(i) * B.vector(i);
    product = cpfloat(product, MX.accumulator_opts);
    dotProduct = dotProduct + product;
    dotProduct = cpfloat(dotProduct, MX);
    fmt = MX.accumulator_opts.format;
    
 end
 result = cpfloat((scaleFactor*dotProduct), MX.output_opts);
end
