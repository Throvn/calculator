import 'expression.dart';
import 'operator_one.dart';

class Brackets extends OperatorOne {
  Brackets(Expression right) : super("()", right);

  @override
  String toString() => r"\square";

  @override
  num calculate() => right.calculate();

  @override
  String get toAscii => "(${right.toAscii})";
}
