% -----------------------------
% Test BlockDot Absolute Error
% Against Theoretical Bound
% -----------------------------
clear; clc;
rng(500) % Initialise RNG seed so results are reproducible

k         = 32;          % Block size (BlockDot operates on one block)
numTrials = 100000;      % Number of random tests
maxVal    = 1;
elFormats = {'E4M3', 'E5M2'};
removeInputError = 1;    % Set to 0 to keep binary64 inputs

% -----------------------------
% MX SETTINGS
% -----------------------------
MX.accumulator_opts.format = 's';
MX.output_opts.format      = 's';
MX.k                       = k;

% -----------------------------
% ERROR BOUND PARAMETERS
% Bound: |E_k| <= (k-1) * u * sum(|X^(A) X^(B) * P_i^(A) * P_i^(B)|)
% which equals (k-1) * u * sum(|a_i * b_i|) after input error removal.
% Higham, Accuracy and Stability of Numerical Algorithms, Eq. 4.4.
% -----------------------------
u = 2^(-24);   % Unit roundoff for binary32 (FP32 accumulator).

absErrors = zeros(numTrials, numel(elFormats));
bounds    = zeros(numTrials, numel(elFormats));
passed    = false(numTrials, numel(elFormats));

% -----------------------------
% GENERATE TEST DATA
% -----------------------------
A = maxVal * (2*rand(k, numTrials) - 1);
B = maxVal * (2*rand(k, numTrials) - 1);

% -----------------------------
% LOOP OVER ELEMENT FORMATS
% -----------------------------
for elIdx = 1:numel(elFormats)
    MX.element_opts.format = elFormats{elIdx};

    for trial = 1:numTrials
        % Extract vectors.
        a = A(:, trial);
        b = B(:, trial);

        % -----------------------------
        % REMOVE INPUT ERROR
        % -----------------------------
        if removeInputError
            MXa = MXconvert(a, MX);
            a   = MXconvert_inv(MXa, k);
            MXb = MXconvert(b, MX);
            b   = MXconvert_inv(MXb, k);
        end

        % -----------------------------
        % CONVERT TO MX BLOCKS
        % -----------------------------
        AMX = MXconvert(a, MX);
        BMX = MXconvert(b, MX);

        % BlockDot expects one block.
        result  = BlockDot(AMX{1}, BMX{1}, MX);

        % Reference dot product in binary64.
        trueVal = dot(double(a), double(b));

        % -----------------------------
        % ABSOLUTE ERROR AND BOUND
        % -----------------------------
        absErrors(trial, elIdx) = abs(double(result) - trueVal);
        bounds(trial, elIdx)    = (k - 1) * u * sum(abs(double(a) .* double(b)));
        passed(trial, elIdx)    = absErrors(trial, elIdx) <= bounds(trial, elIdx);
    end

    fprintf('Format %s: %d / %d trials passed (%.1f%%)\n', ...
        elFormats{elIdx}, sum(passed(:,elIdx)), numTrials, ...
        100 * mean(passed(:,elIdx)));
end

% -----------------------------
% PLOT: Absolute Error vs Bound
% -----------------------------
figure;
for elIdx = 1:numel(elFormats)
    subplot(1, numel(elFormats), elIdx);
    hold on;
    semilogy(1:numTrials, bounds(:, elIdx),    'k--', 'DisplayName', 'Bound');
    semilogy(1:numTrials, absErrors(:, elIdx), '.',  'DisplayName', 'Abs Error');
    xlabel('Trial');
    ylabel('Absolute Error');
    title(sprintf('BlockDot Error vs Bound: %s', elFormats{elIdx}));
    legend show;
    grid on;
    hold off;
end