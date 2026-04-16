classdef BlockConvertTests < matlab.unittest.TestCase
%% testBlockConvert
%
%  BlockConvert returns a struct with two fields:
%    result.scale  — scale factor (2^E)
%    result.vector — input vector in the element format, divided by scale

    properties
        MX              
    end
 
    methods (TestMethodSetup)
        function buildDefaultMX(testCase)
            testCase.MX.accumulator_opts.format = 's';
            testCase.MX.output_opts.format      = 's';
            testCase.MX.element_opts.format     = 'E4M3';
            testCase.MX.k                       = 5;
        end
    end
 

    methods (Access = private)
    function verifyBlockConvert(testCase, result, expectedScale, expectedVector)
        testCase.verifyEqual(result.scale,  expectedScale);
        testCase.verifyEqual(result.vector, expectedVector);
    end
    end


    % ======================================================================
    %  EDGE CASE TESTS 
    % ======================================================================
    methods (Test)
 
        function testNaNInputReturnsNaN(testCase)
            %% Any NaN in input should produce NaN scale and NaN vector
            input  = [1; NaN; 3; 4];
            result = BlockConvert(input, testCase.MX);
            testCase.verifyTrue(isnan(result.scale), ...
                'Expected NaN scale for NaN input');
            testCase.verifyTrue(all(isnan(result.vector)), ...
                'Expected all NaN vector for NaN input');
        end
 
        function testScaleIsPowerOfTwo(testCase)
            %% scale should always be an exact power of 2
            input  = [3.7; 0.5; 1.2; 2.9];
            result = BlockConvert(input, testCase.MX);
            log2scale = log2(result.scale);
            testCase.verifyEqual(log2scale, round(log2scale), ...
                'scale is not a power of 2');
        end
 
        function testOutputVectorLengthMatchesInput(testCase)
            %% result.vector should have the same length as the input
            input  = rand(16, 1);
            result = BlockConvert(input, testCase.MX);
            testCase.verifyEqual(numel(result.vector), numel(input));
        end
 
        function testE4M3SaturationClampsAt448(testCase)
            %% E4M3: values above 448 (after scaling) should be clamped.
            %  Use vector with max larger than 448 * scale and
            %  verify the output vector contains no values with magnitude > 448.
            testCase.MX.element_opts.format = 'E4M3';
            input  = [1e6; 1; 1; 1];
            result = BlockConvert(input, testCase.MX);
            testCase.verifyTrue(all(abs(result.vector) <= 448), ...
                'E4M3 value is above the maximum 448');
        end

        function testInfInputReturnsInfScale(testCase)
            %% Any Inf input wi;; produce and Inf scale
            input  = [1; Inf; 3; 4];
            result = BlockConvert(input, testCase.MX);
            testCase.verifyTrue(isinf(result.scale), ...
                'Expected Inf scale for Inf input');
        end


 
    end
 
    % ======================================================================
    %  HANDWRITTEN CASES 
    % ======================================================================
    methods (Test)
 
        function multiplesOf2E4M3(testCase)
            testCase.MX.element_opts.format = 'E4M3';
 
            input          = [2 4 6 8 10];   
            expectedScale  = [2^(-5)];    
            expectedVector = [64; 128; 192; 256; 320];    
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end
 
        function primesE4M3(testCase)
            testCase.MX.element_opts.format = 'E4M3';
 
            input          = [1 109 1453 3359 647];
            expectedScale  = [2^(3)];
            expectedVector = [0.125; 14; 176; 416; 80];
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end
 
        function mixedSignsE4M3(testCase)

            testCase.MX.element_opts.format = 'E4M3';
 
            input          = [-6011 4001 -17 1657 -3527];
            expectedScale  = [16];
            expectedVector = [-384; 256; -1; 104; -224];
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end
        
        function decimalsE5M2(testCase)

            testCase.MX.element_opts.format = 'E5M2';
 
            input          = [1.23 32.48 -89.33 24.67 67.67];
            expectedScale  = [2^(-9)];
            expectedVector = [640; 16384; -49152; 12288; 32768];
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end
        
        function uniformValuesE5M2(testCase)

            testCase.MX.element_opts.format = 'E5M2';
 
            input          = [ 3 3 3 3 3 ];
            expectedScale  = [ 2^(-14)];
            expectedVector = [49152; 49152; 49152; 49152; 49152 ];
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end


        function largeRangeE5M2(testCase)

            testCase.MX.element_opts.format = 'E5M2';
 
            input          = [ 0.0001 89000 0.003 1.2];
            expectedScale  = [2];
            expectedVector = [0.75*(2^(-14)); 40960; 0.001465; 0.625];
 
            result = BlockConvert(input, testCase.MX);
            testCase.verifyBlockConvert(result, expectedScale, expectedVector);
        end
 
 




    end
end
 