--!strict

local LogService = game:GetService("LogService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IJW = require(ReplicatedStorage.IJW);
local TestRunner = IJW.TestRunner;

local tests = TestRunner:findTestsFromAncestors({ReplicatedStorage}, ".test");
local results = TestRunner:runTests(tests);

TestRunner:displayResults(results);

local logString = "";

for index, log in LogService:GetLogHistory() do
  
  logString ..= `{if index ~= 1 then "\n" else ""}{log.message}`;

end

return logString;