import 'expression.dart';
import 'operator_one.dart';

import '../math/hyperbolic_functions.dart';

class HyperbolicCosine extends OperatorOne {
  HyperbolicCosine(Expression value) : super("cosh", value);

  @override
  String toString() => r"\cosh(" + right.toString() + ")";

  @override
  num calculate() => cosh(right.calculate().toDouble());

  @override
  String get toAscii => "cosh(${right.toAscii})";
}
