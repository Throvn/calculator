import 'expression.dart';
import 'operator.dart';

class Fraction extends Operator {
  Fraction(Expression left, Expression right) : super("/", left, right);

  @override
  num calculate() => left.calculate() / right.calculate();

  @override
  String toString() =>
      r"\frac{" + left.toString() + "}{" + right.toString() + "}";
}
