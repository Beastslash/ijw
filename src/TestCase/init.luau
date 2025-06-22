--!strict

local types = require(script.Parent.types);

type TestCase = types.TestCase;
type TestCaseRunFunction = types.TestCaseRunFunction;
type TestCaseRunResult = types.TestCaseRunResult;
type TestCaseCallback = types.TestCaseCallback;
type TestCaseCloneFunction = types.TestCaseCloneFunction;
type TestSuite = types.TestSuite;

local TestCase = {};

function TestCase.new(name: string, callback: TestCaseCallback, testSuite: TestSuite?): TestCase

  local clone: TestCaseCloneFunction = function(self, newName: string?, newCallback: TestCaseCallback?, newTestSuite: TestSuite?)

    local newTestCase = TestCase.new(newName or self.name, newCallback or callback, newTestSuite or self.testSuite);
    return newTestCase;

  end;

  local run: TestCaseRunFunction = function(self)

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
    testSuite = testSuite;
    type = "TestCase" :: "TestCase";
    clone = clone;
    run = run;
  };

  return testCase;

end;

return TestCase;