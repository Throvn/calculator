import 'expression.dart';
import 'operator.dart';
import 'eulers_number.dart';
import 'dart:math' as math;

/// Calculates the Logarithm of an arbitrary base.
/// Has a special latex representation if
class Logarithm extends Operator {
  Logarithm(Expression base, Expression value) : super("sqrt", base, value);

  @override
  num calculate() => math.log(right.calculate()) / math.log(left.calculate());

  @override
  String toString() => left.runtimeType == EulersNumber
      ? r"\ln{(" + right.toString() + ")}"
      : r"\log_{" + left.toString() + "}(" + right.toString() + ")";
}
