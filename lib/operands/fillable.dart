import 'expression.dart';

class Fillable extends Expression {
  @override
  String toString() => r"\square";

  @override
  num calculate() => 0.0;

  @override
  String get toAscii => "_";
}
