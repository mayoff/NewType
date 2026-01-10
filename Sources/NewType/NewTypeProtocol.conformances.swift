
extension NewTypeProtocol where Self: AdditiveArithmetic, RawValue: AdditiveArithmetic {

  // The standard library also defines a default `zero`, for `AdditiveArithmetic where Self: ExpressibleByIntegerLiteral`.
  // When `Self: ExpressibleByIntegerLiteral`, the compiler fails because my `zero` and the standard library's are tied for preference. I define a tie-breaker in another extension below.
  public static var zero: Self { .init(.zero) }

  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue + rhs.rawValue)
  }

  public static func += (lhs: inout Self, rhs: Self) {
    lhs.rawValue += rhs.rawValue
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue - rhs.rawValue)
  }

  public static func -= (lhs: inout Self, rhs: Self) {
    lhs.rawValue -= rhs.rawValue
  }
}

// This breaks the tie between the `zero` above and the `zero` in the standard library.
extension NewTypeProtocol where Self: AdditiveArithmetic, Self: ExpressibleByIntegerLiteral, RawValue: AdditiveArithmetic {
  public static var zero: Self { .init(.zero) }
}

extension NewTypeProtocol where Self: Comparable, RawValue: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension NewTypeProtocol where Self: CustomPlaygroundDisplayConvertible, RawValue: CustomPlaygroundDisplayConvertible {
  public var playgroundDescription: Any { rawValue.playgroundDescription }
}

extension NewTypeProtocol where Self: CustomStringConvertible, RawValue: CustomStringConvertible {
  public var description: String { rawValue.description }
}

extension NewTypeProtocol where Self: Decodable, RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    self.init(try RawValue(from: decoder))
  }
}

extension NewTypeProtocol where Self: Encodable, RawValue: Encodable {
  public func encode(to encoder: Encoder) throws {
    try rawValue.encode(to: encoder)
  }
}

extension NewTypeProtocol where Self: Equatable, RawValue: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

#if false
// Impossible as of Swift 6.2 because there's no way to forward the variadic argument list.
extension NewTypeProtocol where Self: ExpressibleByArrayLiteral, RawValue: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: RawValue.ArrayLiteralElement...) {
    self.init(RawValue(arrayLiteral: elements))
    // 🛑 Cannot convert value of type 'Self.ArrayLiteralElement...' to expected argument type 'Self.RawValue.ArrayLiteralElement'
  }

}
#endif

extension NewTypeProtocol where Self: ExpressibleByBooleanLiteral, RawValue: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: RawValue.BooleanLiteralType) {
    self.init(.init(booleanLiteral: value))
  }
}

#if false
// Impossible as of Swift 6.2; see ExpressibleByArrayLiteral.
extension NewTypeProtocol where Self: ExpressibleByDictionaryLiteral, RawValue: ExpressibleByDictionaryLiteral {
}
#endif

#if false
// Conflicts with the default init provided by the standard library where Self: ExpressibleByStringLiteral, StringLiteralType == ExtendedGraphemeClusterLiteralType.
extension NewTypeProtocol where Self: ExpressibleByExtendedGraphemeClusterLiteral, RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
  public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
    self.init(.init(extendedGraphemeClusterLiteral: value))
  }
}
#endif

extension NewTypeProtocol where Self: ExpressibleByFloatLiteral, RawValue: ExpressibleByFloatLiteral {
  public init(floatLiteral value: RawValue.FloatLiteralType) {
    self.init(.init(floatLiteral: value))
  }
}

extension NewTypeProtocol where Self: ExpressibleByIntegerLiteral, RawValue: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: RawValue.IntegerLiteralType) {
    self.init(.init(integerLiteral: value))
  }
}

extension NewTypeProtocol where Self: ExpressibleByNilLiteral, RawValue: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self.init(.init(nilLiteral: ()))
  }
}

extension NewTypeProtocol where Self: ExpressibleByStringInterpolation, RawValue: ExpressibleByStringInterpolation {
  public init(stringInterpolation value: RawValue.StringInterpolation) {
    self.init(.init(stringInterpolation: value))
  }
}

