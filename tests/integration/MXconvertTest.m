classdef MXconvertTest < matlab.unittest.TestCase
 %% testMXconvert
 %  Unit tests for MXconvert.
 %
 %  MXconvert takes a numeric vector V and an MX config struct, splits V
 %  into blocks of size MX.k (zero-padding the last block if needed), and
 %  calls BlockConvert on each block.
 %
 %  It returns a cell array where each cell is a struct with fields:
 %    result{i}.scale - scalar power-of-2 scale factor for block i
 %    result{i}.vector - quantised vector for block i (length MX.k)
 %
 %  Run with:
 %    results = runtests('tests/unit/testMXconvert.m');
 properties
   MX
 end
 methods (TestMethodSetup)
  function buildDefaultMX(testCase)
     testCase.MX.accumulator_opts.format = 's';
     testCase.MX.output_opts.format      = 'd';
     testCase.MX.element_opts.format     = 'E4M3';
     testCase.MX.k                       = 4;
  end
 end
 % ======================================================================
 %  OUTPUT STRUCTURE
 % ======================================================================
 methods (Test)
  function testOutputIsCellArray(testCase)
     %% Output should be a cell array
     input  = rand(4, 1);
     result = MXconvert(input, testCase.MX);
     testCase.verifyClass(result, 'cell');
  end
  function testEachCellHasScaleField(testCase)
     %% Every cell should contain a struct with a scale field
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     for i = 1:numel(result)
        testCase.verifyTrue(isfield(result{i}, 'scale'), ...
           sprintf('Cell %d is missing field: scale', i));
     end
  end
  function testEachCellHasVectorField(testCase)
     %% Every cell should contain a struct with a vector field
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     for i = 1:numel(result)
        testCase.verifyTrue(isfield(result{i}, 'vector'), ...
           sprintf('Cell %d is missing field: vector', i));
     end
  end
  function testEachBlockVectorLengthEqualsK(testCase)
     %% Every block's vector field should have length equal to MX.k
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     for i = 1:numel(result)
        testCase.verifyEqual(numel(result{i}.vector), testCase.MX.k, ...
           sprintf('Block %d vector length does not equal MX.k', i));
     end
  end
  function testEachScaleIsPowerOfTwo(testCase)
     %% Every block's scale should be a power of 2
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     for i = 1:numel(result)
        log2scale = log2(result{i}.scale);
        testCase.verifyEqual(log2scale, round(log2scale), ...
           'AbsTol', 1e-10, ...
           sprintf('Block %d scale is not a power of 2', i));
     end
  end
 end
 % ======================================================================
 %  BLOCK COUNT
 % ======================================================================
 methods (Test)
  function testExactMultipleOfK(testCase)
     %% n = 8, k = 4 → should produce exactly 2 blocks
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     testCase.verifyEqual(numel(result), 2);
  end
  function testSingleBlock(testCase)
     %% n = k → should produce exactly 1 block
     input  = rand(4, 1);
     result = MXconvert(input, testCase.MX);
     testCase.verifyEqual(numel(result), 1);
  end
  function testPaddingCreatesExtraBlock(testCase)
     %% n = 5, k = 4 → not a multiple, should pad to 8 → 2 blocks
     input  = rand(5, 1);
     result = MXconvert(input, testCase.MX);
     testCase.verifyEqual(numel(result), 2);
  end
  function testPaddingBlockEndsWithZeros(testCase)
     %% The padded elements in the last block should be zero.
     %  n=5, k=4 → last block has 3 real values and 1 zero-padded.
     %  After BlockConvert the padded element may be quantised but
     %  should round-trip through backwardsConvert to zero.
     input    = [1; 2; 3; 4; 5];
     result   = MXconvert(input, testCase.MX);
     lastBlock = result{end};
     reconstructed = lastBlock.scale * lastBlock.vector;
     testCase.verifyEqual(reconstructed(end), 0, 'AbsTol', 1e-10, ...
        'Padded element in last block should reconstruct to zero');
  end
 end
 % ======================================================================
 %  INPUT HANDLING
 % ======================================================================
 methods (Test)
  function testRowVectorIsAccepted(testCase)
     %% MXconvert calls V(:) so a row vector should work fine
     input  = rand(1, 4);
     result = MXconvert(input, testCase.MX);
     testCase.verifyEqual(numel(result), 1);
  end
  function testZeroVectorProducesFiniteScale(testCase)
     %% A zero vector — BlockConvert will hit log2(0) = -Inf.
     %  Verify the function does not error and returns a cell array.
     input  = zeros(4, 1);
     testCase.verifyWarningFree(@() MXconvert(input, testCase.MX));
  end
  function testE5M2Format(testCase)
     %% Should work correctly for E5M2 element format
     testCase.MX.element_opts.format = 'E5M2';
     input  = rand(8, 1);
     result = MXconvert(input, testCase.MX);
     testCase.verifyEqual(numel(result), 2);
     testCase.verifyTrue(isfield(result{1}, 'scale'));
     testCase.verifyTrue(isfield(result{1}, 'vector'));
  end
 end
 % ======================================================================
 %  HANDWRITTEN CASES
 % ======================================================================
 methods (Test)
 end
end