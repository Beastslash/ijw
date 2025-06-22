--!strict

local TestSuite = require(script.TestSuite);
local TestCase = require(script.TestCase);
local TestRunner = require(script.TestRunner);
local expect = require(script.expect);

local IJW = {
  TestSuite = TestSuite;
  TestCase = TestCase;
  TestRunner = TestRunner;
  describe = TestSuite.new;
  expect = expect;
  it = TestCase.new;
  test = TestCase.new;
};

return IJW;