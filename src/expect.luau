--!strict

local function expect(value: any)

  local function toExist(): ()

    assert(value ~= nil, "Expected value to exist, but it was nil.");

  end

  local function toBeNil(): ()

    if value ~= nil then

      error(`Expected value to be nil, but it was {typeof(value)}.`);

    end;

  end;

  local function toBe(expectedValue: any): ()

    if value ~= expectedValue then

      error(`Expected value to be {expectedValue}, but got {value}.`);

    end;

  end;

  local function toNotBe(expectedValue: any): ()

    if value == expectedValue then

      error(`Expected value to not be {expectedValue}, but it is.`);

    end;

  end;

  local function toBeA(expectedType: string): ()

    if typeof(value) ~= expectedType then

      error(`Expected value to be of type {expectedType}, but got {typeof(value)}.`);

    end;

  end;

  local function toBeTrue(): ()

    if value ~= true then 
      
      error(`Expected value to be true, but it was {typeof(value)}.`);

    end;

  end;

  local function toBeTruthy(): ()

    assert(value, "Expected value to be truthy, but it was falsy.");

  end;

  local function toBeFalse(): ()

    if value ~= false then
      
      error(`Expected value to be false, but it was {typeof(value)}.`);

    end;

  end;

  local function toBeFalsy(): ()

    assert(not value, "Expected value to be falsy, but it was truthy.");

  end;
  
  local function toBeGreaterThan(expectedValue: number): ()

    assert(typeof(value) == "number", "Expected value to be a number.");
    
    if value <= expectedValue then

      error(`Expected value to be greater than {expectedValue}, but got {value}.`);

    end;

  end;

  local function toBeGreaterThanOrEqual(expectedValue: number): ()

    assert(typeof(value) == "number", "Expected value to be a number.");
    
    if value < expectedValue then

      error(`Expected value to be greater than or equal to {expectedValue}, but got {value}.`);

    end;

  end;

  local function toBeLessThanOrEqual(expectedValue: number): ()

    assert(typeof(value) == "number", "Expected value to be a number.");
    
    if value > expectedValue then

      error(`Expected value to be less than or equal to {expectedValue}, but got {value}.`);

    end;

  end;

  local function toBeLessThan(expectedValue: number): ()

    assert(typeof(value) == "number", "Expected value to be a number.");
    
    if value >= expectedValue then

      error(`Expected value to be less than {expectedValue}, but got {value}.`);

    end;

  end;

  local function toDeepEqual(expectedValue: any): ()

    assert(typeof(value) == typeof(expectedValue), "Expected value and expectedValue to be of the same type for deep equality check.");
    
    if typeof(value) ~= "table" then

      if value ~= expectedValue then

        error(`Expected value to be deeply equal to {expectedValue}, but got {value}.`);

      end;

      return; 

    end;

    local actualStack = {value};
    local expectedStack = {expectedValue};
    while #actualStack > 0 and #expectedStack > 0 do

      if #expectedStack ~= #actualStack then

        error(`Expected value to be deeply equal to {expectedValue}, but got {value}.`);

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

          error("Value is not deeply equal to expected value.");

        end;

        -- Don't check this key again in the next iteration.
        table.insert(ignoredKeys, expectedStackKey);

      end;

      -- Check for additional keys in the actual stack that are not in the expected stack.
      for possiblyUnexpectedKey in actualStackTarget do

        if not table.find(ignoredKeys, possiblyUnexpectedKey) then

          error("Value is not deeply equal to expected value.");
          
        end;

      end;

      table.remove(actualStack, expectedStackIndex);
      table.remove(expectedStack, actualStackIndex);

    end;

  end;

  local function toError(): ()

    assert(typeof(value) == "function", "Expected value to be a function.");

    local didSucceed = pcall(value);
    assert(not didSucceed, "Expected function to throw an error, but it did not.");

  end;

  local function toFinishBeforeSeconds(seconds: number): ()

    assert(typeof(value) == "function", "Expected value to be a function.");

    local continueEvent = Instance.new("BindableEvent");
    local timeoutTask = task.delay(seconds, function()

      continueEvent:Fire();

    end);

    local propagatedErrorMessage;

    local testTask = task.spawn(function()

      local didSucceed, errorMessage = xpcall(value, debug.traceback);

      if not didSucceed then

        propagatedErrorMessage = errorMessage;

      end;

      continueEvent:Fire();

    end);

    continueEvent.Event:Wait();

    if coroutine.status(testTask) ~= "dead" then

      task.cancel(testTask);
      error(`Expected function to finish before {seconds} second{if seconds ~= 1 then "s" else ""}, but it timed out.`);

    elseif coroutine.status(timeoutTask) ~= "dead" then

      task.cancel(timeoutTask);
    
    end;

    if propagatedErrorMessage then

      error(propagatedErrorMessage);

    end;

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