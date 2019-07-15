
// MARK: - Base

/// Enumeration used to indicate the way compared items are ordered.
public enum ComparisonResult {
    case ascending
    case descending
    case same
}

/// Structure that describes comparison process between two items of type `Compared`.
public struct Comparator<Compared> {
    typealias CompareAction = (Compared, Compared) -> ComparisonResult

    /// Comparison action that returns the `ComparisonResult`.
    let compare: CompareAction

    /// Basic initializer where `CompareAction` closure needs to be provided.
    ///
    /// In general, it is enough to use one of existing convenient initializers so this shouldn't be used in most situations. But in case of some complex logic around the comparison process this is the right place to put it.
    ///
    /// - Parameter compare: Closure that contains comparison logic and returns the comparison result. It is recomended to use left-to-right rule while defining the comparison result.
    init(compare: @escaping CompareAction) {
        self.compare = compare
    }
}

// MARK: - Inverted

public extension Comparator {
    /// Inverts all comparison results. For example, in case where the result of initial comparator is `.ascending` it will transform the result to `.descending`.
    ///
    /// - Returns: New `Comparator` instance that inverts all comparison results.
    func inverted() -> Comparator<Compared> {
        return Comparator { (lhs, rhs) in
            switch self.compare(lhs, rhs) {
            case .ascending:
                return .descending
            case .descending:
                return .ascending
            case .same:
                return .same
            }
        }
    }
}

// MARK: - Parametric

public extension Comparator {
    /// Creates comparator that compares items based on provided parameter.
    /// - Parameter parameter: Closure used to get the parameter value.
    init<Parameter: Comparable>(parameter: @escaping (Compared) -> Parameter) {
        self.init { (lhs, rhs) in
            let lhsParameter = parameter(lhs)
            let rhsParameter = parameter(rhs)

            guard lhsParameter != rhsParameter else {
                return .same
            }

            return lhsParameter < rhsParameter ? .ascending : .descending
        }
    }
}

public extension Comparator where Compared: Comparable {
    /// Creates comparator that compares items based on its value. Compared item needs to conform to `Comparable` protocol.
    init() {
        self.init { $0 }
    }
}

// MARK: - Chaining

public extension Comparator {
    /// Composes multiple comparators instances into chain by *left to right* principle.
    ///
    /// - Parameter comparators: Array of `Comparator` instances used to create the chain.
    init(chain: [Comparator<Compared>]) {
        self.init { (lhs, rhs) in
            for comparator in chain {
                let result = comparator.compare(lhs, rhs)
                switch result {
                case .ascending, .descending:
                    return result
                case .same:
                    continue
                }
            }

            return .same
        }
    }

    /// Adds comparator to the chain.
    /// - Parameter comparator: `Comparator` instance used to be added to the chain.
    /// - Returns: New `Comparator` instance including chained comparator.
    func chaining(_ comparator: Comparator<Compared>) -> Comparator<Compared> {
        return Comparator(chain: [self, comparator])
    }

    /// Adds an array of comparators to the chain.
    /// - Parameter comparators: Array of `Comparator` instances used to be added to the chain.
    /// - Returns: New `Comparator` instance including chained comparators.
    func chaining(_ comparators: [Comparator<Compared>]) -> Comparator<Compared> {
        return Comparator(chain: [self] + comparators)
    }
}
