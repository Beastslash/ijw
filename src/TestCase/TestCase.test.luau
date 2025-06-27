--!strict

local IJW = require(script.Parent.Parent);
local TestCase = IJW.TestCase;
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;

return {
  describe("TestCase", {
    it("should create a TestCase with the correct properties", function()
      
      local testCase = TestCase.new("Sample Test", function() end);

      expect(testCase.name).toBe("Sample Test");
      expect(testCase.type).toBe("TestCase");
      expect(testCase.run).toBeA("function");

    end);

    it("should run a successful test case and return a result", function()
      
      local testCase = TestCase.new("Sample Test", function() end);
      local result = testCase:run();
      
      expect(result).toBeA("table");
      expect(result.testCase).toBe(testCase);
      expect(result.didPass).toBe(true);
      expect(result.error).toBeNil();
      expect(result.durationSeconds).toBeA("number");

    end);

    it("should run a failed test case and return a result", function()
      
      local testCase = TestCase.new("Error Test", function()
        error("This is an error");
      end);
      local result = testCase:run();
      
      expect(result.didPass).toBe(false);
      expect(result.error).toBeA("string");
      expect(result.durationSeconds).toBeA("number");

    end);
  });
};