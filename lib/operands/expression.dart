abstract class Expression {
  /// Returns the expression in correctly represented latex
  get asLaTeX {
    print(toString());
    return toString();
  }

  /// Returns the value of the expression
  num calculate();

  /// Returns the expression in correctly represented latex
  @override
  String toString();
}
