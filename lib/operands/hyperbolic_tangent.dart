import 'expression.dart';
import 'operator_one.dart';

import '../math/hyperbolic_functions.dart';

class HyperbolicTangent extends OperatorOne {
  HyperbolicTangent(Expression value) : super("tanh", value);

  @override
  String toString() => r"\tanh(" + right.toString() + ")";

  @override
  num calculate() => tanh(right.calculate().toDouble());

  @override
  String get toAscii => "tanh(${right.toAscii})";
}
