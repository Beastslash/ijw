--!strict

local IJW = require(script.Parent.Parent);
local TestSuite = IJW.TestSuite;
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;

return {
  describe("TestSuite", {
    it("should create a TestSuite with the correct properties", function()
      
      local testSuite = TestSuite.new("Sample Suite", function() return {} end);

      expect(testSuite.name).toBe("Sample Suite");
      expect(testSuite.type).toBe("TestSuite");
      expect(testSuite.run).toBeA("function");
      expect(testSuite.testCases).toBeA("table");

    end);

    it("should run all test cases and return results", function()
      
      local testCase1 = it("Test Case 1", function() end);
      local testCase2 = it("Test Case 2", function() end);
      local testSuite = TestSuite.new("Sample Suite", {testCase1, testCase2});
      local results = testSuite:run();

      expect(#results).toBe(2);
      expect(results[1].testSuite).toBe(testSuite);
      expect(results[2].testSuite).toBe(testSuite);

    end);

    it("should handle beforeAll, beforeEach, afterEach, and afterAll hooks", function()
      
      local beforeAllCalled = false;
      local beforeEachCalled = false;
      local afterEachCalled = false;
      local afterAllCalled = false;

      local configuration = {
        beforeAll = function() beforeAllCalled = true; end,
        beforeEach = function() beforeEachCalled = true; end,
        afterEach = function() afterEachCalled = true; end,
        afterAll = function() afterAllCalled = true; end,
      };

      local testCase1 = it("Test Case 1", function() end);
      local testCase2 = it("Test Case 2", function() end);
      local testSuite = TestSuite.new("Sample Suite", {testCase1, testCase2}, configuration);
      testSuite:run();

      expect(beforeAllCalled).toBe(true);
      expect(beforeEachCalled).toBe(true);
      expect(afterEachCalled).toBe(true);
      expect(afterAllCalled).toBe(true);

    end);
  })
};