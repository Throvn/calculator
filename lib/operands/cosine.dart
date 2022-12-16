import 'dart:math' as math;

import 'expression.dart';
import 'operator_one.dart';

class Cosine extends OperatorOne {
  Cosine(Expression value) : super("sin", value);

  @override
  String toString() => r"\cos(" + right.toString() + ")";

  @override
  num calculate() => math.cos(right.calculate());

  @override
  String get toAscii => "cos(${right.toAscii})";
}
