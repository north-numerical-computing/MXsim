% -----------------------------
% Test Relative Error vs Accumulator Format
% -----------------------------

clear; clc;


maxSize = 100;           % maximum vector length
maxVal = 57,344;             % scale of random numbers
Block = {16, 32, 128, 1000};  % block sizes to test
Accumulator = 's';            % fixed block size




% ----- LOG-SPACED VECTOR LENGTHS -----
nVals = round(logspace(0, log10(maxSize), 100));  % 50 n values from 10 to maxSize


MX.element_opts.format = 'E4M3';
MX.output_opts.format = 'd';
MX.accumulator_opts.format = 's';  

% ----- PREALLOCATE ERROR ARRAY -----
errors = zeros(length(nVals), numel(Block));


A = (maxVal) * rand(maxSize,1);
B = (maxVal) * rand(maxSize,1);

% ----- LOOP OVER ACCUMULATOR FORMATS -----
for bIdx = 1:numel(Block)
    MX.k = Block{bIdx};

    for nIdx = 1:length(nVals)
        n = nVals(nIdx);

        % Slice vectors for current n
        a = A(1:n);
        b = B(1:n);

       
        % Compute dot product using GeneralDot
        result = GeneralDot(a, b, MX);
        
        % Reference dot product (full double precision)
        trueVal = dot(a, b);

        
        if trueVal ~= 0
            errors(nIdx, bIdx) = abs(result - trueVal) / abs(trueVal);
        else
            errors(nIdx, bIdx) = NaN;
        end
    end
end

% ----- PLOT -----
figure; hold on;
colors = lines(numel(Block));
lineStyles = {'-', '--', ':'};
for bIdx = 1:numel(Block)
    semilogy(nVals, errors(:,bIdx), lineStyles{bIdx}, ...
        'Color', colors(bIdx,:), 'DisplayName', Block{bIdx});
end

xlabel('Vector length n');
ylabel('Relative error');
title('Relative Error of GeneralDot vs True Dot for Different Accumulator Formats');
legend('show');
grid on;


set(gca,'XScale','log'); % log scale for vector length