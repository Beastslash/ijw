--!strict

export type TestCase = {
  type: "TestCase";
  name: string;
  run: TestCaseRunFunction;
};

export type TestCaseRunResult = {
  testCase: TestCase;
  testSuite: TestSuite?;
  didPass: boolean;
  error: unknown?;
  durationSeconds: number;
}

export type TestCaseCloneFunction = (self: TestCase, newName: string?, newCallback: TestCaseCallback?, newTestSuite: TestSuite?) -> TestCase;

export type TestCaseRunFunction = (testCase: TestCase, testSuite: TestSuite?) -> TestCaseRunResult;

export type TestSuiteRunFunction = (testSuite: TestSuite) -> {TestCaseRunResult};

export type TestCaseCallback = (self: TestCase) -> ();

export type TestSuiteAllHook = (testSuite: TestSuite) -> ();

export type TestSuiteEachHook = (testSuite: TestSuite, testCase: TestCase) -> ();

export type TestSuiteConfiguration = {
  beforeEach: TestSuiteEachHook?;
  afterEach: TestSuiteEachHook?;
  beforeAll: TestSuiteAllHook?;
  afterAll: TestSuiteAllHook?;
};

export type TestSuite = {
  type: "TestSuite";
  name: string;
  testCases: {TestCase};
  run: TestSuiteRunFunction;
};

export type Test = TestCase | TestSuite;

return {};