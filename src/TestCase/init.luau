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

    local didPass, errorMessage = xpcall(function()
      
      callback(self);

    end, debug.traceback);

    local endTime = os.clock();

    local testResult: TestCaseRunResult = {
      testCase = self;
      didPass = didPass;
      errorMessage = errorMessage;
      startTime = startTime;
      endTime = endTime;
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