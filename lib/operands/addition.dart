import 'expression.dart';
import 'operator.dart';

class Addition extends Operator {
  Addition(Expression left, Expression right) : super("+", left, right);

  @override
  num calculate() => left.calculate() + right.calculate();

  @override
  String toString() => "${left.toString()} + ${right.toString()}";
}
