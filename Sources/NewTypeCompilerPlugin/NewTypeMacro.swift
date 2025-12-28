import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NewTypeMacro: Macro { }

extension NewTypeMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    return [
      try ExtensionDeclSyntax("extension \(type): NewTypeProtocol { }"),
    ]
  }
}

extension NewTypeMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let macroIdentifier = node.attributeName.as(IdentifierTypeSyntax.self),
      let genericClause = macroIdentifier.genericArgumentClause,
      genericClause.arguments.count == 1,
      let rawType = genericClause.arguments.first
    else {
      throw DiagnosticsError(diagnostics: [
        .init(node: node, message: NewTypeDiagnostic(
          message: "missing generic clause to specify RawValue",
          diagnosticID: .init(domain: .domain, id: "missingGenericClause"),
          severity: .error
        ))
      ])
    }

    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw DiagnosticsError(diagnostics: [
        .init(node: declaration.introducer, message: NewTypeDiagnostic(
          message: "only a struct can be a NewType",
          diagnosticID: .init(domain: .domain, id: "notStructType"),
          severity: .error
        ))
      ])
    }

    let accessModifier = structDecl.modifiers
      .first { $0.name.tokenKind == .keyword(.public) }?
      .trimmed

    return [
      DeclSyntax("\(accessModifier) typealias RawValue = \(rawType)"),
      DeclSyntax("\(accessModifier) var rawValue: RawValue"),
      DeclSyntax("\(accessModifier) init(_ rawValue: RawValue) { self.rawValue = rawValue }"),
    ]
  }
}

extension String {
  static var domain: String { "NewType" }
}

struct NewTypeDiagnostic: DiagnosticMessage {
  var message: String
  var diagnosticID: MessageID
  var severity: DiagnosticSeverity
}
