
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
%   MX.scale_bits customises the bits in the shared scale
%
%   If a field is not set, it is defaulted to its value in MXE4M3
%
%   MX.element_opts, MX.output_opts and MX.accumulator_opts can be individually customised via 
%   CP float. Use command 'help cpfloat' to see all available 
%   options. 
%   
%   Example: Set Private element datatype to E5M2 by setting 
%   MX.vector.format = 'E5M2'
% 


arguments
    A       {mustBeNumeric}
    B       {mustBeNumeric}
    MX    = struct()
end 
MX = merge_MX(MX);



result = 0;



AMX = MXconvert(A,MX);
BMX = MXconvert(B,MX);

n = length(AMX);


% Compute the dot product for each block
for i = 1 : n 
    result = result + BlockDot(AMX{i}, BMX{i}, MX); 
    % Uses BlockDot function on each vector of k elements
    % And sums them together

    result = cpfloat(result, MX.output_opts);


end 




end