--!strict

local function expect(value: any)

  local function toExist(): ()

    if value == nil then

      error("Expected value to exist.", 2);

    end;

  end

  local function toBeNil(): ()

    if value ~= nil then

      error(`Expected value to be nil.`, 2);

    end;

  end;

  local function toBe(expectedValue: any): ()

    if value ~= expectedValue then

      error(`Expected value to be {expectedValue}.`, 2);

    end;

  end;

  local function toNotBe(expectedValue: any): ()

    if value == expectedValue then

      error(`Expected value to not be {expectedValue}.`, 2);

    end;

  end;

  local function toBeA(expectedType: string): ()

    if typeof(value) ~= expectedType then

      error(`Expected value to be of type {expectedType}, but got {typeof(value)}.`, 2);

    end;

  end;

  local function toBeTrue(): ()

    if value ~= true then 
      
      error(`Expected value to be true.`, 2);

    end;

  end;

  local function toBeTruthy(): ()

    if not value then
      
      error(`Expected value to be truthy.`, 2);

    end;

  end;

  local function toBeFalse(): ()

    if value ~= false then
      
      error(`Expected value to be false.`, 2);

    end;

  end;

  local function toBeFalsy(): ()

    if value then
      
      error(`Expected value to be falsy, but it was truthy.`, 2);

    end;

  end;
  
  local function toBeGreaterThan(expectedValue: number): ()

    if typeof(value) ~= "number" then

      error("Expected value to be a number.", 2);
    
    end;
    
    if value <= expectedValue then

      error(`Expected value to be greater than {expectedValue}.`, 2);

    end;

  end;

  local function toBeGreaterThanOrEqual(expectedValue: number): ()

    if typeof(value) ~= "number" then

      error("Expected value to be a number.", 2);
    
    end;
    
    if value < expectedValue then

      error(`Expected value to be greater than or equal to {expectedValue}.`, 2);

    end;

  end;

  local function toBeLessThanOrEqual(expectedValue: number): ()

    if typeof(value) ~= "number" then

      error("Expected value to be a number.", 2);
    
    end;
    
    if value > expectedValue then

      error(`Expected value to be less than or equal to {expectedValue}.`, 2);

    end;

  end;

  local function toBeLessThan(expectedValue: number): ()

    if typeof(value) ~= "number" then

      error("Expected value to be a number.", 2);
    
    end;
    
    if value >= expectedValue then

      error(`Expected value to be less than {expectedValue}, but got {value}.`, 2);

    end;

  end;

  local function toDeepEqual(expectedValue: any): ()

    if typeof(value) ~= typeof(expectedValue) then

      error("Expected value and expectedValue to be of the same type for deep equality check.", 2);

    end;
    
    if typeof(value) ~= "table" then

      if value ~= expectedValue then

        error(`Expected value to be deeply equal to {expectedValue}, but got {value}.`, 2);

      end;

      return; 

    end;

    local actualStack = {value};
    local expectedStack = {expectedValue};
    while #actualStack > 0 and #expectedStack > 0 do

      if #expectedStack ~= #actualStack then

        error(`Expected value to be deeply equal to {expectedValue}, but got {value}.`, 2);

      end;

      -- Check if both targets have the same key values.
      local expectedStackIndex = #expectedStack;
      local expectedStackTarget = expectedStack[expectedStackIndex];
      local actualStackIndex = #actualStack;
      local actualStackTarget = actualStack[actualStackIndex];
      local ignoredKeys = {};

      for expectedStackKey, expectedStackValue in expectedStackTarget do

        local actualStackValue = actualStackTarget[expectedStackKey];
        local shouldLoopBack = typeof(expectedStackValue) == "table";
        local isSameType = typeof(actualStackValue) ~= typeof(expectedStackValue);
        local isSameValue = expectedStackValue == actualStackValue;

        if shouldLoopBack then

          table.insert(actualStack, actualStackValue);
          table.insert(expectedStack, expectedStackValue);
          
        elseif not isSameType or not isSameValue then

          error("Value is not deeply equal to expected value.", 2);

        end;

        -- Don't check this key again in the next iteration.
        table.insert(ignoredKeys, expectedStackKey);

      end;

      -- Check for additional keys in the actual stack that are not in the expected stack.
      for possiblyUnexpectedKey in actualStackTarget do

        if not table.find(ignoredKeys, possiblyUnexpectedKey) then

          error("Value is not deeply equal to expected value.", 2);
          
        end;

      end;

      table.remove(actualStack, expectedStackIndex);
      table.remove(expectedStack, actualStackIndex);

    end;

  end;

  local function toError(): ()

    if typeof(value) ~= "function" then
      
      error(`Expected value to be a function, but it was a {typeof(value)} instead.`, 2);
    
    end;

    local didSucceed = pcall(value);
    if didSucceed then
      
      error("Expected function to throw an error, but it did not.", 2);

    end;

  end;

  local function toFinishBeforeSeconds(seconds: number): ()
    
    if typeof(value) ~= "function" then
      
      error(`Expected value to be a function, but it was a {typeof(value)} instead.`, 2);
    
    end;
    
    local continueEvent = Instance.new("BindableEvent");
    local timeoutTask = task.delay(seconds, function()
      
      continueEvent:Fire(false);

    end);

    local propagatedErrorMessage;

    local testTask = task.spawn(function()

      local didSucceed, errorMessage = pcall(value);

      if not didSucceed then

        propagatedErrorMessage = errorMessage;

      end;
        
      continueEvent:Fire(true);

    end);
    
    local didFinishOnTime = continueEvent.Event:Wait();

    if not didFinishOnTime then
      
      task.cancel(testTask);
      error(`Expected function to finish before {seconds} second{if seconds ~= 1 then "s" else ""}, but it timed out.`, 2);
    
    end;

    if propagatedErrorMessage then

      error(propagatedErrorMessage);

    end;
    
    task.cancel(timeoutTask);

  end;

  local functions = {
    toBe = toBe;
    toBeA = toBeA;
    toBeFalse = toBeFalse;
    toBeFalsy = toBeFalsy;
    toFinishBeforeSeconds = toFinishBeforeSeconds;
    toBeLessThan = toBeLessThan;
    toBeLessThanOrEqual = toBeLessThanOrEqual;
    toBeGreaterThan = toBeGreaterThan;
    toBeGreaterThanOrEqual = toBeGreaterThanOrEqual;
    toBeNil = toBeNil;
    toBeTrue = toBeTrue;
    toBeTruthy = toBeTruthy;
    toDeepEqual = toDeepEqual;
    toError = toError;
    toExist = toExist;
    toNotBe = toNotBe;
  };

  return functions;

end;

return expect;