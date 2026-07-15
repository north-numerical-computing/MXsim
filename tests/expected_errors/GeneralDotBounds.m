% -----------------------------
% Test GeneralDot Absolute Error
% Against Theoretical Bound
% Varying Vector Length
% -----------------------------
clear; clc;
rng(500)

vecLengths = round(logspace(4,6,7));
numTrials  = 5;
maxVal     = 1;
elFormats  = {'E4M3', 'E5M2'};
removeInputError = 1;

k = 32;

% -----------------------------
% MX SETTINGS
% -----------------------------
MX.accumulator_opts.format = 's';
MX.output_opts.format      = 's';
MX.k                       = k;

u = 2^(-24);

% -----------------------------
% PREALLOCATE
% -----------------------------
maxErrors = zeros(numel(vecLengths), numel(elFormats));
maxBounds = zeros(numel(vecLengths), numel(elFormats));
meanErrors = zeros(numel(vecLengths), numel(elFormats));
meanBounds = zeros(numel(vecLengths), numel(elFormats));
allPassed = true(numel(vecLengths), numel(elFormats));

% -----------------------------
% LOOP OVER VECTOR LENGTHS
% -----------------------------
for lenIdx = 1:numel(vecLengths)
    n = vecLengths(lenIdx);

    trialErrors = zeros(numTrials, numel(elFormats));
    trialBounds = zeros(numTrials, numel(elFormats));

    for elIdx = 1:numel(elFormats)
        MX.element_opts.format = elFormats{elIdx};

        for trial = 1:numTrials
            % -----------------------------
            % GENERATE TEST DATA
            % -----------------------------
            a = maxVal * (2*rand(n, 1) - 1);
            b = maxVal * (2*rand(n, 1) - 1);

            % -----------------------------
            % REMOVE INPUT ERROR
            % -----------------------------
            if removeInputError
                MXa = MXconvert(a, MX);
                a   = MXconvert_inv(MXa, n);
                MXb = MXconvert(b, MX);
                b   = MXconvert_inv(MXb, n);
            end

            % -----------------------------
            % CONVERT TO MX
            % -----------------------------
            AMX = MXconvert(a, MX);
            BMX = MXconvert(b, MX);

            % -----------------------------
            % GeneralDot RESULT
            % -----------------------------
            result  = GeneralDot(a, b, MX);
            trueVal = dot(double(a), double(b));
            absErr  = abs(double(result) - trueVal);

            % -----------------------------
            % ERROR BOUND
            % Outer: (m-1) * u * sum_j(|BlockDot(A_j, B_j)|)
            % Inner: (k-1) * u * sum(|a_i * b_i|)
            % -----------------------------
            numBlocks = ceil(n / k);

            outerBound = 0;
            for j = 1:numBlocks
                outerBound = outerBound + abs(AMX{j}.scale * BMX{j}.scale *dot(double(AMX{j}.vector), double(BMX{j}.vector)));
            end
            outerBound = (numBlocks - 1) * u * outerBound;

            innerBound = (numBlocks - 1) * u *(k - 1) * u * sum(abs(double(a) .* double(b)));

            boundVal = outerBound + innerBound;

            % -----------------------------
            % RECORD
            % -----------------------------
            trialErrors(trial, elIdx) = absErr;
            trialBounds(trial, elIdx) = boundVal;

            if absErr > boundVal
                allPassed(lenIdx, elIdx) = false;
                fprintf('FAIL: n=%d, format=%s, trial=%d\n', ...
                    n, elFormats{elIdx}, trial);
            end
        end
    end

    % Aggregate across trials.
    maxErrors(lenIdx, :)  = max(trialErrors, [], 1);
    maxBounds(lenIdx, :)  = max(trialBounds, [], 1);
    meanErrors(lenIdx, :) = mean(trialErrors, 1);
    meanBounds(lenIdx, :) = mean(trialBounds, 1);
end

% -----------------------------

% -----------------------------
fprintf('\n--- Summary ---\n');
for elIdx = 1:numel(elFormats)
    if all(allPassed(:, elIdx))
        fprintf('Format %s: ALL vector lengths passed\n', elFormats{elIdx});
    else
        fprintf('Format %s: some vector lengths FAILED\n', elFormats{elIdx});
    end
end

% -----------------------------
% PLOT: Worst-Case + Mean Error vs Bound
% -----------------------------
colors = lines(numel(elFormats));

for elIdx = 1:numel(elFormats)
    figure;
    hold on;

    loglog(vecLengths, meanBounds(:, elIdx),  'ks-',  'DisplayName', 'Bound (mean)');
    loglog(vecLengths, maxBounds(:, elIdx),   'ks--', 'DisplayName', 'Bound (worst)');
    loglog(vecLengths, meanErrors(:, elIdx),  'o-',   'Color', colors(elIdx,:), 'DisplayName', 'Abs Error (mean)');
    loglog(vecLengths, maxErrors(:, elIdx),   'o--',  'Color', colors(elIdx,:), 'DisplayName', 'Abs Error (worst)');

    xlabel('Vector length n');
    ylabel('Absolute Error');
    title(sprintf('GeneralDot Error vs Bound: %s', elFormats{elIdx}));
    legend show;
    grid on;
    set(gca, 'XScale', 'log', 'YScale', 'log');
    axis square;          % square plot box
    hold off;
end