import 'expression.dart';

abstract class OperatorOne extends Expression {
  Expression right;
  String op; // operator

  OperatorOne(this.op, this.right);

  @override
  String toString() => "$op $right";
}
