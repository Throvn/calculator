import 'package:calendar/operands.dart';

class Calculator {
  List<Calculation> history = [];

  // the normal expression.
  // Has a special format, to be easily convertable
  // to latex and normal (function_tree) math.
  Calculation get expression => history.isNotEmpty ? history.last : Calculation(Number(0));

  // the memory _expression (same format as [_expression])
  Expression memory = Number(0);

  /// Adds the result to the [memory] variable. If subtract == true,
  /// it subtracts the result from the value stored in [memory].
  void addResultToMemory({bool subtract = false}) {
    // if (expression.isValid()) {
      // double result = expression.getResultAsDouble();
      // memory += (subtract ? -result : result);
    // } else {
    //   print("No valid result to add to memory");
    // }
  }

  /// Creates a class which can evaluate expressions,
  /// format the expression to latex and much more.
  Calculator(Expression startExpression) {
    history.add(Calculation(startExpression));
  }
}

class Calculation {
  Expression _expression;

  Operator? pointer;

  Calculation(this._expression);

  num calculate() {
    return _expression.calculate();
  }

  @override
  String toString() {
    return _expression.toString();
  }

  void reset() {
    _expression = Number(0);
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
    } else if(_expression is Number && (_expression as Number).value == 0) {
      _expression = number;
    }
  }

  void switchSign() {
    if (pointer == null) {
      if(_expression is Number) {
        // should always switch the sign, thats why the equality operator is changed.
        (_expression as Number).switchSign(positive: (_expression as Number).sign < 0);
      } else if (_expression is Operator && (_expression as Operator).right is Number) {
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
    } else if(_expression is Number && num.tryParse((_expression as Number).toString() + number.toString()) != null) {
      (_expression as Number).setValue((_expression as Number).toString() + number.toString());
    } else if (_expression is Operator && (_expression as Operator).right is Number && num.tryParse(((_expression as Operator).right as Number).toString() + number.toString()) != null) {
      Number currentNumber = (_expression as Operator).right as Number;
      currentNumber.setValue(currentNumber.toString() + number.toString());
    }
  }

  void insertDot() {
    if (pointer == null) {
      print(_expression.runtimeType);
      if(_expression is Number && double.tryParse((_expression as Number).toString() + ".0") != null) {
        (_expression as Number).isDouble = true;
      } else if (_expression is Operator && (_expression as Operator).right is Number) {
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
      _expression = symbolToOperand(symbol, _expression);
      if ((_expression as Operator).isFillable) {
        pointer = _expression as Operator; 
      } else {
        pointer = null;
      }
    }
  }

  void makePercentage() {
    if (pointer == null) {
      if(_expression is Number) {
        (_expression as Number).setValue(((_expression as Number).value / 100).toString());
      } else if (_expression is Operator && (_expression as Operator).right is Number) {
        Number currentNumber = (_expression as Operator).right as Number;
        currentNumber.setValue((currentNumber.value / 100).toString());
      }
    }
  }
}

Operator symbolToOperand(String symbol, Expression leftSide) {
  switch (symbol) {
    case "+":
      return Addition(leftSide, Fillable());
    case "-":
      return Subtraction(leftSide, Fillable());
    case "/":
      return Fraction(leftSide, Fillable());
    case "*":
      return Multiplication(leftSide, Fillable());
    case "x^2":
      return Power(leftSide, Number(2));
    case "x^3":
      return Power(leftSide, Number(3));
    case "x^y":
      return Power(leftSide, Fillable());
    case "e^x":
      return Power(EulersNumber(), leftSide);
    case "10^x":
      return Power(Number(10), leftSide);
    case "1/x":
      return Fraction(Number(1), leftSide);
    case "sqrt":
      return Root(leftSide, Number(2));
    case "3rdrt":
      return Root(leftSide, Number(3));
    case "nthrt":
      return Root(leftSide, Fillable());
    case "ln":
      return Logarithm(EulersNumber(), leftSide);
    case "log10":
      return Logarithm(Number(10), leftSide);
    default:
      throw "Unknown Symbol";
  }
}