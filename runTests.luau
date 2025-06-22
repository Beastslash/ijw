--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local IJW = require(ReplicatedStorage.IJW);
local TestRunner = IJW.TestRunner;

local tests = TestRunner:findTestsFromAncestors({ReplicatedStorage}, ".test");
local results = TestRunner:runTests(tests);

TestRunner:displayResults(results);

return results;