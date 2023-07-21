import 'number.dart';
import 'dart:math' as math;

class Pi extends Number {
  Pi() : super(math.pi);

  @override
  String toString() => r"\pi";

  @override
  String get toAscii => "pi";
}
