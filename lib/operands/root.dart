import 'expression.dart';
import 'operator.dart';
import 'dart:math' as math;

class Root extends Operator {
  Root(Expression base, Expression root) : super("root", base, root);

  @override
  num calculate() => math.pow(left.calculate(), (1 / right.calculate()));

  @override
  String toString() => right.calculate() != 2
      ? r"\sqrt[" + right.toString() + "]{" + left.toString() + "}"
      : r"\sqrt{" + left.toString() + "}";

  @override
  String get toAscii => right.calculate() != 2
      ? r"sqrt[" + right.toString() + "](" + left.toString() + ")"
      : r"sqrt(" + left.toString() + ")";
}
