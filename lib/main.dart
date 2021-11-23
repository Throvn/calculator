import 'package:flutter/cupertino.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

enum Priority { low, medium, high, highest }

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  // initialize default values
  List<Map<String, dynamic>> history = [];
  String expression = "sqrt{4+3}+4";
  double memoryExpression = 0;
  int openBrackets = 0;
  bool scientificNotation = false;

  void openBracket() {
    String lastChar = expression[expression.length - 1];

    // because implicit multiplication is not allowed by the parser
    if (lastChar.contains(RegExp(r'[0-9]'))) {
      expression += "*(";
    } else {
      expression += "(";
    }
    openBrackets += 1;

    setState(() {});
  }

  void closeBracket() {
    if (openBrackets < 1) return;
    if (expression[expression.length - 1] == "(") {
      expression = expression.substring(0, expression.length - 1);
      return;
    } else {
      openBrackets -= 1;
      expression += ")";
    }
    setState(() {});
  }

  void addNumberToExpression(String number) {
    String lastChar = expression[expression.length - 1];
    if (lastChar == "}") {
      expression =
          expression.substring(0, expression.length - 1) + number + "}";
    } else {
      expression += number;
    }
  }

  void addToExpression(String appendix) {
    expression += appendix;
  }

  void addRandomNumberToExpression() {
    expression += Random().nextDouble().toString();
  }

  void deleteFromExpression() {
    // TODO(Louis): Remove Squareroots

    String lastChar = expression[expression.length - 1];
    switch (lastChar) {
      case "}":
        expression = expression.substring(0, expression.length - 2) + "}";
        if (expression[expression.length - 2] == "{") {
          expression = expression.substring(0, expression.length - 2);
        }
        break;
      case "t":
        if (getExpression.lastIndexOf("sqrt") == expression.length - 4) {
          expression = getExpression.substring(0, expression.length - 4);
        }
        print("Deleted special");
        // lets hope that there is only ever one }

        break;
      default:
        print("Deleted last");
        expression = expression.substring(0, expression.length - 1);
    }
    print(expression);
  }

  int getMatchingClosingBracketPosition(String expression) {
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
  String latexParse(String expr) {
    String expr = expression;

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

    // make sure exponentials are rendered correctly
    while (expr.contains("^(")) {
      int opening = expr.indexOf("^(");
      int closing = getMatchingClosingBracketPosition(expr.substring(opening));
      String temp = expr.substring(0, opening);
      temp += "^{(";
      temp += expr.substring(opening + 2, closing + 1);
      temp += "}";
      temp += expr.substring(closing + 1);
      expr = temp;
    }

    return expr;
  }

  String get getExpression {
    // remove all open brackets at the end
    // String expr = expression.replaceAll(RegExp(r'\(+$'), "");

    // close all open brackets
    String expr =
        openBrackets > 0 ? expression + (")" * openBrackets) : expression;
    // remove all empty bracket pairs
    expr = expr.replaceAll(RegExp(r'\(\)+'), "");

    // to make latex parsing easier, we use curly brackets sometimes.
    // but before calculation replace them with normal ones.
    expr = expr.replaceAll("{", "(");
    expr = expr.replaceAll("}", ")");

    // remove all leading zeros
    expr.replaceFirst(RegExp(r'^0+'), "");

    return expr.isNotEmpty ? expr : "0";
  }

  void onButtonPress(String buttonText) {
    switch (buttonText.toLowerCase()) {
      case "(":
        openBracket();
        break;
      case ")":
        closeBracket();
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
      case ".":
        addNumberToExpression(buttonText);
        break;
      case "–":
        // – and - are not the same.
        addToExpression("-");
        break;
      case "÷":
        addToExpression("/");
        break;
      case "+":
        addToExpression(buttonText);
        break;
      case "×":
        addToExpression("*");
        break;
      case "c":
        expression = "0";
        break;
      case "delete":
        deleteFromExpression();
        break;
      case "mc":
        memoryExpression = 0.0;
        break;
      case "mr":
        // could be that this has bugs
        addNumberToExpression(memoryExpression.toString());
        break;
      case "m+":
        addResultToMemory(subtract: false);
        break;
      case "m-":
        addResultToMemory(subtract: true);
        break;
      case "random number (0..1)":
        addRandomNumberToExpression();
        break;
      case "ee":
        print("EE");
        setState(() {
          scientificNotation = !scientificNotation;
        });
        break;
      default:
        print("Unhandled input!");
        break;
    }
    setState(() {});
  }

  void addResultToMemory({bool subtract = false}) {
    double result = double.parse(getResultOfExpression().substring(2));
    if (isExpressionValid()) {
      memoryExpression += (subtract ? -result : result);
    } else {
      print("No valid result to add to memory");
    }
  }

  String getResultOfExpression() {
    if (isExpressionValid()) {
      String result = scientificNotation
          ? getExpression.interpret().toStringAsExponential()
          : getExpression.interpret().toString();
      return "= " + result.toSingleVariableFunction().tex;
    } else {
      return "";
    }
  }

  bool isExpressionValid() {
    try {
      getExpression.interpret().toString().toSingleVariableFunction().tex;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse expression:

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Math.tex(
                        latexParse(expression),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                        ),
                        onErrorFallback: (FlutterMathException e) => const Text(
                          "Invalid equation",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Math.tex(
                        getResultOfExpression(),
                        textStyle: const TextStyle(
                          color: Colors.white38,
                          fontSize: 42,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // now the keys are coming
          Row(
            children: [
              normalButton("(", context, Priority.highest),
              normalButton(")", context, Priority.highest),
              normalButton("mc", context, Priority.medium),
              normalButton("m+", context, Priority.medium),
              normalButton("m-", context, Priority.low),
              normalButton("mr", context, Priority.medium),
              normalButton("C", context, Priority.highest),
              texButton(r"^+/_-", context, Priority.high),
              texButton(r"\%", context, Priority.medium),
              normalButton(
                "÷",
                context,
                Priority.highest,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              iconButton(
                CupertinoIcons.settings,
                context,
                Priority.high,
                name: "Settings",
              ),
              texButton(r"x^2", context, Priority.medium),
              texButton(r"x^3", context, Priority.medium),
              texButton(r"x^y", context, Priority.medium),
              texButton(r"e^x", context, Priority.medium),
              texButton(r"10^x", context, Priority.low),
              normalButton("7", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("8", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("9", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton(
                "×",
                context,
                Priority.highest,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"\frac{1}{x}", context, Priority.low),
              texButton(r"\sqrt[2]{x}", context, Priority.high),
              texButton(r"\sqrt[3]{x}", context, Priority.medium),
              texButton(r"\sqrt[y]{x}", context, Priority.medium),
              texButton(r"\ln", context, Priority.medium),
              texButton(r"\log_{10}", context, Priority.medium),
              normalButton("4", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("5", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("6", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton(
                "–",
                context,
                Priority.highest,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"x!", context, Priority.medium),
              texButton(r"\sin", context, Priority.medium),
              texButton(r"\cos", context, Priority.medium),
              texButton(r"\tan", context, Priority.low),
              texButton(r"e", context, Priority.high),
              normalButton("EE", context, Priority.medium),
              normalButton("1", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("2", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("3", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton(
                "+",
                context,
                Priority.highest,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("Rad", context, Priority.medium),
              texButton(r"\sinh", context, Priority.medium),
              texButton(r"\cosh", context, Priority.medium),
              texButton(r"\tanh", context, Priority.low),
              texButton(r"\pi", context, Priority.high),
              iconButton(
                  CupertinoIcons.question_square, context, Priority.medium,
                  name: "Random Number (0..1)"),
              normalButton(".", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              normalButton("0", context, Priority.highest,
                  color: const Color(0xFF625B5B)),
              iconButton(CupertinoIcons.delete_left, context, Priority.highest,
                  color: const Color(0xFFE84545), name: "Delete"),
              normalButton(
                "=",
                context,
                Priority.highest,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget normalButton(String text, BuildContext context, Priority priority,
      {Color color = const Color(0xFF433A3A)}) {
    double buttonSize = calculateButtonSize(priority, context);

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: TextButton(
        onPressed: () {
          onButtonPress(text);
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

  Widget iconButton(IconData xIcon, BuildContext context, Priority priority,
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
                onButtonPress(name);
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

  Widget texButton(String tex, BuildContext context, Priority priority,
      {Color color = const Color(0xFF433A3A)}) {
    double buttonSize = calculateButtonSize(priority, context);

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: TextButton(
        onPressed: () {
          onButtonPress(tex);
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
        child: Math.tex(
          tex,
          options: MathOptions(fontSize: 35, color: Colors.white),
          onErrorFallback: (FlutterMathException e) => const Text(
            "Math Error!",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

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
