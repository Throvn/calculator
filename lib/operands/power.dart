import 'expression.dart';
import 'operator.dart';
import 'dart:math' as math;

class Power extends Operator {
  Power(Expression base, Expression power) : super("^", base, power);

  @override
  num calculate() => math.pow(left.calculate(), right.calculate());

  @override
  String toString() => "${left.toString()}^{${right.toString()}}";

  @override
  String get toAscii => "${left.toAscii}^(${right.toAscii})";
}
