

function result = BlockConvert(V, MX) 
% BLOCKCONVERT Converts a single block vector to OCP MX format.
%
%   RESULT = BLOCKCONVERT(V, MX) converts the input vector V to MX
%   format using the configuration specified in MX. The conversion
%   follows the algorithm specified in Section 6.3 of the OCP MX
%   specification. The shared scale factor X is set to the largest
%   power of two less than or equal to the maximum absolute value in
%   V, divided by the largest power of two representable in the element
%   format. The elements are then divided by X and rounded to the
%   element format specified by MX.element_opts.
%
%   V must be a numeric vector of length MX.k. If V contains NaN values, 
%   the shared scale is computed from the non-NaN elements. NaN positions 
%   are preserved in the output vector. If all elements are NaN, 
%   RESULT.scale is set to NaN and RESULT.vector is set to a vector of NaNs.
%
%   For the E4M3 format, the maximum representable value is corrected
%   to 448 as specified by OCP, overriding the value of 480 computed
%   by CPFloat. If saturation is enabled, values exceeding 448 are
%   clamped. If saturation is disabled, values between 448 and 480
%   are mapped to infinity.
%
%   RESULT is a structure with fields:
%     RESULT.scale  - shared scale factor X.
%     RESULT.vector - vector of private elements of length MX.k.
%


 arguments
    V   {mustBeNumeric}
    MX  = struct()
 end

  MX = merge_MX(MX);
  V= V(:);
  
  % Handle zero vector.
  if all(V == 0)
     result.scale  = 1;
     result.vector = zeros(size(V));
     return
  end


  % Compute scale from finite non-NaN values only.
  finiteVals = V( ~isnan(V));
  if isempty(finiteVals)
     result.scale  = NaN;
     result.vector = NaN(size(V));
     return
  end
    
  %Set X to largest power of 2 less than maximum value in vector
  [max_val, ~] = max(abs((finiteVals))); 
  E = floor(log2(max_val));

  %Divide by largest power of 2 in element datatype
  [~, opts] = cpfloat(pi, MX.element_opts);
  emax = opts.params(3);
  u = 2^-opts.params(1);
  E = E-emax;
  
  %Clamp exponent to max
  max_exponent = 2^(MX.scale_bits - 1) - 1;
  if E > max_exponent 
     E = max_exponent; 
  end 

  %Set scale factor
  X = 2^E;

  %Divide all elements by the scale factor
  P = V / X ;
  
  % Manually handle OCP-correct maxVal for E4M3.
  if strcmpi(MX.element_opts.format, 'E4M3')
    nanPos = isnan(P);
    if MX.element_opts.saturation
        % Clamp to OCP max of 448.
        P = max(-448, min(448, P));
    else
        % Values between 448 and 480 should overflow to NaN.
        P(P > 448) = NaN;
        P(P < -448) = NaN;
    end
    P(nanPos) = NaN;  % Restore NaN positions
  end
 
  % Convert number of bits being used
  result.scale = X;
  result.vector = cpfloat(P, MX.element_opts); 
end


