import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct NewTypeCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NewTypeMacro.self,
    ]
}
