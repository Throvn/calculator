// UNIT TESTING
import 'package:test/test.dart';

// file to test
import 'package:calculator/calculate.dart';

void main() {
  test('Squareroot delivers right results.', () {
    Calculator cal = Calculator("sqrt{4}");
    expect(
        cal.expression.getResultAsString(scientificNotation: false), "= 2.0");

    cal.expression.setExpression = "sqrt{pi}";
    expect(cal.expression.getResultAsString(scientificNotation: false),
        "= 1.7724538509055159");

    // since it gets calculated by function_tree, it should also work for round brackets.
    cal.expression.setExpression = "sqrt(10)";
    expect(cal.expression.getResultAsString(scientificNotation: false),
        "= 3.1622776601683795");
  });

  test('Addition delivers the right results', () {
    // Basic addition
    Calculator cal = Calculator("4 + 1");
    expect(
        "= 5.0", cal.expression.getResultAsString(scientificNotation: false));

    // Add to negative numbers
    cal.expression.setExpression = "-10 + 3";
    expect(
        "= -7.0", cal.expression.getResultAsString(scientificNotation: false));

    // Double values
    cal.expression.setExpression = "532.62960 + 0.999";
    expect("= 533.6286",
        cal.expression.getResultAsString(scientificNotation: false));
  });

  test('Subtraction of two numbers', () {
    // Basic addition
    Calculator cal = Calculator("4 - 1");
    expect(
        "= 3.0", cal.expression.getResultAsString(scientificNotation: false));

    // Add to negative numbers
    cal.expression.setExpression = "-10 - 3";
    expect(
        "= -13.0", cal.expression.getResultAsString(scientificNotation: false));

    // Double values
    cal.expression.setExpression = "0.999 - 532.62960";
    expect("= -531.6306",
        cal.expression.getResultAsString(scientificNotation: false));
  });

  test('Multiplication of two numbers', () {
    // Basic addition
    Calculator cal = Calculator("4 * 1");
    expect(
        "= 4.0", cal.expression.getResultAsString(scientificNotation: false));

    // Add to negative numbers
    cal.expression.setExpression = "-10 * (-3)";
    expect(
        "= 30.0", cal.expression.getResultAsString(scientificNotation: false));

    // Double values
    cal.expression.setExpression = "532.62960 * 0";
    expect(
        "= 0.0", cal.expression.getResultAsString(scientificNotation: false));
  });

  test('Division of two numbers', () {
    // Basic addition
    Calculator cal = Calculator("4 / 1");
    expect(
        "= 4.0", cal.expression.getResultAsString(scientificNotation: false));

    // Add to negative numbers
    cal.expression.setExpression = "-10 / (-3)";
    expect("3.33333333333333",
        cal.expression.getResultAsDouble().toStringAsFixed(14));

    // Double values
    cal.expression.setExpression = "532.62960 / 0";
    expect("= Infinity",
        cal.expression.getResultAsString(scientificNotation: false));
  });
}
