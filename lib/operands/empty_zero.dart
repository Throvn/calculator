import 'expression.dart';

class EmptyZero extends Expression {
  @override
  num calculate() => 0.0;

  @override
  String toString() => "";

  @override
  String get toAscii => "";
}
