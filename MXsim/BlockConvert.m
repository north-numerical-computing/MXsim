

function result = BlockConvert(V, MX) 
arguments
    V       {mustBeNumeric}
    MX    = default_MX()
end 


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
    [max_val, ~] = max(abs((V))); %Ignore NaNs
    E = floor(log2(max_val));

    [~, opts] = cpfloat(pi, MX.element_opts);

    %Largest power of 2 in datatype, not just largest exponent 
    



    emax = opts.params(3);

    u = 2^-opts.params(1);
    E = E-emax;

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


    Format = MX.element_opts;
    Format.saturation = 1; 
    % Using saturated version will clamp the magnitudes to the maximum

    result.vector = cpfloat(P, Format); 
    
end


