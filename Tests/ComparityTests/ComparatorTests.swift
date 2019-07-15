import XCTest

@testable import Comparity

private typealias Comparator = Comparity.Comparator

private enum Stubs {
    struct Box {
        let int: Int
        let string: String

        init(_ int: Int, _ string: String) {
            self.int = int
            self.string = string
        }
    }

    struct BigBox {
        let int: Int
        let string: String
        let double: Double

        init(_ int: Int, _ string: String, _ double: Double) {
            self.int = int
            self.string = string
            self.double = double
        }
    }
}

final class ComparatorTests: XCTestCase {
    static var allTests = [
        ("testCompare", testCompare),
        ("testParameter", testParameter),
        ("testParameterOpaque", testParameterOpaque),
        ("testChaining", testChaining),
    ]

    func testCompare() {
        let comparator = Comparator<Int> { lhs, rhs in
            guard lhs != rhs else {
                return .same
            }

            return lhs < rhs ? .ascending : .descending
        }

        XCTAssert(comparator.compare(0, 1) == .ascending)
        XCTAssert(comparator.compare(1, 0) == .descending)
        XCTAssert(comparator.compare(0, 0) == .same)
    }

    func testParameter() {
        let comparator = Comparator<Int> { $0 }

        XCTAssert(comparator.compare(0, 1) == .ascending)
        XCTAssert(comparator.compare(1, 0) == .descending)
        XCTAssert(comparator.compare(0, 0) == .same)
    }

    func testParameterOpaque() {
        let comparator = Comparator<Int>()

        XCTAssert(comparator.compare(0, 1) == .ascending)
        XCTAssert(comparator.compare(1, 0) == .descending)
        XCTAssert(comparator.compare(0, 0) == .same)
    }

    func testChaining() {
        let intComparator = Comparator<Stubs.Box> { $0.int }
        let stringComparator = Comparator<Stubs.Box> { $0.string }
        let comparator = Comparator(chain: [intComparator, stringComparator])

        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(1, "b")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(0, "b")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(1, "a")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(1, "b"), Stubs.Box(0, "a")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(0, "b"), Stubs.Box(0, "a")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(1, "b"), Stubs.Box(0, "b")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(0, "a")) == .same)
    }

    func testChainingAdd() {
        let intComparator = Comparator<Stubs.Box> { $0.int }
        let stringComparator = Comparator<Stubs.Box> { $0.string }
        let comparator = intComparator.chaining(stringComparator)

        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(1, "b")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(0, "b")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(1, "a")) == .ascending)
        XCTAssert(comparator.compare(Stubs.Box(1, "b"), Stubs.Box(0, "a")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(0, "b"), Stubs.Box(0, "a")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(1, "b"), Stubs.Box(0, "b")) == .descending)
        XCTAssert(comparator.compare(Stubs.Box(0, "a"), Stubs.Box(0, "a")) == .same)
    }

    func testChainingAddArray() {
        let intComparator = Comparator<Stubs.BigBox> { $0.int }
        let stringComparator = Comparator<Stubs.BigBox> { $0.string }
        let doubleComparator = Comparator<Stubs.BigBox> { $0.double }
        let comparator = intComparator.chaining([stringComparator, doubleComparator])

        XCTAssert(comparator.compare(Stubs.BigBox(0, "a", 0.0), Stubs.BigBox(1, "b", 0.0)) == .ascending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "a", 0.0), Stubs.BigBox(0, "b", 0.0)) == .ascending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "a", 0.0), Stubs.BigBox(0, "a", 0.1)) == .ascending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "a", 0.0), Stubs.BigBox(1, "a", 0.0)) == .ascending)
        XCTAssert(comparator.compare(Stubs.BigBox(1, "b", 0.0), Stubs.BigBox(0, "a", 0.0)) == .descending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "b", 0.0), Stubs.BigBox(0, "a", 0.0)) == .descending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "b", 0.1), Stubs.BigBox(0, "b", 0.0)) == .descending)
        XCTAssert(comparator.compare(Stubs.BigBox(1, "b", 0.0), Stubs.BigBox(0, "b", 0.0)) == .descending)
        XCTAssert(comparator.compare(Stubs.BigBox(0, "a", 0.0), Stubs.BigBox(0, "a", 0.0)) == .same)
    }

    func testInverted() {
        let comparator = Comparator<Int>().inverted()

        XCTAssert(comparator.compare(0, 1) == .descending)
        XCTAssert(comparator.compare(1, 0) == .ascending)
        XCTAssert(comparator.compare(0, 0) == .same)
    }
}
