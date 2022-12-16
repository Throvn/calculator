import 'expression.dart';
import 'operator_one.dart';

import '../math/factorial.dart';

class Factorial extends OperatorOne {
  Factorial(Expression value) : super("!", value);

  @override
  String toString() => "${super.right}!";

  @override
  num calculate() {
    num result = right.calculate();
    if (result is int) {
      int counter = 1;
      for (var i = 1; i <= result.toInt(); i++) {
        counter *= i;
      }
      return counter;
    }
    return factorial(result.toDouble());
  }

  @override
  String get toAscii => "${super.right.toAscii}!";
}
