import 'dart:math';

import 'package:function_tree/function_tree.dart';

class Expression {
  String _expression = "sqrt{4+3}+4";

  /// Stores the mathexpression. Allows also modifications and
  /// calculations on it.
  Expression(String value) {
    _expression = value;
  }

  /// Checks whether the input seems to be a valid number. Based on the char it receives
  bool isNumber(String text) {
    // filter out numeric words
    // e, sin, cos, log, pi
    if (text == "e" || text == "n" || text == "s" || text == "g" || text == "i") {
      return true;
    }
    return double.tryParse(text) != null;
  }

  /// removes the first 0 if it is unneccessary
  void removeTrailingZero() {
    if (_expression.length >= 2 && _expression != "0" && _expression[0] == "0" && isNumber(_expression[1])) {
      _expression = _expression.replaceFirst("0", "");
    }
  }

  /// Sets the [_expression] variable.
  /// BE CAREFUL.
  set setExpression(String expression) {
    _expression = expression;
  }

  /// Returns the [_expression] in a better parsable format
  /// for the **function_tree**. Also auto-closes brackets.
  @override
  String toString() {
    // remove all open brackets at the end
    // String expr = expression.replaceAll(RegExp(r'\(+$'), "");

    // close all open brackets
    String expr =
        _openBrackets > 0 ? _expression + (")" * _openBrackets) : _expression;
    // remove all empty bracket pairs
    expr = expr.replaceAll(RegExp(r'\(\)+'), "");

    // to make latex parsing easier, we use curly brackets sometimes.
    // but before calculation replace them with normal ones.
    expr = expr.replaceAll("{", "(");
    expr = expr.replaceAll("}", ")");

    // remove all leading zeros
    expr.replaceAll(RegExp(r'^0+'), "");

    return expr.isNotEmpty ? expr : "0";
  }

  int _openBrackets = 0;

  /// Adds an opening bracket to the end of the [_expression]
  void openBracket() {
    String lastChar = _expression[_expression.length - 1];

    // because implicit multiplication is not allowed by the parser
    if (lastChar.contains(RegExp(r'[0-9]'))) {
      _expression += "*(";
    } else {
      _expression += "(";
    }
    _openBrackets += 1;
  }

  /// Appends a closing bracket to the [_expression]
  void closeBracket() {
    if (_openBrackets < 1) return;
    if (_expression[_expression.length - 1] == "(") {
      _expression = _expression.substring(0, _expression.length - 1);
      return;
    } else {
      _openBrackets -= 1;
      _expression += ")";
    }
  }

  /// Appends the [number]. If last char is in a bracket however, it puts the
  /// number into that bracket.
  void appendNumber(String number) {
    String lastChar = _expression[_expression.length - 1];
    if (lastChar == "}") {
      _expression =
          _expression.substring(0, _expression.length - 1) + number + "}";
    } else {
      _expression += number;
    }
  }

  /// simply adds the [appendix] to the end of the [_expression].
  /// Does no checking for errors whatsoever.
  void append(String appendix) {
    _expression += appendix;
  }

  /// adds a random number to the end of the [_expression].
  /// Does no checking for errors, whatsoever.
  void appendRandomNumber() {
    _expression += Random().nextDouble().toString();
  }

  /// Appends the power symbol to the end of the [_expression].
  /// But there are some cases where this is not allowed (e.g. with brackets)
  void appendPower(String number) {
    String lastChar = _expression[_expression.length - 1];
    if (number == "" && isNumber(lastChar)) {
      _expression += ("^{}"); 
    } else if (isNumber(lastChar)) {
      _expression += ("^" + number); 
    }
  }

  /// Sets the current value of the [_expression] to 0.
  void reset() {
    _expression = "0";
  }

