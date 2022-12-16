import 'dart:math' as math;

import 'expression.dart';
import 'operator_one.dart';

class Sine extends OperatorOne {
  Sine(Expression value) : super("sin", value);

  @override
  String toString() => r"\sin(" + right.toString() + ")";

  @override
  num calculate() => math.sin(right.calculate());

  @override
  String get toAscii => "sin(${right.toAscii})";
}
