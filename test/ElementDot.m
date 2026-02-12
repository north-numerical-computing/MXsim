% -----------------------------
% Test Relative Error vs Element Format
% -----------------------------

clear; clc;
rng(500) % Initialise RNG seed so the results are reproducible


maxSize = 10^5;           % maximum vector length
maxVal = 10^4;             % scale of random numbers
elFormats = {'E4M3', 'E5M2', 'h'};  % element formats to test
blockSize = 32;            % fixed block size

removeInputError = 1; % Set this to 0 to keep the data in binary64.

% ----- LOG-SPACED VECTOR LENGTHS -----
nVals = round(logspace(4, log10(maxSize), 100));  % 50 n values from 10 to maxSize

MX.accumulator_opts = 'd';
MX.output_opts.format = 'd';
MX.k = blockSize;  % fixed block size

% ----- PREALLOCATE ERROR ARRAY -----
errors = zeros(length(nVals), numel(accFormats));


A = (maxVal) * rand(maxSize,1);
B = (maxVal) * rand(maxSize,1);

% ----- LOOP OVER ACCUMULATOR FORMATS -----
for elIdx = 1:numel(elFormats)
    MX.element_opts.format = elFormats{elIdx};

    for nIdx = 1:length(nVals)
        n = nVals(nIdx);

        % Slice vectors for current n
        a = A(1:n);
        b = B(1:n);

        % Convert to block Dot and back
        if removeInputError
            n = length(a);
            if mod(n,blockSize) ~= 0
                padSize = blockSize - mod(n, blockSize);
                a = [a; zeros(padSize, 1)];
                b = [b; zeros(padSize, 1)];
            end
            n = length(a) / blockSize;
            a = reshape(a, blockSize, []);
            b = reshape(b, blockSize, []);
            for i = 1 : n
                X = BlockConvert(a(:, i), MX);
                a(:, i) = X.scale * X.vector;
                X = BlockConvert(b(:, i), MX);
                b(:, i) = X.scale * X.vector;
            end
            a = a(:);
            b = b(:);
        end
       
        % Compute dot product using GeneralDot
        result = GeneralDot(a, b, MX);

        
        % Reference dot product (full double precision)
        trueVal = dot(a, b);

        
        if trueVal ~= 0
            errors(nIdx, elIdx) = abs(result - trueVal) / abs(trueVal);
        else
            errors(nIdx, elIdx) = NaN;
        end
    end
end

% ----- PLOT -----
figure; hold on;
colors = lines(numel(elFormats));
lineStyles = {'-', '--', ':'};
for elIdx = 1:numel(elFormats)
    semilogy(nVals, errors(:,elIdx), lineStyles{elIdx}, ...
        'Color', colors(elIdx,:), 'DisplayName', elFormats{elIdx});
end

xlabel('Vector length n');
ylabel('Relative error');
title('Relative Error of GeneralDot vs True Dot for Different Element Formats');
legend('show');
grid on;

set(gca,'XScale','log'); % log scale for vector length