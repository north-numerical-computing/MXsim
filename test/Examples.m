rng(500);

%Double precision GeneralDot

%Configure MX
MX.accumulator_opts.format = 'd'; %Using error free accumulation
MX.output_opts.format = 'd';
MX.element_opts.format = 'E5M2';
MX.k = 32;

%Choose two random vectors 
A = (rand(10^4,1) - 0.5) * 2 * 10^4;
B = (rand(10^4,1) - 0.5) * 2 * 10^4;


%Perform GeneralDot, which will return a double precision vector
disp(GeneralDot(A,B,MX));



%BlockMatMul example
% Generate two random matrices for BlockMatMul
C = (rand(8,8) - 0.5) * 2 * 10^4;
D = (rand(8,8) - 0.5) * 2 * 10^4;

disp(BlockMatMul(C,D,MX));