  /// Deletes the last visible character from the equation.
  /// Checks for brackets and so on.
  void deleteLastCharacter() {
    // TODO(Louis): Remove Squareroots

    // ! Be careful -> _expression and expression are DIFFERENT!


    if (_expression == "0") {
      print("skipping deletion");
      return;
    }

    String lastChar = _expression[_expression.length - 1];
    switch (lastChar) {
      case "}":
        _expression = _expression.substring(0, _expression.length - 2) + "}";
        if (_expression[_expression.length - 2] == "{") {
          _expression = _expression.substring(0, _expression.length - 2);
        }
        break;
      case "t":
        if (_expression.lastIndexOf("sqrt") == _expression.length - 3) {
          _expression = _expression.substring(0, _expression.length - 3);
        }
        print("Deleted special");
        // lets hope that there is only ever one }

        break;
      default:
        print("Deleted last");
        _expression = _expression.substring(0, _expression.length - 1);
    }
  
    // remove Clutter (e.g. if you delete ^3) -> also remove ^
    while(_expression.isNotEmpty && !isNumber(_expression[_expression.length - 1]) || _expression[_expression.length - 1] == "{" || _expression[_expression.length - 1] == "(") {
      print(_expression.length - 1);
      _expression = _expression.substring(0, _expression.length - 1);
    }

    print(_expression);
  }

  /// Returns the linked closed bracket of the substring [expression]
  /// Has the requirement, that there is always one more closed bracket
  /// than open bracket in the [expression].
  ///
  /// Helper method for [latexParse]
  int _getMatchingClosingBracketPosition(String expression) {
    int bracket = 1;
    int i = 0;
    while (bracket > 0 && i < expression.length) {
      switch (expression[i]) {
        case "(":
          bracket += 1;
          break;
        case ")":
          bracket -= 1;
          break;
        default:
      }
      i++;
    }
    return i;
  }

  /// Parses the [expr] into really basic latex.
  ///
  /// Supported operations are: + - * / ^
  String get asLaTeX {
    String expr = _expression;

    // parse all '/' to latex fractions
    while (RegExp(r'([0-9]+|\(?.*\))\/(([0-9]+)|\(?.*?\)|)').hasMatch(expr)) {
      RegExpMatch? match =
          RegExp(r'([0-9]+|\(?.*\))\/(([0-9]+)|\(?.*?\)|)').firstMatch(expr);
      if (match != null) {
        expr = expr.replaceFirstMapped(
            RegExp(r'([0-9]+|\(?.*\))\/(([0-9]+)|\(?.*?\)|)'), (match) {
          return r"\frac{" + match.group(1)! + "}{" + match.group(2)! + "}";
        });
      }
    }
    // parse all '*' to latex notation
    expr = expr.replaceAll(RegExp(r'\*'), r'\cdot');

    // parse all squareroots to latex squareroots
    expr = expr.replaceAll("sqrt", r"\sqrt");

    // represent pi as symbol
    expr = expr.replaceAll("pi", r"\pi");

    // make sure exponentials are rendered correctly
    while (expr.contains("^(")) {
      int opening = expr.indexOf("^(");
      int closing = _getMatchingClosingBracketPosition(expr.substring(opening));
      String temp = expr.substring(0, opening);
      temp += "^{(";
      temp += expr.substring(opening + 2, closing + 1);
      temp += "}";
      temp += expr.substring(closing + 1);
      expr = temp;
    }

    // if the last char is ^, render a placeholder
    if (expr.lastIndexOf("^") == expr.length - 1) {
      expr = expr.substring(0, expr.length - 1) + r"^{\square}"; 
    } else if (expr.length >= 3 && expr.lastIndexOf("^{}") == expr.length - 3) {
      expr = expr.substring(0, expr.length - 3) + r"^{\square}"; 
    }

    return expr;
  }

  /// Checks if the [_expression] currently fails to produce a valid result.
  bool isValid() {
    try {
      toString().interpret().toString().toSingleVariableFunction().tex;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculates the [_expression]. Returns the result either in
  /// [scientificNotation] or normal notation.
  /// If [_expression] is invalid, returns empty string.
  String getResultAsString({required bool scientificNotation}) {

    if (isValid()) {
      String result = scientificNotation
          ? toString().interpret().toStringAsExponential()
          : toString().interpret().toString();
      String texResult = result.toSingleVariableFunction().tex;
      texResult = texResult.replaceAll("Infinity", r"\infty");
      return "= " + texResult;
    } else {
      return "";
    }
  }

  /// Calculates the result of [_expression]. Returns the result as a double.
  /// If the expression is not valid, returns 0.0.
  double getResultAsDouble() {
    if (isValid()) {
      return toString().interpret().toDouble();
    }
    return 0.0;
  }
}
