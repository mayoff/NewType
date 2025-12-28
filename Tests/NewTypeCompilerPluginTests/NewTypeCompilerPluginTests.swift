import MacroTesting
import NewTypeCompilerPlugin
import Testing

@Suite(.macros(
  [NewTypeMacro.self],
  indentationWidth: .spaces(2),
  record: nil
))
struct NewTypeMacroTests {
  @Test func missing_generic_clause() {
    assertMacro {
      """
      @NewType struct MyMissing { }
      """
    } diagnostics: {
      """
      @NewType struct MyMissing { }
      ┬───────
      ╰─ 🛑 missing generic clause to specify RawValue
      """
    }
  }

  @Test func simple_Int_wrapper() {
    assertMacro {
      """
      @NewType<Int> struct MyInt {}
      """
    } expansion: {
      """
      struct MyInt {

        typealias RawValue = Int

        var rawValue: RawValue

        init(_ rawValue: RawValue) {
          self.rawValue = rawValue
        }
      }

      extension MyInt: NewTypeProtocol {
      }
      """
    }
  }

  @Test func enum_rejected() {
    assertMacro {
      """
      @NewType<Int> enum MyInt {}
      """
    } diagnostics: {
      """
      @NewType<Int> enum MyInt {}
                    ┬───
                    ╰─ 🛑 only a struct can be a NewType
      """
    }
  }

  @Test func public_accessor_copied() {
    assertMacro {
      """
      @NewType<Int> public struct MyInt {}
      """
    } expansion: {
      """
      public struct MyInt {

        public typealias RawValue = Int

        public var rawValue: RawValue

        public init(_ rawValue: RawValue) {
          self.rawValue = rawValue
        }
      }

      extension MyInt: NewTypeProtocol {
      }
      """
    }
  }
}
