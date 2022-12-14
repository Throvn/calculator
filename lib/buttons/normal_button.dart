import 'package:flutter/material.dart';

import 'helper.dart';

Widget normalButton(String text, BuildContext context, Priority priority,
    Function? onButtonPress,
    {Color color = const Color(0xFF433A3A)}) {
  double buttonSize = calculateButtonSize(priority, context);

  return SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: TextButton(
      onPressed: () {
        if (onButtonPress != null) {
          onButtonPress(text);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => color),
        foregroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFF1F1F1F), width: 0.5),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 42),
      ),
    ),
  );
}
