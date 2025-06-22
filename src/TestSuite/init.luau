--!strict

local types = require(script.Parent.types);

type TestCase = types.TestCase;
type TestSuite = types.TestSuite;
type TestSuiteRunFunction = types.TestSuiteRunFunction;
type TestSuiteConfiguration = types.TestSuiteConfiguration;

local TestSuite = {};

function TestSuite.new(name: string, testCases: {TestCase} | () -> {TestCase}, configuration: TestSuiteConfiguration?): TestSuite

  local run: TestSuiteRunFunction = function(self)

    local results = {};

    if configuration and configuration.beforeAll then

      configuration.beforeAll(self);

    end;

    for _, testCase in self.testCases do

      if configuration and configuration.beforeEach then

        configuration.beforeEach(self, testCase);

      end;

      local result = testCase:run();

      if configuration and configuration.afterEach then

        configuration.afterEach(self, testCase);

      end;

      table.insert(results, result);

    end;

    if configuration and configuration.afterAll then

      configuration.afterAll(self);

    end;

    return results;

  end;

  local testSuite: TestSuite = {
    type = "TestSuite";
    name = name;
    testCases = if typeof(testCases) == "function" then testCases() else testCases;
    run = run;
  };

  return testSuite;

end;

return TestSuite;