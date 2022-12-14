abstract class Expression {
  /// Returns the expression in correctly represented latex
  get asLaTeX => toString();

  /// Returns the expression with ascii caracters. (In case latex representation fails)
  String get toAscii;

  /// Returns the value of the expression
  num calculate();

  /// Returns the expression in correctly represented latex
  @override
  String toString();
}