extension NewTypeProtocol where Self: ExpressibleByStringLiteral, RawValue: ExpressibleByStringLiteral {
  public init(stringLiteral value: RawValue.StringLiteralType) {
    self.init(.init(stringLiteral: value))
  }
}

#if false
// Conflicts with the default init provided by the standard library where Self: ExpressibleByExtendedGraphemeClusterLiteral, ExtendedGraphemeClusterLiteralType == UnicodeScalarLiteralType.
extension NewTypeProtocol where Self: ExpressibleByUnicodeScalarLiteral, RawValue: ExpressibleByUnicodeScalarLiteral {
  public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
    self.init(.init(unicodeScalarLiteral: value))
  }
}
#endif

extension NewTypeProtocol where Self: Hashable, RawValue: Hashable {
  public func hash(into hasher: inout Hasher) {
    rawValue.hash(into: &hasher)
  }
}

extension NewTypeProtocol where Self: Identifiable, RawValue: Identifiable {
  public var id: RawValue.ID { rawValue.id }
}

extension NewTypeProtocol where Self: LosslessStringConvertible, RawValue: LosslessStringConvertible {
  public init?(_ description: String) {
    guard let raw = RawValue(description) else { return nil }
    self.init(raw)
  }
}

extension NewTypeProtocol where Self: RawRepresentable {
  public init(rawValue: RawValue) {
    self.init(rawValue)
  }
}

extension NewTypeProtocol where Self: SetAlgebra, RawValue: SetAlgebra {
  public init() { self.init(RawValue()) }

  public func union(_ other: Self) -> Self { .init(rawValue.union(other.rawValue)) }

  public func intersection(_ other: Self) -> Self { .init(rawValue.intersection(other.rawValue)) }

  public func symmetricDifference(_ other: Self) -> Self { .init(rawValue.symmetricDifference(other.rawValue)) }

  public mutating func formUnion(_ other: Self) { rawValue.formUnion(other.rawValue) }

  public mutating func formIntersection(_ other: Self) { rawValue.formIntersection(other.rawValue) }

  public mutating func formSymmetricDifference(_ other: Self) { rawValue.formSymmetricDifference(other.rawValue) }

  public func subtracting(_ other: Self) -> Self { .init(rawValue.subtracting(other.rawValue)) }

  public func isSubset(of other: Self) -> Bool { rawValue.isSubset(of: other.rawValue) }

  public func isDisjoint(with other: Self) -> Bool { rawValue.isDisjoint(with: other.rawValue) }

  public func isSuperset(of other: Self) -> Bool { rawValue.isSuperset(of: other.rawValue) }

  public var isEmpty: Bool { rawValue.isEmpty }

  public mutating func subtract(_ other: Self) { rawValue.subtract(other.rawValue) }
}

extension NewTypeProtocol where Self: SetAlgebra, RawValue: SetAlgebra, Element == RawValue.Element {
  public func contains(_ member: Element) -> Bool { rawValue.contains(member) }

  @discardableResult
  public mutating func insert(_ new: Element) -> (inserted: Bool, memberAfterInsert: Element) {
    return rawValue.insert(new)
  }

  @discardableResult
  public mutating func remove(_ member: Element) -> Element? { rawValue.remove(member) }

  @discardableResult
  public mutating func update(with new: Element) -> Element? { rawValue.update(with: new) }

  public init<S>(_ sequence: S) where S: Sequence, Self.Element == S.Element {
    self.init(RawValue(sequence))
  }
}

extension NewTypeProtocol where Self: SetAlgebra, RawValue: SetAlgebra, Element == RawValue.Element, Element == ArrayLiteralElement {
  public init(arrayLiteral: Element...) {
    // Swift 6.2 doesn't provide a way to forward a variadic argument list so I delegate to the generic Sequence init instead.
    self.init(arrayLiteral)
  }
}

extension NewTypeProtocol where Self: Strideable, RawValue: Strideable, RawValue.Stride == RawValue {
  public func distance(to other: Self) -> Self {
    Self.init(rawValue.distance(to: other.rawValue))
  }

  public func advanced(by n: Self) -> Self {
    Self.init(rawValue.advanced(by: n.rawValue))
  }
}
