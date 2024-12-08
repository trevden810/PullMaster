PullMaster.test_reporter = {}

function PullMaster.test_reporter:Report(testName, result)
    print(string.format("|cFF33FF99Test %s:|r %s", testName, result and "Passed" or "Failed"))
end

function PullMaster.test_reporter:Initialize()
    self.tests = {}
    self.results = {}
end