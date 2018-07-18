import XCTest

import ComparatorTests

var tests = [XCTestCaseEntry]()
tests += ComparatorTests.allTests()
XCTMain(tests)