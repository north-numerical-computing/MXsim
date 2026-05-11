classdef GfloatStressTest < matlab.unittest.TestCase
% Runs ~1M element comparisons between BlockConvert and gfloat per format.
%
% N_BLOCKS blocks of size BLOCK_SIZE are generated with random values
% spanning a wide range of magnitudes. Each block is independently
% quantized by both BlockConvert (MATLAB) and quantize_block (gfloat),
% and every reconstructed element is compared.
%
% Expected runtime: ~1-2 minutes depending on hardware.
% Reduce N_BLOCKS to speed up during development.

    properties (Constant)
        N_BLOCKS   = 31250   % 31250 × 32 = 1 000 000 element comparisons
        BLOCK_SIZE = 32
        TOL        = 1e-5
    end

    properties
        GfBlock
        GfFormats
    end

    methods (TestClassSetup)
        function setup(testCase)
            repo_root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
            addpath(fullfile(repo_root, 'MXsim'));

            py_exec = fullfile(getenv('HOME'), 'miniconda3', 'envs', 'gfloat-env', 'bin', 'python');
            current = char(pyenv().Executable);
            if isempty(current)
                pyenv('Version', py_exec);
            elseif ~strcmp(current, py_exec)
                testCase.assertFail(sprintf( ...
                    ['Wrong Python loaded (%s).\n' ...
                     'Restart MATLAB and run:\n' ...
                     '  pyenv(''Version'', ''%s'')\n' ...
                     'before running these tests.'], current, py_exec));
            end

            testCase.GfBlock   = py.importlib.import_module('gfloat.block');
            testCase.GfFormats = py.importlib.import_module('gfloat.formats');
        end
    end

    % ======================================================================
    %  TEST CASES
    % ======================================================================
    methods (Test)

        function millionComparisonsE5M2(testCase)
            testCase.runStressTest('E5M2', 0);
        end

        function millionComparisonsE4M3(testCase)
            testCase.runStressTest('E4M3', 1);
        end

    end

    % ======================================================================
    %  HELPERS
    % ======================================================================
    methods (Access = private)

        function runStressTest(testCase, fmt, rng_seed)
            N  = testCase.N_BLOCKS;
            k  = testCase.BLOCK_SIZE;
            bfi = testCase.gfloatFormat(fmt);
            MX  = struct('element_opts', struct('format', fmt));

            % --- Generate random blocks over a wide range of magnitudes ---
            rng(rng_seed);
            log_scales = randi([-20, 20], 1, N);
            data = single(randn(k, N)) .* single(2 .^ log_scales);

            % --- MATLAB: BlockConvert on each block ---
            matlab_q = zeros(k, N);
            for i = 1:N
                r = BlockConvert(data(:,i), MX);
                matlab_q(:,i) = r.vector * r.scale;
            end

            % --- gfloat: quantize_block on each block ---
            gfloat_q = zeros(k, N);
            for i = 1:N
                py_block  = py.numpy.array(double(data(:,i))', ...
                                pyargs('dtype', 'float32'));
                py_out    = testCase.GfBlock.quantize_block( ...
                                bfi, py_block, testCase.GfBlock.compute_scale_amax);
                gfloat_q(:,i) = double(py_out.tolist())';
            end

            % --- Compare ---
            abs_err   = abs(matlab_q(:) - gfloat_q(:));
            n_mismatch = sum(abs_err > testCase.TOL);
            testCase.verifyEqual(n_mismatch, 0, ...
                sprintf('[%s] %d / %d elements exceeded tolerance %.0e (max err = %.3e)', ...
                        fmt, n_mismatch, k*N, testCase.TOL, max(abs_err)));
        end

        function bfi = gfloatFormat(testCase, fmt)
            switch fmt
                case 'E5M2', bfi = testCase.GfFormats.format_info_mxfp8_e5m2;
                case 'E4M3', bfi = testCase.GfFormats.format_info_mxfp8_e4m3;
                otherwise,   error('Unknown format: %s', fmt);
            end
        end

    end
end
