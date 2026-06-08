

function result = BlockConvert(V, MX) 
 %Takes inputs (Vector to convert, MX to specify format) 
 %based off algorithm on page 15 of OCP spec
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
    
  %Set X to largest power of 2 less than maximum value in vector
  [max_val, ~] = max(abs((V))); 
  E = floor(log2(max_val));

  %Divide by largest power of 2 in element datatype
  [~, opts] = cpfloat(pi, MX.element_opts);
  emax = opts.params(3);
  u = 2^-opts.params(1);
  E = E-emax;
  
  %Clamp exponent to max
  max_exponent = 2^(MX.scale_bits - 1) - 1;
  if E > max_exponent; 
     E = max_exponent; 
  end 

  %Set scale factor
  X = 2^E;

  %Divide all elements by the scale factor
  P = V / X ;
  
  % Manually handle OCP-correct maxVal for E4M3.
  if strcmpi(MX.element_opts.format, 'E4M3')
    if MX.element_opts.saturation
        % Clamp to OCP max of 448.
        P = max(-448, min(448, P));
    else
        % Values between 448 and 480 should overflow to infinity.
        P(P > 448) = inf;
        P(P < -448) = -inf;
    end
  end
 
  % Convert number of bits being used
  result.scale = X;
  result.vector = cpfloat(P, MX.element_opts); 
end


