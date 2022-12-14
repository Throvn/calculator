import 'expression.dart';

class Number extends Expression {
  String _displayValue = "";
  bool isDouble = false;
  num get sign => num.parse(_displayValue).sign;

  void switchSign({required bool positive}) => _displayValue =
      positive ? value.abs().toString() : (-value.abs()).toString();

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

    return value.isNegative
        ? "(" + value.toString() + ".)"
        : value.toString() + ".";
  }

  @override
  String get toAscii => toString();
}
