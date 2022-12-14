import 'expression.dart';
import 'empty_zero.dart';
import 'subtraction.dart';

class Sign extends Subtraction {
  Sign(String sign, Expression value) : super(EmptyZero(), value);

  @override
  String toString() => "($op $right)";

  @override
  num calculate() => op == "+" ? right.calculate() : -right.calculate();
}
