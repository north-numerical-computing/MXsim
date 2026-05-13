function result = MXconvert(V,MX)
 V= V(:);
 k = MX.k;
 n = length(V);

 if mod(n,k) ~= 0
    padSize = k - mod(n, k);
    V = [V; zeros(padSize, 1)];
 end 

 n = length(V) / k; %n will be number of MX vectors

 %Separate k sized blocks
 V = reshape(V,k, []);

 for i = 1 : n 
    result{i} = BlockConvert(V(:,i), MX);
 end 
end