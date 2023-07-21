import 'expression.dart';
import 'operator.dart';

class Multiplication extends Operator {
  Multiplication(Expression left, Expression right) : super("*", left, right);

  @override
  num calculate() => left.calculate() * right.calculate();

  @override
  String toString() => left.toString() + r"\cdot" + right.toString();

  @override
  String get toAscii => "${left.toAscii} * ${right.toAscii}";
}
