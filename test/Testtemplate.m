% Template for testing

% Define the maximum size to test
maxSize = 1000000;

MX.element_opts.format = 'E5M2';
MX.accumulator_opts.format = 'd';
MX.k = 32;
MX.output_opts.format = 'd';

for n = 1:maxSize
    % Generate random vectors of length n with max 
    %value 57344 (largest value in E5M2)
    a = 0.1*rand(n, 1);
    b = 0.1*rand(n, 1);

    fprintf('vectors:')

    disp(a);
    disp(b);

    a = cpfloat(a, MX.element_opts);
    b = cpfloat(b, MX.element_opts);
    
    % Call your GeneralDot function
    doubleresult = GeneralDot(a, b, MX);
    doubleresult = abs(doubleresult - dot(a,b));

    fprintf('Difference between GeneralDot and built-in dot: %e\n', doubleresult);
    disp(doubleresult);

end

