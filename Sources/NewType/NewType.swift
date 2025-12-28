
@attached(extension, conformances: NewTypeProtocol)
@attached(member, names: named(RawValue), named(rawValue), named(init))
public macro NewType<T>() = #externalMacro(module: "NewTypeCompilerPlugin", type: "NewTypeMacro")

public protocol NewTypeProtocol {
  associatedtype RawValue

  init(_ rawValue: RawValue)

  var rawValue: RawValue { get set }
}
