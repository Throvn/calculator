import 'package:flutter/material.dart';

import 'helper.dart';

Widget iconButton(IconData xIcon, BuildContext context, Priority priority,
    Function? onButtonPress,
    {Color color = const Color(0xFF433A3A), required String name}) {
  Icon icon = Icon(xIcon, size: 42);

  double buttonSize = calculateButtonSize(priority, context);

  return SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: Container(
        color: color,
        child: Tooltip(
          message: name,
          child: TextButton(
            onPressed: () {
              if (onButtonPress != null) {
                onButtonPress(name);
              }
            },
            child: icon,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => color),
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Color(0xFF1F1F1F), width: 0.5),
                ),
              ),
            ),
          ),
        )),
  );
}
