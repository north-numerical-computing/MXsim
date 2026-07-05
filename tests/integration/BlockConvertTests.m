classdef BlockConvertTests < matlab.unittest.TestCase
 %% testBlockConvert
 %
 %  BlockConvert returns a struct with two fields:
 %    result.scale - scale factor (2^E)
 %    result.vector - input vector in the element format, divided by scale
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
  function testScaleIsPowerOfTwo(testCase)
     %% Scale should always be an exact power of 2.
     input  = [3.7; 0.5; 1.2; 2.9];
     result = BlockConvert(input, testCase.MX);
     log2scale = log2(result.scale);
     testCase.verifyEqual(log2scale, round(log2scale), ...
        'Scale is not a power of 2.');
  end
  function testOutputVectorLengthMatchesInput(testCase)
     %% Result.vector should have the same length as the input.
     input  = rand(16, 1);
     result = BlockConvert(input, testCase.MX);
     testCase.verifyEqual(numel(result.vector), numel(input));
  end
  function testE4M3SaturationClampsAt448(testCase)
     %% E4M3: values above 448 after scaling should be clamped.
     testCase.MX.element_opts.format = 'E4M3';
     input  = [1e6; 1; 1; 1];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyTrue(all(abs(result.vector) <= 448), ...
        'E4M3 value is above the maximum 448.');
  end
  function testInfInputReturnsFiniteScale(testCase)
     %% An Inf input causes the scale to be clamped to its maximum finite value.
     input  = [1; Inf; 3; 4];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyTrue(isfinite(result.scale), ...
        'Expected finite scale for Inf input.');
  end
  function testNaNPreservedInVector(testCase)
     %% NaN positions should be preserved in the output vector.
     input = [NaN; 1; 2; 3];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyTrue(isnan(result.vector(1)), ...
        'Expected NaN in first position.');
     testCase.verifyFalse(isnan(result.vector(2)), ...
        'Expected non-NaN in second position.');
  end
  function testAllNaNReturnsNaNScale(testCase)
     %% All-NaN vector should return NaN scale and NaN vector.
     input = [NaN; NaN; NaN; NaN];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyTrue(isnan(result.scale), ...
        'Expected NaN scale for all-NaN input.');
  end
  function testZeroVectorReturnsScaleOne(testCase)
     %% Zero vector should return scale of 1 and zero vector.
     input = zeros(5, 1);
     result = BlockConvert(input, testCase.MX);
     testCase.verifyEqual(result.scale, 1, ...
        'Expected scale of 1 for zero vector.');
  end
  function testNaNInputReturnsNaN(testCase)
     %% A vector containing a NaN should have NaN in the output vector.
     input  = [1; NaN; 3; 4];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyTrue(any(isnan(result.vector)), ...
        'Expected NaN in output vector.');
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
     expectedVector = [0.75*(2^(-14)); 40960; 0.00146484375; 0.625];
     result = BlockConvert(input, testCase.MX);
     testCase.verifyBlockConvert(result, expectedScale, expectedVector);
  end
 end
end
