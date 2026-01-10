import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
public struct NewTypeCompilerPlugin: CompilerPlugin {
  public let providingMacros: [any Macro.Type] = [
    NewTypeMacro.self,
  ]

  public init() { }
}
