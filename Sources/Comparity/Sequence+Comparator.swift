
public extension Sequence {
    /// Returns the elements of the sequence, sorted using the given `Comparator`.
    ///
    /// - Parameter comparator: A `Comparator` that describes how elements should be compared during sorting.
    /// - Returns: Sorted array of sequence's elements.
    func sorted(by comparator: Comparator<Iterator.Element>) -> [Iterator.Element] {
        return sorted { (lhs, rhs) in
            switch comparator.compare(lhs, rhs) {
            case .ascending:
                return true
            case .descending, .same:
                return false
            }
        }
    }
}
