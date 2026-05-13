function result = MXconvert_inv(MX_result, originalLength)

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

