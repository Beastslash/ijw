--!strict

local IJW = require(script.Parent.Parent);
local TestRunner = IJW.TestRunner;
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;

return {
  describe("TestRunner", {
    it("should find tests from ancestors with matching file names", function()

      local tests = TestRunner:findTestsFromAncestors({script.Parent}, ".test");

      expect(#tests).toBe(1);
      expect(tests[1].name).toBe("TestRunner");
      expect(tests[1].type).toBe("TestSuite");

    end);

    it("should return an empty table if no matching tests are found", function()

      local tests = TestRunner:findTestsFromAncestors({}, ".nonexistent");

      expect(#tests).toBe(0);

    end);
  })
};