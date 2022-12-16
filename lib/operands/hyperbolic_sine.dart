import 'expression.dart';
import 'operator_one.dart';

import '../math/hyperbolic_functions.dart';

class HyperbolicSine extends OperatorOne {
  HyperbolicSine(Expression value) : super("sinh", value);

  @override
  String toString() => r"\sinh(" + right.toString() + ")";

  @override
  num calculate() => sinh(right.calculate().toDouble());

  @override
  String get toAscii => "sinh(${right.toAscii})";
}
