import 'dart:math';

num cosh(double x) {
  return (pow(e, x) + pow(e, -x)) / 2;
}

num sinh(double x) {
  return (pow(e, x) - pow(e, -x)) / 2;
}

num tanh(double x) {
  return sinh(x) / cosh(x);
}
