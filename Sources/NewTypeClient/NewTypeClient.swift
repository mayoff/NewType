import NewType

@NewType<Int> struct RowIndex:
  Hashable,
  CustomStringConvertible
{ }

@main
enum Main {
  static func main() {
    let r = RowIndex(123)
    print(r)
  }
}
