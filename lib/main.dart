import 'package:calendar/calculate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';

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
  // set up the Calculator itself.
  // The brains of the operation :P
  final Calculator _calculator = Calculator("sqrt{3-2}+400-e^3");
  bool scientificNotation = false;

  void onButtonPress(String buttonText) {
    switch (buttonText.toLowerCase()) {
      case "(":
        _calculator.expression.openBracket();
        break;
      case ")":
        _calculator.expression.closeBracket();
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
        _calculator.expression.appendNumber(buttonText);
        break;
      case "–":
        // – and - are not the same.
        _calculator.expression.append("-");
        break;
      case "÷":
        _calculator.expression.append("/");
        break;
      case "+":
        _calculator.expression.append(buttonText);
        break;
      case "×":
        _calculator.expression.append("*");
        break;
      case "c":
        _calculator.expression.reset();
        break;
      case "delete":
        _calculator.expression.deleteLastCharacter();
        break;
      case "mc":
        _calculator.memory = 0.0;
        break;
      case "mr":
        // could be that this has bugs
        _calculator.expression.appendNumber(_calculator.memory.toString());
        break;
      case "m+":
        _calculator.addResultToMemory(subtract: false);
        break;
      case "m-":
        _calculator.addResultToMemory(subtract: true);
        break;
      case "random number (0..1)":
        _calculator.expression.appendRandomNumber();
        break;
      case "ee":
        scientificNotation = !scientificNotation;
        break;
      case r"x^2":
        _calculator.expression.appendPower("2");
        break;
      case r"x^3":
        _calculator.expression.appendPower("3");
        break;
      case r"x^y":
        _calculator.expression.appendPower("");
        break;
      case r"e^x":
        _calculator.expression.append("e^{}");
        break;
      case r"10^x":
        _calculator.expression.append("10^");
        break;
      case r"e":
        _calculator.expression.appendNumber("e");
        break;
      case r"\pi":
        _calculator.expression.appendNumber("pi");
        break;
      case "=":
        print("Return result");
        break;
      default:
        print("Unhandled input!");
        break;
    }

    _calculator.expression.removeTrailingZero();

    setState(() {});
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
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 30,),
                scrollDirection: Axis.vertical,
                itemCount: 2,
                itemBuilder: (_, index) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Math.tex(
                        _calculator.expression.asLaTeX,
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
                        height: 15,
                      ),
                      Math.tex(
                        _calculator.expression.getResultAsString(
                            scientificNotation: scientificNotation),
                        textStyle: const TextStyle(
                          color: Colors.white38,
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),
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
          print(_calculator.expression.asLaTeX);
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
                print(_calculator.expression.asLaTeX);
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
          print(_calculator.expression.asLaTeX);
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
