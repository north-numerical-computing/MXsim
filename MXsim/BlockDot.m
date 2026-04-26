


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

    disp (product);

    dotProduct = dotProduct + product;
    dotProduct = cpfloat(dotProduct, MX);

    disp(dotProduct);

    fmt = MX.accumulator_opts.format;


if isinf(dotProduct)
    switch fmt
        case 'E5M2'
            maxVal = 57344;              % largest finite E5M2 value
            
        case 'h'   % half precision
            maxVal = 65504;              % largest finite FP16 value
            
        case 's'   % single precision
            maxVal = realmax('single');  % largest finite FP32 value
            
        otherwise
            error('Unknown accumulator format: %s', fmt);
    end
    
    dotProduct = maxVal;
end
    
    


end
result = cpfloat((scaleFactor*dotProduct), MX.output_opts);


end
