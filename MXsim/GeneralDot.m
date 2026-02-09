
%To do
%Take inputs in MX formats





function result = GeneralDot(A, B, MX)

%GENERALDOT section 6.2 OCP MX spec
%Calculates the OCP defined General Dot product in custom 
%precision. 
%
%   A and B must be vectors of equal length
%
%   The third argument (MX), allows for customisable precision 
%   and block size. 
% 
%   MX.element_opts corresponds to the data type of the Private elements
%   MX.k corresponds to the block size k, and must be set to 
%     a positive integer.
%   MX.accumulator_opts lets you customise the accumulation precision
%   MX.output_opts customises output precision
%
%   MX.element_opts, MX.output_opts and MX.accumulator_opts can be individually customised via 
%   CP float. Use command 'help cpfloat' to see all available 
%   options. 
%   
%   Example: Set Private element datatype to E5M2 by setting 
%   MX.vector.format = 'E5M2'
% 


A = A(:); %makes A and B row vectors regardless of input format
B = B(:);

k = MX.k; 
result = 0;
n = length(A);

% Pad the vectors A and B to make their lengths a multiple of k
if mod(n,k) ~= 0
    padSize = k - mod(n, k);
    A = [A; zeros(padSize, 1)];
    B = [B; zeros(padSize, 1)];

end

n = length(A) / k; %n will be number of MX vectors


%Separate k sized blocks
A = reshape(A,k, []);
B = reshape(B, k, []);



% Compute the dot product for each block
for i = 1 : n 
    result = result + BlockDot(A(:,i), B(:, i), MX); 
    % Uses BlockDot function on each vector of k elements
    % And sums them together

    result = cpfloat(result, MX.output_opts);


end 




end