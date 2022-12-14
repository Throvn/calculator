import 'package:flutter/material.dart';

enum Priority { low, medium, high, highest }

double calculateButtonSize(Priority priority, BuildContext context) {
  double windowWidth = MediaQuery.of(context).size.width;
  if (windowWidth <= 400) {
    switch (priority) {
      case Priority.highest:
        return windowWidth / 4;
      case Priority.high:
      case Priority.medium:
      case Priority.low:
      default:
        return 0.0;
    }
  } else if (windowWidth <= 700) {
    switch (priority) {
      case Priority.highest:
      case Priority.high:
        return windowWidth / 5;
      case Priority.medium:
      case Priority.low:
      default:
        return 0.0;
    }
  } else if (windowWidth <= 900) {
    switch (priority) {
      case Priority.medium:
      case Priority.high:
      case Priority.highest:
        return windowWidth / 9;
      case Priority.low:
      default:
        return 0.0;
    }
  }

  return windowWidth / 10;
}
