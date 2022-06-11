import 'dart:math';

import 'package:calendar/expression.dart';

class Calculator {
  List<Expression> history = [];

  // the normal expression.
  // Has a special format, to be easily convertable
  // to latex and normal (function_tree) math.
  get expression => history.isNotEmpty ? history.last : Expression("0");

  // the memory _expression (same format as [_expression])
  double memory = 0.0;

  /// Adds the result to the [memory] variable. If subtract == true,
  /// it subtracts the result from the value stored in [memory].
  void addResultToMemory({bool subtract = false}) {
    if (expression.isValid()) {
      double result = expression.getResultAsDouble();
      memory += (subtract ? -result : result);
    } else {
      print("No valid result to add to memory");
    }
  }

  /// Creates a class which can evaluate expressions,
  /// format the expression to latex and much more.
  Calculator(String startExpression) {
    history.add(Expression(startExpression));
  }
}
