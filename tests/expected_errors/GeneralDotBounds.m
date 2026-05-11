% -----------------------------
% Test GeneralDot Absolute Error
% Varying Vector Length
% -----------------------------
clear; clc;
rng(500)
vecLengths  = [32, 64, 128, 256, 512, 1024];  % Must be multiples of k
numTrials   = 100;       % Trials per length
maxVal      = 1e4;
elFormats   = {'E4M3', 'E5M2'};
removeInputError = 1;
% -----------------------------
% MX SETTINGS
% -----------------------------
MX.accumulator_opts.format = 's';
MX.output_opts.format      = 's';
MX.k                       = 32;   % Block size
% -----------------------------
% ERROR BOUND PARAMETERS
% -----------------------------
u = 2^-24;   % Unit roundoff for binary32
k = MX.k;
% -----------------------------
% PREALLOCATE
% maxErrors and maxBounds store the worst case across trials
% for each (length, format) combination
% -----------------------------
maxErrors = zeros(numel(vecLengths), numel(elFormats));
maxBounds = zeros(numel(vecLengths), numel(elFormats));
allPassed = true(numel(vecLengths), numel(elFormats));
% -----------------------------
% LOOP OVER VECTOR LENGTHS
% -----------------------------
for lenIdx = 1:numel(vecLengths)
    totalLength = vecLengths(lenIdx);
    n = totalLength / k;   % Number of blocks

    % Generate test data at this length
    A = maxVal * (2*rand(totalLength, numTrials) - 1);
    B = maxVal * (2*rand(totalLength, numTrials) - 1);

    for elIdx = 1:numel(elFormats)
        MX.element_opts.format = elFormats{elIdx};

        for trial = 1:numTrials
            % Extract vectors
            a = A(:, trial);
            b = B(:, trial);

            % ---------------------------------
            % OPTIONAL: REMOVE INPUT ERROR
            % ---------------------------------
            if removeInputError
                MXa = MXconvert(a, MX);
                a   = MXconvert_inv(MXa, totalLength);
                MXb = MXconvert(b, MX);
                b   = MXconvert_inv(MXb, totalLength);
            end

            % ---------------------------------
            % RUN GeneralDot
            % ---------------------------------
            result  = GeneralDot(a, b, MX);

            
            trueVal = dot(double(a), double(b));

            % ---------------------------------
            % ABSOLUTE ERROR
            % ---------------------------------
            absErr = abs(double(result) - trueVal);

            % ---------------------------------
            % ERROR BOUND
            % term1: error summing n block results
            % term2: error within blocks
            % ---------------------------------
            blockDots = zeros(n, 1);
            for j = 1:n
                idx = (j-1)*k + 1 : j*k;
                blockDots(j) = dot(double(a(idx)), double(b(idx)));
            end

            term1 = (n - 1) * u * sum(abs(blockDots));
            term2 = (k - 1) * u * sum(abs(double(a) .* double(b)));
            bound = term1 + term2;

            % ---------------------------------
            % TRACK WORST CASE ACROSS TRIALS
            % ---------------------------------
            if absErr > maxErrors(lenIdx, elIdx)
                maxErrors(lenIdx, elIdx) = absErr;
            end
            if bound > maxBounds(lenIdx, elIdx)
                maxBounds(lenIdx, elIdx) = bound;
            end

            % ---------------------------------
            % PASS/FAIL
            % ---------------------------------
            if absErr > bound
                allPassed(lenIdx, elIdx) = false;
                fprintf('FAIL: length=%d, format=%s, trial=%d\n', ...
                    totalLength, elFormats{elIdx}, trial);
            end
        end
    end
end

% -----------------------------
% REPORT
% -----------------------------
fprintf('\n--- Summary ---\n');
for elIdx = 1:numel(elFormats)
    if all(allPassed(:, elIdx))
        fprintf('Format %s: ALL lengths passed\n', elFormats{elIdx});
    else
        fprintf('Format %s: some lengths FAILED\n', elFormats{elIdx});
    end
end

% -----------------------------
% PLOT: Worst Case Error vs Bound
% across vector lengths
% -----------------------------
figure;
for elIdx = 1:numel(elFormats)
    subplot(1, numel(elFormats), elIdx);
    hold on;

    semilogy(vecLengths, maxBounds(:, elIdx), 'k--', 'DisplayName', 'Bound');
    semilogy(vecLengths, maxErrors(:, elIdx), 'o-',  'DisplayName', 'Max Abs Error');

    xlabel('Vector Length');
    ylabel('Absolute Error (worst case)');
    title(sprintf('GeneralDot Scaling: %s', elFormats{elIdx}));
    legend show;
    grid on;
    hold off;
end