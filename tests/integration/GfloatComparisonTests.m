classdef GfloatComparisonTests < matlab.unittest.TestCase
% Checks that BFPsimulator BlockConvert matches gfloat (Python) for MX formats.
%
% BlockConvert returns result.vector (scaled elements) and result.scale.
% Reconstructed value = result.vector * result.scale.
% gfloat quantize_block returns the reconstructed float values directly.
%
% Requires: ~/miniconda3/envs/gfloat-env
%   Setup:  conda create -n gfloat-env python=3.11
%           conda run -n gfloat-env pip install gfloat

    properties
        GfBlock
        GfFormats
    end

    methods (TestClassSetup)
        function setupPython(testCase)
            repo_root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
            addpath(fullfile(repo_root, 'MXsim'));

            py_exec = fullfile(getenv('HOME'), 'miniconda3', 'envs', 'gfloat-env', 'bin', 'python');
            testCase.assertTrue(isfile(py_exec), ...
                sprintf('gfloat conda env not found at %s', py_exec));

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

        function largeRangeE5M2(testCase)
            testCase.verifyGfloatMatch([0.0001, 89000, 0.003, 1.2], 'E5M2');
        end

        function multiplesOf2E4M3(testCase)
            testCase.verifyGfloatMatch([2, 4, 6, 8, 10], 'E4M3');
        end

        function decimalsE5M2(testCase)
            testCase.verifyGfloatMatch([1.23, 32.48, -89.33, 24.67, 67.67], 'E5M2');
        end

        function mixedSignsE4M3(testCase)
            testCase.verifyGfloatMatch([-6011, 4001, -17, 1657, -3527], 'E4M3');
        end

        function uniformValuesE5M2(testCase)
            testCase.verifyGfloatMatch([3, 3, 3, 3, 3], 'E5M2');
        end

        function primesE4M3(testCase)
            testCase.verifyGfloatMatch([1, 109, 1453, 3359, 647], 'E4M3');
        end

        function singleDecimalE5M2(testCase)
            testCase.verifyGfloatMatch([0.0015], 'E5M2');
        end

    end

    % ======================================================================
    %  HELPERS
    % ======================================================================
    methods (Access = private)

        function verifyGfloatMatch(testCase, V, fmt)
            V = double(V(:));

            % --- MATLAB BlockConvert ---
            MX = struct();
            MX.element_opts.format = fmt;
            r        = BlockConvert(V, MX);
            matlab_q = r.vector * r.scale;

            % --- gfloat ---
            bfi      = testCase.gfloatFormat(fmt);
            py_vals  = py.numpy.array(V', pyargs('dtype', 'float32'));
            py_q     = testCase.GfBlock.quantize_block( ...
                           bfi, py_vals, testCase.GfBlock.compute_scale_amax);
            gfloat_q = double(py_q.tolist())';

            % --- Scale check ---
            py_scale = double(testCase.GfBlock.compute_scale_amax( ...
                           bfi.etype.emax, py_vals));
            testCase.verifyEqual(r.scale, py_scale, 'AbsTol', 1e-10, ...
                sprintf('[%s] Scale mismatch: MATLAB=%.6g, gfloat=%.6g', ...
                        fmt, r.scale, py_scale));

            % --- Quantized value check ---
            testCase.verifyEqual(matlab_q, gfloat_q, 'AbsTol', 1e-6, ...
                sprintf('[%s] Quantized value mismatch for input %s', ...
                        fmt, mat2str(V')));
        end

        function bfi = gfloatFormat(testCase, fmt)
            switch fmt
                case 'E5M2'
                    bfi = testCase.GfFormats.format_info_mxfp8_e5m2;
                case 'E4M3'
                    bfi = testCase.GfFormats.format_info_mxfp8_e4m3;
                otherwise
                    error('Unknown format: %s. Supported: E5M2, E4M3', fmt);
            end
        end

    end
end
