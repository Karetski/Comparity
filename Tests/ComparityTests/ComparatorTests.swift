import Testament
import XCTest

@testable import Comparity

private typealias Comparator = Comparity.Comparator

final class ComparatorTests: XCTestCase {
    static var allTests = [
        ("testAreInIncreasingOrder", testAreInIncreasingOrder),
    ]

    func testAreInIncreasingOrder() throws {
        let comparator = Comparator<Int> { leftParameter, rightParameter in
            guard leftParameter != rightParameter else {
                throw Comparator<Int>.SameValueError(value: leftParameter)
            }

            return leftParameter < rightParameter
        }

        XCTAssertTrue(try assertErrorless(try comparator.areInIncreasingOrder(0, 1)))
        XCTAssertFalse(try assertErrorless(try comparator.areInIncreasingOrder(1, 0)))

        let error = try assertThrows(try comparator.areInIncreasingOrder(0, 0), with: Comparator<Int>.SameValueError.self)
        XCTAssertTrue(error.value == 0)
    }
}
