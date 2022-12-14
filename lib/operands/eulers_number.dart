import 'number.dart';
import 'dart:math' as math;

class EulersNumber extends Number {
  EulersNumber() : super(math.e);

  @override
  String toString() => r"e";

  @override
  String get toAscii => "e";
}
