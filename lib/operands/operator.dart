import 'expression.dart';
import 'fillable.dart';

abstract class Operator extends Expression {
  Expression left;
  Expression right;
  String op; // operator

  Operator(this.op, this.left, this.right);

  @override
  String toString() => "${left.asLaTeX} $op ${right.asLaTeX}";

  bool get isFillable => left is Fillable || right is Fillable;
}
