% -----------------------------
% Test BlockDot Absolute Error
% Against Theoretical Bound
% -----------------------------
clear; clc;
rng(500) % Initialise RNG seed so results are reproducible
vecLength = 32;          % BlockDot operates on one block
numTrials = 100000;        % Number of random tests
maxVal    = 1e4;
elFormats = {'E4M3', 'E5M2'};
removeInputError = 1;    % Set to 0 to keep binary64 inputs
% -----------------------------
% MX SETTINGS
% -----------------------------
MX.accumulator_opts.format = 's';
MX.output_opts.format      = 's';
MX.k                       = vecLength;
% -----------------------------
% ERROR BOUND PARAMETERS
% Bound: |error| <= (n-1) * u * sum(|a_i * b_i|)
% Higham, Accuracy and Stability of Numerical Algorithms, Eq. 4.4
% -----------------------------
u = 2^-24;   % Unit roundoff for binary32 (single precision accumulator)
n = vecLength;

absErrors = zeros(numTrials, numel(elFormats));
bounds    = zeros(numTrials, numel(elFormats));
passed    = false(numTrials, numel(elFormats));
% -----------------------------
% GENERATE TEST DATA
% -----------------------------
A = maxVal * (2*rand(vecLength, numTrials) - 1);
B = maxVal * (2*rand(vecLength, numTrials) - 1);
% -----------------------------
% LOOP OVER ELEMENT FORMATS
% -----------------------------
for elIdx = 1:numel(elFormats)
    MX.element_opts.format = elFormats{elIdx};

    for trial = 1:numTrials
        % Extract vectors
        a = A(:, trial);
        b = B(:, trial);

        % ---------------------------------
        % REMOVE INPUT ERROR
        % ---------------------------------
        if removeInputError
            MXa = MXconvert(a, MX);
            a   = MXconvert_inv(MXa, vecLength);
            MXb = MXconvert(b, MX);
            b   = MXconvert_inv(MXb, vecLength);
        end

        % ---------------------------------
        % CONVERT TO MX BLOCKS
        % ---------------------------------
        AMX = MXconvert(a, MX);
        BMX = MXconvert(b, MX);

        % BlockDot expects one Block
        result = BlockDot(AMX{1}, BMX{1}, MX);


        trueVal = dot(double(a), double(b));

        % ---------------------------------
        % ABSOLUTE ERROR
        % ---------------------------------
        absErrors(trial, elIdx) = abs(double(result) - trueVal);

        % ---------------------------------
        % ERROR BOUND
        % (n-1) * u * sum(|a_i * b_i|)
        % Page 82, eq 4.4
        % ---------------------------------
        bounds(trial, elIdx) = (n - 1) * u * sum(abs(double(a) .* double(b)));

        % ---------------------------------
        % PASS/FAIL
        % ---------------------------------
        passed(trial, elIdx) = absErrors(trial, elIdx) <= bounds(trial, elIdx);
    end

    % ---------------------------------
    % REPORT RESULTS PER FORMAT
    % ---------------------------------
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
    semilogy(1:numTrials, absErrors(:, elIdx), '.', 'DisplayName', 'Abs Error');

    xlabel('Trial');
    ylabel('Absolute Error');
    title(sprintf('BlockDot Error vs Bound: %s', elFormats{elIdx}));
    legend show;
    grid on;
    hold off;
end