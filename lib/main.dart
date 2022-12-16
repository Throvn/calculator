import 'dart:math';

import 'calculate.dart';
import 'utilities/about_dialog.dart';
import 'utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';

import 'buttons/helper.dart';
import 'buttons/icon_button.dart';
import 'buttons/normal_button.dart';
import 'buttons/tex_button.dart';
import 'operands/eulers_number.dart';
import 'operands/number.dart';
import 'operands/pi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // set up the Calculator itself.
  // The brains of the operation :P
  final Calculator _calculator = Calculator(Number(0));
  bool scientificNotation = false;

  ScrollController historyScrollController =
      ScrollController(initialScrollOffset: 30);

  void buttonPressed(String buttonText) {
    switch (buttonText.toLowerCase()) {
      case "":
        break;
      case "()":
        _calculator.expression.encloseBrackets();
        break;
      case "0":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
        _calculator.expression.insertNumber(Number(num.parse(buttonText)));
        break;
      case ".":
        _calculator.expression.insertDot();
        break;
      case "–":
        // – and - are not the same.
        _calculator.expression.insertOperand("-");
        break;
      case "÷":
        _calculator.expression.insertOperand("/");
        break;
      case "+":
        _calculator.expression.insertOperand("+");
        break;
      case "×":
        _calculator.expression.insertOperand("*");
        break;
      case r"\%":
        _calculator.expression.makePercentage();
        break;
      case "c":
        _calculator.expression.reset();
        break;
      case "delete":
        _calculator.expression.undo();
        break;
      case "mc":
        _calculator.memory = 0;
        break;
      case "mr":
        if (_calculator.memory.isNegative) {
          _calculator.expression.insertOperand("-");
        } else {
          _calculator.expression.insertOperand("+");
        }
        _calculator.expression.insertNumber(Number(_calculator.memory.abs()));
        break;
      case "m+":
        _calculator.addResultToMemory(subtract: false);
        break;
      case "m-":
        _calculator.addResultToMemory(subtract: true);
        break;
      case r"^+/_-":
        _calculator.expression.switchSign();
        break;
      case "random number (0..1)":
        _calculator.expression.insertOperand("+");
        _calculator.expression.insertNumber(Number(Random().nextDouble()));
        break;
      case "ee":
        scientificNotation = !scientificNotation;
        break;
      case r"x^2":
        _calculator.expression.insertOperand("x^2");
        break;
      case r"x^3":
        _calculator.expression.insertOperand("x^3");
        break;
      case r"x^y":
        _calculator.expression.insertOperand("x^y");
        break;
      case r"e^x":
        _calculator.expression.insertOperand("e^x");
        break;
      case r"10^x":
        _calculator.expression.insertOperand("10^x");
        break;
      case r"e":
        _calculator.expression.insertNamedNumber(EulersNumber());
        break;
      case r"\pi":
        _calculator.expression.insertNamedNumber(Pi());
        break;
      case r"\log_{10}":
        _calculator.expression.insertOperand("log10");
        break;
      case r"\ln":
        _calculator.expression.insertOperand("ln");
        break;
      case r"\sqrt[2]{x}":
        _calculator.expression.insertOperand("sqrt");
        break;
      case r"\sqrt[3]{x}":
        _calculator.expression.insertOperand("3rdrt");
        break;
      case r"\sqrt[y]{x}":
        _calculator.expression.insertOperand("nthrt");
        break;
      case r"\frac{1}{x}":
        _calculator.expression.insertOperand("1/x");
        break;
      case r"x!":
        _calculator.expression.insertOnesidedOperand("!");
        break;
      case r"\sin":
        _calculator.expression.insertOnesidedOperand("sin");
        break;
      case r"\cos":
        _calculator.expression.insertOnesidedOperand("cos");
        break;
      case r"\tan":
        _calculator.expression.insertOnesidedOperand("tan");
        break;
      case r"\sinh":
        _calculator.expression.insertOnesidedOperand("sinh");
        break;
      case r"\cosh":
        _calculator.expression.insertOnesidedOperand("cosh");
        break;
      case r"\tanh":
        _calculator.expression.insertOnesidedOperand("tanh");
        break;
      case "=":
        // Add new row to history. Last history entry is the current expression.
        _calculator.history.add(Calculation(Number(0)));
        historyScrollController.animateTo(_calculator.history.length * 107,
            curve: Curves.linear, duration: const Duration(milliseconds: 300));
        break;
      case "settings":
        openAboutDialog(context);
        break;
      default:
        print("Unhandled input!");
        break;
    }

    // _calculator.expression.removeTrailingZero();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: ListView.separated(
                  controller: historyScrollController,
                  padding: const EdgeInsets.only(bottom: 100),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 50),
                  scrollDirection: Axis.vertical,
                  itemCount: _calculator.history.length,
                  itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Math.tex(
                          _calculator.history[index].toString(),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                          ),
                          onErrorFallback: (FlutterMathException e) => Text(
                            _calculator.history[index].toAscii,
                            style: TextStyle(
                                color: CustomColors.danger, fontSize: 42),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Math.tex(
                        scientificNotation
                            ? _calculator.history[index]
                                .calculate()
                                .toStringAsExponential()
                            : _calculator.history[index].calculate().toString(),
                        textStyle: TextStyle(
                          color: index == _calculator.history.length - 1
                              ? Colors.white38
                              : Colors.white,
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // now the keys are coming
          Row(
            children: [
              normalButton("", context, Priority.highest, buttonPressed),
              normalButton("()", context, Priority.highest, buttonPressed),
              normalButton("mc", context, Priority.medium, buttonPressed),
              normalButton("m+", context, Priority.medium, buttonPressed),
              normalButton("m-", context, Priority.low, buttonPressed),
              normalButton("mr", context, Priority.medium, buttonPressed),
              normalButton("C", context, Priority.highest, buttonPressed),
              texButton(
                r"^+/_-",
                context,
                Priority.high,
                buttonPressed,
              ),
              texButton(
                r"\%",
                context,
                Priority.medium,
                buttonPressed,
              ),
              normalButton(
                "÷",
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.warning,
              ),
            ],
          ),
          Row(
            children: [
              iconButton(
                CupertinoIcons.settings,
                context,
                Priority.high,
                buttonPressed,
                name: "Settings",
              ),
              texButton(r"x^2", context, Priority.medium, buttonPressed),
              texButton(r"x^3", context, Priority.medium, buttonPressed),
              texButton(r"x^y", context, Priority.medium, buttonPressed),
              texButton(r"e^x", context, Priority.medium, buttonPressed),
              texButton(r"10^x", context, Priority.low, buttonPressed),
              normalButton("7", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("8", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("9", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton(
                "×",
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.warning,
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"\frac{1}{x}", context, Priority.low, buttonPressed),
              texButton(r"\sqrt[2]{x}", context, Priority.high, buttonPressed),
              texButton(
                  r"\sqrt[3]{x}", context, Priority.medium, buttonPressed),
              texButton(
                  r"\sqrt[y]{x}", context, Priority.medium, buttonPressed),
              texButton(r"\ln", context, Priority.medium, buttonPressed),
              texButton(r"\log_{10}", context, Priority.medium, buttonPressed),
              normalButton("4", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("5", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("6", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton(
                "–",
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.warning,
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"x!", context, Priority.medium, buttonPressed),
              texButton(r"\sin", context, Priority.medium, buttonPressed),
              texButton(r"\cos", context, Priority.medium, buttonPressed),
              texButton(r"\tan", context, Priority.low, buttonPressed),
              texButton(r"e", context, Priority.high, buttonPressed),
              normalButton("EE", context, Priority.medium, buttonPressed),
              normalButton("1", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("2", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("3", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton(
                "+",
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.warning,
              ),
            ],
          ),
          Row(
            children: [
              normalButton("Rad", context, Priority.medium, buttonPressed),
              texButton(r"\sinh", context, Priority.medium, buttonPressed),
              texButton(r"\cosh", context, Priority.medium, buttonPressed),
              texButton(r"\tanh", context, Priority.low, buttonPressed),
              texButton(r"\pi", context, Priority.high, buttonPressed),
              iconButton(
                CupertinoIcons.question_square,
                context,
                Priority.medium,
                buttonPressed,
                name: "Random Number (0..1)",
              ),
              normalButton(".", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              normalButton("0", context, Priority.highest, buttonPressed,
                  color: CustomColors.secondary),
              iconButton(
                CupertinoIcons.delete_left,
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.danger,
                name: "Delete",
              ),
              normalButton(
                "=",
                context,
                Priority.highest,
                buttonPressed,
                color: CustomColors.warning,
              ),
            ],
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
