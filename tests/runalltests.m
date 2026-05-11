% ----- Add toolbox root to path-----
repo_root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(repo_root, 'MXsim'));
 
% ----- Discover all tests in this folder and subfolders -----
suite = matlab.unittest.TestSuite.fromFolder( ...
    fileparts(mfilename('fullpath')), ...
    'IncludingSubfolders', true);
 
% ----- Run -----
runner  = matlab.unittest.TestRunner.withTextOutput;
results = runner.run(suite);
 
% ----- Summary -----
fprintf('\n===== Test Summary =====\n');
disp(table(results));
fprintf('Passed: %d  |  Failed: %d  |  Incomplete: %d\n', ...
    sum([results.Passed]), sum([results.Failed]), sum([results.Incomplete]));
 