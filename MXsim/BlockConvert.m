

function result = BlockConvert(V, MX) 
arguments
    V   {mustBeNumeric}
    MX  = struct()
end

MX = merge_MX(MX);

V= V(:);


% If input contains any NaN, return NaN vector and NaN scale
if any(isnan(V)) 
    result.scale  = NaN;
    result.vector = NaN(size(V));
    return
end



    %Takes inputs (Vector to convert, MX to specify format)
    
    %based off algorithm on page 15 of OCP spec
    
    %Set X to largest power of 2 less than maximum value in vector
    [max_val, ~] = max(abs((V))); 
    E = floor(log2(max_val));
    [~, opts] = cpfloat(pi, MX.element_opts);
    emax = opts.params(3);
    u = 2^-opts.params(1);
    E = E-emax;

    max_exponent = 2^(MX.scale_bits - 1) - 1;
    if E > max_exponent; 
        E = max_exponent; 

    end 

    %Set scale factor
    X = 2^E;

    


    %Divide all elements by the scale factor
    P = V / X ;
    

    
    % Special treatment for the maximum value of fp8-e4m3, as per the
    % OFP8 format specification.
    if (strcmp(MX.element_opts.format, 'E4M3'))
        fmax = 448;
        P = min(abs(P), fmax) .* sign(V);
    end
    


    %Convert number of bits being used
    result.scale = X;
    result.vector = cpfloat(P, MX.element_opts); 
    

end


