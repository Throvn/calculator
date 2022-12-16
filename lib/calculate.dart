import 'operands/brackets.dart';
import 'operands/factorial.dart';
import 'operands/hyperbolic_cosine.dart';
import 'operands/hyperbolic_sine.dart';
import 'operands/hyperbolic_tangent.dart';
import 'operands/operator_one.dart';

import 'operands/cosine.dart';
import 'operands/eulers_number.dart';
import 'operands/expression.dart';
import 'operands/addition.dart';
import 'operands/fillable.dart';
import 'operands/fraction.dart';
import 'operands/logarithm.dart';
import 'operands/multiplication.dart';
import 'operands/number.dart';
import 'operands/operator.dart';
import 'operands/power.dart';
import 'operands/root.dart';
import 'operands/sine.dart';
import 'operands/subtraction.dart';
import 'operands/tangent.dart';

class Calculator {
  List<Calculation> history = [];

  // the normal expression.
  Calculation get expression =>
      history.isNotEmpty ? history.last : Calculation(Number(0));

  // the memory _expression (same format as [_expression])
  num memory = 0;

  /// Adds the result to the [memory] variable. If subtract == true,
  /// it subtracts the result from the value stored in [memory].
  void addResultToMemory({bool subtract = false}) {
    num result = expression.calculate();
    memory += (subtract ? -result : result);
  }

  /// Creates a class which can evaluate expressions,
  /// format the expression to latex and much more.
  Calculator(Expression startExpression) {
    history.add(Calculation(startExpression));
  }
}

class Calculation {
  Expression _expression;
  final List<Expression> _history = [];
  List<Expression> get history => _history;

  void setExpression(Expression expr) {
    // store previous calculation step in history
    _history.add(_expression);
    _expression = expr;
  }

  /// Jumps one calculation step back.
  void undo() {
    if (_history.isEmpty) {
      _expression = Number(0);
      return;
    }

    _expression = _history.last;
    _history.removeLast();
  }

  Operator? pointer;

  Calculation(this._expression);

  num calculate() {
    return _expression.calculate();
  }

  @override
  String toString() {
    return _expression.toString();
  }

  String get toAscii => _expression.toAscii;

  void reset() {
    setExpression(Number(0));
    pointer = null;
  }

  void insertNamedNumber(Number number) {
    if (pointer != null) {
      if (pointer!.left is Fillable) {
        pointer!.left = number;
        pointer = null;
      } else if (pointer!.right is Fillable) {
        pointer!.right = number;
        pointer = null;
      }
    } else if (_expression is Number && (_expression as Number).value == 0) {
      setExpression(number);
    }
  }

  void switchSign() {
    if (pointer == null) {
      if (_expression is Number) {
        // should always switch the sign, thats why the equality operator is changed.
        (_expression as Number)
            .switchSign(positive: (_expression as Number).sign < 0);
      } else if (_expression is Operator &&
          (_expression as Operator).right is Number) {
        Number currentNumber = (_expression as Operator).right as Number;
        currentNumber.switchSign(positive: currentNumber.sign < 0);
      }
    }
  }

  void insertNumber(Number number) {
    if (pointer != null) {
      if (pointer!.left is Fillable) {
        pointer!.left = number;
        pointer = null;
      } else if (pointer!.right is Fillable) {
        pointer!.right = number;
        pointer = null;
      }
    } else if (_expression is Number &&
        num.tryParse((_expression as Number).toString() + number.toString()) !=
            null) {
      (_expression as Number)
          .setValue((_expression as Number).toString() + number.toString());
    } else if (_expression is Operator &&
        (_expression as Operator).right is Number &&
        num.tryParse(((_expression as Operator).right as Number).toString() +
                number.toString()) !=
            null) {
      Number currentNumber = (_expression as Operator).right as Number;
      currentNumber.setValue(currentNumber.toString() + number.toString());
    }
  }

  void insertDot() {
    if (pointer == null) {
      print(_expression.runtimeType);
      if (_expression is Number &&
          double.tryParse((_expression as Number).toString() + ".0") != null) {
        (_expression as Number).isDouble = true;
      } else if (_expression is Operator &&
          (_expression as Operator).right is Number) {
        Number currentNumber = (_expression as Operator).right as Number;
        if (double.tryParse(currentNumber.toString() + ".0") != null) {
          currentNumber.isDouble = true;
        }
      }
    }
  }

  void insertOperand(String symbol) {
    //  we have to append on the end on the highest level
    if (pointer == null) {
      setExpression(symbolToOperand(symbol, _expression));
      if ((_expression as Operator).isFillable) {
        pointer = _expression as Operator;
      } else {
        pointer = null;
      }
    }
  }

  void makePercentage() {
    if (pointer == null) {
      if (_expression is Number) {
        (_expression as Number)
            .setValue(((_expression as Number).value / 100).toString());
      } else if (_expression is Operator &&
          (_expression as Operator).right is Number) {
        Number currentNumber = (_expression as Operator).right as Number;
        currentNumber.setValue((currentNumber.value / 100).toString());
      }
    }
  }

  void insertOnesidedOperand(String symbol) {
    setExpression(symbolToOperandOne(symbol, _expression));
  }

  void encloseBrackets() {
    setExpression(Brackets(_expression));
  }
}

OperatorOne symbolToOperandOne(String symbol, Expression expr) {
  switch (symbol) {
    case "!":
      return Factorial(expr);
    case "sin":
      return Sine(expr);
    case "cos":
      return Cosine(expr);
    case "tan":
      return Tangent(expr);
    case "sinh":
      return HyperbolicSine(expr);
    case "cosh":
      return HyperbolicCosine(expr);
    case "tanh":
      return HyperbolicTangent(expr);
    default:
      throw "Unknown Symbol";
  }
}

Operator symbolToOperand(String symbol, Expression expr) {
  switch (symbol) {
    case "+":
      return Addition(expr, Fillable());
    case "-":
      return Subtraction(expr, Fillable());
    case "/":
      return Fraction(expr, Fillable());
    case "*":
      return Multiplication(expr, Fillable());
    case "x^2":
      return Power(expr, Number(2));
    case "x^3":
      return Power(expr, Number(3));
    case "x^y":
      return Power(expr, Fillable());
    case "e^x":
      return Power(EulersNumber(), expr);
    case "10^x":
      return Power(Number(10), expr);
    case "1/x":
      return Fraction(Number(1), expr);
    case "sqrt":
      return Root(expr, Number(2));
    case "3rdrt":
      return Root(expr, Number(3));
    case "nthrt":
      return Root(expr, Fillable());
    case "ln":
      return Logarithm(EulersNumber(), expr);
    case "log10":
      return Logarithm(Number(10), expr);
    default:
      throw "Unknown Symbol";
  }
}
