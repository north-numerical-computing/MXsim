classdef BlockDotTests < matlab.unittest.TestCase
 %% testBlockConvert
 %
 %  BlockDot takes two input vectors and returns a scalar value, using
 %  the formula from page 14 of the OCP MX spec.
 %
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
  function verifyBlockDot(testCase, result, expected)
     testCase.verifyEqual(result,  expected);
  end
 end
 % ======================================================================
 %  EDGE CASE TESTS
 % ======================================================================
 methods (Test)
  function NaNinVectorReturnsNaN(testCase)
     %% Any NaN in input in vector should produce NaN result
     input1.vector  = [1; NaN; 3; 4];
     input1.scale = [2];
     input2.vector = [1 2 3 4];
     input2.scale = [4];
     result = BlockDot(input1,input2, testCase.MX);
     testCase.verifyTrue(isnan(result), ...
        'Expected NaN for NaN in one input vector');
  end
  function NaNinScaleReturnsNaN(testCase)
     %% Any NaN input in scale should produce NaN result
     input1.vector  = [1; 389; 3; 4];
     input1.scale = [NaN];
     input2.vector = [1; 320; 3; 394];
     input2.scale = [4];
     result = BlockDot(input1,input2, testCase.MX);
     testCase.verifyTrue(isnan(result), ...
        'Expected NaN for NaN in a scale');
  end
 end
 % ======================================================================
 %  HANDWRITTEN CASES
 % ======================================================================
 methods (Test)
  function test1(testCase)
     % Hand computed dot product of two E4M3 blocks.
     testCase.MX.accumulator_opts.format = 'h';
     input1.vector = [0.125; 14; 176; 416];
     input1.scale  = [8];
     input2.vector = [-384; 256; -1; 104];
     input2.scale  = [16];
     expected      = 5967872;
     result        = BlockDot(input1, input2, testCase.MX);
     testCase.verifyEqual(result, expected);
  end

  function test2E5M2(testCase)
     testCase.MX.element_opts.format = 'E5M2';
     testCase.MX.k = 4;
     testCase.MX.accumulator_opts.format = 'h';
     input1.vector = [0.5; 1.0; 2.0; 4.0];
     input1.scale  = [4];
     input2.vector = [-0.5; 1.0; -2.0; 4.0];
     input2.scale  = [2];
     expected      = 102;
     result        = BlockDot(input1, input2, testCase.MX);
     testCase.verifyEqual(result, expected);
 end
 end
end 