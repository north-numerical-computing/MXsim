


function result = BlockDot(A,B, MX)
 % A and B are vectors of length k, where k is the block size
 %formula from page 14 ocp spec

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
