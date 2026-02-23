
%To Do
%Output results containing multiple blocks


function result = BlockConvert(V, MX) 

V= V(:);


    %Takes inputs (Vector to convert, MX to specify format)
    
    %based off algorithm on page 15 of OCP spec
    
    %Set X to largest power of 2 less than maximum value in vector
    [max_val, ~] = max(abs(V(~isnan(V)))); %Ignore NaNs
    E = floor(log2(max_val));
    
    [~, opts] = cpfloat(pi, MX.element_opts);
    emax = opts.params(3);
    u = 2^-opts.params(1);
    E = E-emax;

    %Set scale factor
    X = 2^E;

    %Divide all elements by the scale factor
    P = V / X ;
    
    %Convert numbers exceding max to max possible? 
    
    % Special treatment for the maximum value of fp8-e4m3, as per the
    % OFP8 format specification.
    if (strcmp(MX.element_opts.format, 'E4M3'))
        fmax = 2^emax*(2-4*u);
    else
        fmax = 2^emax*(2-2*u);
    end
    
     % Clamp magnitude and preserve sign
     P = min(abs(P), fmax) .* sign(V);

    %Convert number of bits being used
    result.scale = X;
    result.vector = cpfloat(P, MX.element_opts); 
end


