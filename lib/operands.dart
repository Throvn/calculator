import 'dart:math' as math;

abstract class Expression {

  /// Returns the expression in correctly represented latex
  get asLaTeX {
    print(toString());
    return toString();
  }

  /// Returns the value of the expression
  num calculate();

  /// Returns the expression in correctly represented latex
  @override
  String toString();
}

abstract class Operator extends Expression {
  Expression left;
  Expression right;
  String op; // operator
  
  Operator(this.op, this.left, this.right);

  @override
  String toString() => "${left.asLaTeX} $op ${right.asLaTeX}";

  bool get isFillable => left is Fillable || right is Fillable;
}

class Addition extends Operator {
  Addition(Expression left, Expression right) : super("+", left, right);
  
  @override
  num calculate() => left.calculate() + right.calculate();

  @override
  String toString() => "${left.toString()} + ${right.toString()}";
}

class Fraction extends Operator {
  Fraction(Expression left, Expression right) : super("/", left, right);
  
  @override
  num calculate() => left.calculate() / right.calculate();

  @override
  String toString() => r"\frac{" + left.toString() + "}{" + right.toString() + "}";
}

class Subtraction extends Operator {
  Subtraction(Expression left, Expression right) : super("-", left, right);
  
  @override
  num calculate() => left.calculate() - right.calculate();

  @override
  String toString() => "${left.toString()} - ${right.toString()}";
}

class Multiplication extends Operator {
  Multiplication(Expression left, Expression right) : super("*", left, right);
  
  @override
  num calculate() => left.calculate() * right.calculate();

  @override
  String toString() => left.toString() + r"\cdot" + right.toString();
}

class Power extends Operator {
  Power(Expression base, Expression power) : super("^", base, power);
  
  @override
  num calculate() => math.pow(left.calculate(), right.calculate());

  @override
  String toString() => "${left.toString()}^{${right.toString()}}";
}

class Root extends Operator {
  Root(Expression base, Expression root) : super("root", base, root);
  
  @override
  num calculate() => math.pow(left.calculate(), (1/right.calculate()));

  @override
  String toString() => right.calculate() != 2 ? r"\sqrt[" + right.toString() + "]{" + left.toString() + "}" : r"\sqrt{" + left.toString() + "}";
}

/// Calculates the Logarithm of an arbitrary base.
/// Has a special latex representation if 
class Logarithm extends Operator {
  Logarithm(Expression base, Expression value) : super("sqrt", base, value);
  
  @override
  num calculate() => math.log(right.calculate()) / math.log(left.calculate());

  @override
  String toString() => left.runtimeType == EulersNumber ? r"\ln{(" + right.toString() + ")}" : r"\log_{" + left.toString() + "}(" + right.toString() + ")";
}

abstract class OperatorOne extends Expression {
  Expression right;
  String op; // operator

  OperatorOne(this.op, this.right);

  @override
  String toString() => "$op $right";
}

class Factorial extends OperatorOne {
  Factorial(Expression value) : super("!", value);

  @override
  String toString() => "${super.right}!";
  
  @override
  num calculate() => double.nan;
}

class Sign extends Subtraction {
  Sign(String sign, Expression value) : super(EmptyZero(), value);

  @override
  String toString() => "($op $right)";

  @override
  num calculate() => op == "+" ? right.calculate() : -right.calculate();
}

class Number extends Expression {
  String _displayValue = "";
  bool isDouble = false;
  num get sign => num.parse(_displayValue).sign;
  
  void switchSign({required bool positive}) => _displayValue = positive ? value.abs().toString() : (-value.abs()).toString();

  Number(num value) {
    _displayValue = value.toString();
  }

  num get value => num.parse(_displayValue);

  void setValue(String? newValue) => _displayValue = newValue ?? _displayValue;

  @override
  num calculate() {
    return value;
  }
  
  @override
  String toString() { 
    if (!isDouble) {
      if (value.isNegative) {
        return "(${value.toString()})"; 
      } 
      return value.toString(); 
    }

    if (value.toString().contains(".")) {
      return value.isNegative ? "(" + value.toString() + ")" : value.toString();
    }
  
    return value.isNegative ? "(" + value.toString() + ".)" : value.toString() + ".";
  }
}

class EulersNumber extends Number {
  EulersNumber(): super(math.e);

  @override
  String toString() => r"e";
}

class Pi extends Number {
  Pi(): super(math.pi);
  
  @override
  String toString() => r"\pi";
}

class Fillable extends Expression {

  @override
  String toString() => r"\square";
  
  @override
  num calculate() => 0.0;
}

class Brackets extends OperatorOne {
  Brackets(Expression right) : super("()", right);
  
  @override
  String toString() => r"\square";
  
  @override
  num calculate() => right.calculate();
}

class EmptyZero extends Expression {
  @override
  num calculate() => 0.0;

  @override
  String toString() => "";

}