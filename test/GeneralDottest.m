% test_GeneralDot.m
% This script tests the GeneralDot() function with increasing vector sizes
% and writes results to an Excel spreadsheet.

% Define the maximum size to test
maxSize = 1000000;

% Preallocate results
results = table('Size', [maxSize 4], ...
                'VariableTypes', {'double','double','double', 'double'}, ...
                'VariableNames', {'VectorLength','double','single', 'half'});

for n = 1:maxSize
    % Generate random vectors of length n with max 
    %value 57344 (largest value in E5M2)
    a = 57344 * rand(n, 1);
    b = 57344 * rand(n, 1);

    
    % Call your GeneralDot function
    doubleresult = GeneralDot(a, b, MX);
    doubleresult = abs(doubleresult - dot(a,b));
    
    singleresult = GeneralDot(a, b, sing);
    singleresult = abs(singleresult - dot(a,b));

    r = GeneralDot(a,b,half);
    r = abs(r - dot(a,b));


    
    % Save results in the table
    results(n,:) = {n, singleresult,doubleresult, r};
end

% Write to Excel
filename = 'element.xlsx';
writetable(results, filename);

fprintf('Results written to %s\n', filename);
