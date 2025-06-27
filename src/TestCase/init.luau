--!strict

local types = require(script.Parent.types);

type TestCase = types.TestCase;
type TestCaseRunFunction = types.TestCaseRunFunction;
type TestCaseRunResult = types.TestCaseRunResult;
type TestCaseCallback = types.TestCaseCallback;
type TestCaseCloneFunction = types.TestCaseCloneFunction;
type TestSuite = types.TestSuite;

local TestCase = {};

function TestCase.new(name: string, callback: TestCaseCallback): TestCase

  local run: TestCaseRunFunction = function(self, testSuite: TestSuite?)

    local startTime = os.clock();

    local didPass, executionError = pcall(function()
      
      callback(self);

    end);

    local endTime = os.clock();

    local testResult: TestCaseRunResult = {
      didPass = didPass;
      durationSeconds = endTime - startTime;
      error = executionError;
      testCase = self;
      testSuite = testSuite;
    };

    return testResult;

  end;
  
  local testCase = {
    name = name;
    type = "TestCase" :: "TestCase";
    run = run;
  };

  return testCase;

end;

return TestCase;