import 'dart:math' as math;

import 'expression.dart';
import 'operator_one.dart';

class Tangent extends OperatorOne {
  Tangent(Expression value) : super("tan", value);

  @override
  String toString() => r"\tan(" + right.toString() + ")";

  @override
  num calculate() => math.tan(right.calculate());

  @override
  String get toAscii => "tan(${right.toAscii})";
}
