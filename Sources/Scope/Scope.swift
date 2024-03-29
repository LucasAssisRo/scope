// MARK: - Scope

public protocol Scope {}

public extension Scope {
    func `let`<Tranformed>(_ block: (Self) throws -> Tranformed) rethrows -> Tranformed { try block(self) }

    func takeIf(_ block: (Self) -> Bool) -> Self? { block(self) ? self : nil }
    func take<Property>(
        if keyPath: KeyPath<Self, Property>,
        _ block: (Property) -> Bool
    ) -> Self? {
        block(self[keyPath: keyPath]) ? self : nil
    }

    func takeIfNot(_ block: (Self) -> Bool) -> Self? { !block(self) ? self : nil }
    func take<Property>(
        ifNot keyPath: KeyPath<Self, Property>,
        _ block: (Property) -> Bool
    ) -> Self? {
        !block(self[keyPath: keyPath]) ? self : nil
    }

    func also(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var new = self
        try block(&new)
        return new
    }

    func also<Property>(set keyPath: WritableKeyPath<Self, Property>, to value: Property) -> Self {
        var new = self
        new[keyPath: keyPath] = value
        return new
    }
}

// MARK: - Scope + AnyObject

public extension Scope where Self: AnyObject {
    func also(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

    func also<Property>(set keyPath: ReferenceWritableKeyPath<Self, Property>, to value: Property) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}

// MARK: - Int + Scope

extension Int: Scope {}

// MARK: - Int64 + Scope

extension Int64: Scope {}

// MARK: - Double + Scope

extension Double: Scope {}

// MARK: - String + Scope

extension String: Scope {}

// MARK: - Array + Scope

extension Array: Scope {}

// MARK: - Dictionary + Scope

extension Dictionary: Scope {}

// MARK: - Result + Scope

extension Result: Scope {}
