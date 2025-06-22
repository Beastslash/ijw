--!strict

local types = require(script.Parent.types);

type Test = types.Test;
type TestCaseRunResult = types.TestCaseRunResult;

local TestRunner = {};

function TestRunner:findTestsFromAncestors(ancestors: {Instance}, fileNameMatchString: string): {Test}

  local tests: {Test} = {};

  for _, ancestor in ancestors do
    
    local descendants = ancestor:GetDescendants();

    for _, descendant in descendants do

      if not descendant:IsA("ModuleScript") or not descendant.Name:find(fileNameMatchString) then
        
        continue;

      end

      local testModule;

      local didSucceed, errorMessage = pcall(function()
        
        testModule = require(descendant) :: Test | {Test};

      end);
      
      if not didSucceed then

        warn(`Couldn't require {descendant:GetFullName()}: {errorMessage}`);
        continue;

      end

      if typeof(testModule) == "table" then

        if #testModule > 0 then

          for _, test in ipairs(testModule) do

            if typeof(test) == "table" and (test.type == "TestCase" or test.type == "TestSuite") then

              table.insert(tests, test);

            end

          end

        elseif (testModule :: Test).type == "TestCase" or (testModule :: Test).type == "TestSuite" then

          table.insert(tests, testModule :: Test);

        end;

      end

    end;

  end

  return tests;

end;

function TestRunner:runTests(tests: {Test}): {TestCaseRunResult}

  local results = {};

  for index, test in tests do

    if test.type == "TestSuite" then

      local resultGroup = test:run();
      for _, result in resultGroup do

        table.insert(results, result);

      end;

    elseif test.type == "TestCase" then

      table.insert(results, test:run());

    else

      error(`Expected TestSuite or TestCase at {index}.`);

    end

  end;

  return results;

end;

function TestRunner:displayResults(results: {TestCaseRunResult})

  print(`Results from running {#results} tests`);
  print("---");

  local passedCount = 0;
  for _, result in results do

    local identifier = `{if result.testSuite then `{result.testSuite.name} • ` else ""}{result.testCase.name}`;
    if result.didPass then

      passedCount += 1;
      print(`[✅] {identifier} • passed in {result.endTime - result.startTime} seconds`);
    
    else

      warn(`[❌] {identifier} • failed in {result.endTime - result.startTime} seconds\n{result.errorMessage}`);
    
    end

  end;

  local failedCount = #results - passedCount;
  print("---");
  print(`{passedCount} out of {#results} tests passed.`);
  print(`{failedCount} out of {#results} tests failed.`);
  print(`{passedCount / #results * 100}% coverage{if failedCount == 0 then "! 🎉" else "."}`);

end;

return TestRunner;