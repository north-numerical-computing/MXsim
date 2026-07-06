classdef backwardsConvertTests < matlab.unittest.TestCase
 %% testBackwardsConvert
 %  tests for backwardsConvert.
 %
 %  backwardsConvert takes a single block struct with fields:
 %    a.scale - scalar power-of-2 scale factor
 %    a.vector - column vector
 %
 %  It returns:
 %    result = a.scale * a.vector
 methods (Test)
  % ==================================================================
  %  BASIC CORRECTNESS
  % ==================================================================
  function testScaleOne(testCase)
     %% Scale of 1 should return the vector unchanged
     a.scale  = 1;
     a.vector = [2; 4; 6; 8];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [2; 4; 6; 8]);
  end
  function testScaleHalf(testCase)
     %% Scale of 0.5 should halve every element
     a.scale  = 0.5;
     a.vector = [2; 4; 6; 8];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [1; 2; 3; 4]);
  end
  function testScalePowerOfTwo(testCase)
     %% Typical BlockConvert scale — power of 2
     a.scale  = 2^3;
     a.vector = [1; 2; 3; 4];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [8; 16; 24; 32]);
  end
  function testScaleNegativePowerOfTwo(testCase)
     %% Negative power of 2 scale (small values)
     a.scale  = 2^-4;
     a.vector = [16; 32; 48; 64];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [1; 2; 3; 4]);
  end
  % ==================================================================
  %  SIGN HANDLING
  % ==================================================================
  function testNegativeVector(testCase)
     %% Negative elements should be scaled correctly
     a.scale  = 2;
     a.vector = [-1; -2; -3; -4];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [-2; -4; -6; -8]);
  end
  function testMixedSignVector(testCase)
     %% Mixed positive and negative elements
     a.scale  = 4;
     a.vector = [-1; 2; -3; 4];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, [-4; 8; -12; 16]);
  end
  % ==================================================================
  %  EDGE CASES
  % ==================================================================
  function testZeroVector(testCase)
     %% Zero vector should return zeros regardless of scale
     a.scale  = 2^5;
     a.vector = zeros(4, 1);
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, zeros(4, 1));
  end
  function testZeroScale(testCase)
     %% Zero scale should return a zero vector
     a.scale  = 0;
     a.vector = [1; 2; 3; 4];
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, zeros(4, 1));
  end
  function testSingleElement(testCase)
     %% Single element block
     a.scale  = 0.25;
     a.vector = 8;
     result   = backwardsConvert(a);
     testCase.verifyEqual(result, 2);
  end
  % ==================================================================
  %  OUTPUT SHAPE
  % ==================================================================
  function testOutputIsColumnVector(testCase)
     %% Output should always be a column vector
     a.scale  = 1;
     a.vector = [1; 2; 3; 4];
     result   = backwardsConvert(a);
     testCase.verifyEqual(size(result, 2), 1, ...
        'Output should be a column vector (Nx1)');
  end
  function testOutputLengthMatchesVector(testCase)
     %% Output length should match the length of a.vector
     a.scale  = 2;
     a.vector = rand(32, 1);
     result   = backwardsConvert(a);
     testCase.verifyEqual(numel(result), 32);
  end
  % ==================================================================
  %  NaN HANDLING
  % ==================================================================
  function testNaNScaleReturnsNaN(testCase)
     % NaN scale should return a vector of NaNs.
     a.scale  = NaN;
     a.vector = [1; 2; 3; 4];
     result   = backwardsConvert(a);
     testCase.verifyTrue(all(isnan(result)), ...
        'Expected all NaNs for NaN scale.');
  end

  function testNaNInVectorReturnsNaN(testCase)
     % NaN in vector should propagate to output.
     a.scale  = 2;
     a.vector = [1; NaN; 3; 4];
     result   = backwardsConvert(a);
     testCase.verifyTrue(isnan(result(2)), ...
        'Expected NaN in output for NaN in vector.');
  end
 end
end