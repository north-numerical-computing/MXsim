

%test BlockConvert

V = [-1 0 2 3 -0.5 -0.1];
MX.scale.format = 'single';
MX.vector.format = 'E4M3';

expected.scale = 2;
expected.vector =   [-0.500000000000000 0 1 1.500000000000000 -0.250000000000000 -0.050781250000000];

try
    result = BlockConvert(V, MX);  % run your function
    disp('✅ BlockConvert ran successfully');
catch ME
    disp('❌ BlockConvert had an error:');
    disp(ME.message);
end

if any(result.scale ~= expected.scale | result.vector ~= expected.vector)

    disp('❌ BlockConvert had a computation error')
    
end

%test BlockDot

clear expected



