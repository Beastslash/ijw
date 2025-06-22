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

  local function toBeA(expectedType: string): ()

    if typeof(value) ~= expectedType then

      error(`Expected value to be of type {expectedType}, but got {typeof(value)}.`);

    end;

  end;

  local function toBeTruthy(): ()

    assert(value, "Expected value to be truthy, but it was falsy.");

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
      local expectedStackTarget = expectedStack[#expectedStack];
      local actualStackTarget = actualStack[#actualStack];
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

      table.remove(actualStack, #actualStack);
      table.remove(expectedStack, #expectedStack);

    end;

  end;

  local function toError(): ()

    assert(typeof(value) == "function", "Expected value to be a function.");

    local didSucceed = pcall(value);
    assert(not didSucceed, "Expected function to throw an error, but it did not.");

  end;

  local functions = {
    toBe = toBe;
    toBeA = toBeA;
    toBeFalsy = toBeFalsy;
    toBeLessThan = toBeLessThan;
    toBeLessThanOrEqual = toBeLessThanOrEqual;
    toBeGreaterThan = toBeGreaterThan;
    toBeGreaterThanOrEqual = toBeGreaterThanOrEqual;
    toBeNil = toBeNil;
    toBeTruthy = toBeTruthy;
    toDeepEqual = toDeepEqual;
    toError = toError;
    toExist = toExist;
  };

  return functions;

end;

return expect;