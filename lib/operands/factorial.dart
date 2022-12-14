import 'dart:math' as math;

import 'expression.dart';
import 'operator.dart';
import 'operator_one.dart';

class Factorial extends OperatorOne {
  Factorial(Expression value) : super("!", value);

  @override
  String toString() => "${super.right}!";

  @override
  num calculate() => double.nan;
}
