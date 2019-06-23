import XCTest

@testable import Comparity

final class ComparatorTests: XCTestCase {
    private typealias Comparator = Comparity.Comparator

    func testAreInIncreasingOrder() {
        let comparator = Comparator<Int> { leftParameter, rightParameter in
            guard leftParameter != rightParameter else {
                throw Comparator<Int>.Error.same
            }

            return leftParameter < rightParameter
        }

        // TODO: Rewrite in more clean way with Testament.
        XCTAssertTrue((try? comparator.areInIncreasingOrder(0, 1)) ?? false)
        XCTAssertFalse((try? comparator.areInIncreasingOrder(1, 0)) ?? false)
        XCTAssertThrowsError(try comparator.areInIncreasingOrder(0, 0))
    }

    static var allTests = [
        ("testAreInIncreasingOrder", testAreInIncreasingOrder),
    ]
}
