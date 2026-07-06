% -----------------------------
% Test BlockMatMul Absolute Error
% Varying Matrix Size
% -----------------------------
clear; clc;
rng(500)
matSizes    = [4, 8, 16, 32, 64, 128, 256, 512, 1024];  % Square matrix dimensions
numTrials   = 5;       % Trials per size
maxVal      = 1;
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
% Derived from Blanchard et al. (2020), Thm. 4.2
% For matrix product C = AB computed via inner products:
% |C_hat - C| <= n * u * |A||B|
% where n is the inner dimension and u = 2^-24 for binary32.
% -----------------------------
u = 2^-24;   % Unit roundoff for binary32.
% -----------------------------
% PREALLOCATE
% -----------------------------
maxErrors = zeros(numel(matSizes), numel(elFormats));
maxBounds = zeros(numel(matSizes), numel(elFormats));
allPassed = true(numel(matSizes), numel(elFormats));
% -----------------------------
% LOOP OVER MATRIX SIZES
% -----------------------------
for sizeIdx = 1:numel(matSizes)
    n = matSizes(sizeIdx);

    for elIdx = 1:numel(elFormats)
        MX.element_opts.format = elFormats{elIdx};

        for trial = 1:numTrials
            % Generate random matrices.
            A = maxVal * (2*rand(n, n) - 1);
            B = maxVal * (2*rand(n, n) - 1);

            % ---------------------------------
            % OPTIONAL: REMOVE INPUT ERROR
            % ---------------------------------
            if removeInputError
                for col = 1:n
                    MXa = MXconvert(A(:,col), MX);
                    A(:,col) = MXconvert_inv(MXa, n);
                    MXb = MXconvert(B(:,col), MX);
                    B(:,col) = MXconvert_inv(MXb, n);
                end
            end

            % ---------------------------------
            % RUN BlockMatMul
            % ---------------------------------
            result  = BlockMatMul(A, B, MX);

            % Reference matrix product in double precision.
            trueVal = double(A) * double(B);

            % ---------------------------------
            % ABSOLUTE ERROR (max over all elements)
            % ---------------------------------
            absErr = max(max(abs(double(result) - trueVal)));

            % ---------------------------------
            % ERROR BOUND
            % Frobenius norm bound from Blanchard et al. (2020), Thm. 4.2.
            % |C_hat_ij - C_ij| <= n * u * sum_k(|A_ik| * |B_kj|)
            % ---------------------------------
            bound = max(max(n * u * (abs(A) * abs(B))));

            % ---------------------------------
            % TRACK WORST CASE ACROSS TRIALS
            % ---------------------------------
            if absErr > maxErrors(sizeIdx, elIdx)
                maxErrors(sizeIdx, elIdx) = absErr;
            end
            if bound > maxBounds(sizeIdx, elIdx)
                maxBounds(sizeIdx, elIdx) = bound;
            end

            % ---------------------------------
            % PASS/FAIL
            % ---------------------------------
            if absErr > bound
                allPassed(sizeIdx, elIdx) = false;
                fprintf('FAIL: size=%d, format=%s, trial=%d\n', ...
                    n, elFormats{elIdx}, trial);
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
        fprintf('Format %s: ALL sizes passed\n', elFormats{elIdx});
    else
        fprintf('Format %s: some sizes FAILED\n', elFormats{elIdx});
    end
end

% -----------------------------
% PLOT: Worst Case Error vs Bound
% across matrix sizes
% -----------------------------
figure;
for elIdx = 1:numel(elFormats)
    subplot(1, numel(elFormats), elIdx);
    hold on;

    semilogy(matSizes, maxBounds(:, elIdx), 'k--', 'DisplayName', 'Bound');
    semilogy(matSizes, maxErrors(:, elIdx), 'o-',  'DisplayName', 'Max Abs Error');

    xlabel('Matrix Size (n x n)');
    ylabel('Absolute Error (worst case)');
    title(sprintf('BlockMatMul Scaling: %s', elFormats{elIdx}));
    legend show;
    grid on;
    hold off;
end