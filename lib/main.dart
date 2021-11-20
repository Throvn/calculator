import 'package:flutter/cupertino.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

var expressionContext = {
  "x": pi / 5,
  "cos": cos,
  "sin": sin,
  "pow": pow,
  "e": e,
  "sqrt": sqrt,
  "π": pi,
  "pi": pi,
};

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse expression:
    String expression = "e^(3 * 2) / e^5";
    final e = expression.interpret();
    final tex = expression.toSingleVariableFunction().tex;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Math.tex(
                    tex,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                    ),
                    onErrorFallback: (FlutterMathException e) => const Text(
                      "Math Error!",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    '=  $e',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 42,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // now the keys are coming
          Row(
            children: [
              normalButton("(", context),
              normalButton(")", context),
              normalButton("mc", context),
              normalButton("m+", context),
              normalButton("m-", context),
              normalButton("mr", context),
              normalButton("C", context),
              texButton(r"^+/_-", context),
              texButton(r"\%", context),
              normalButton(
                "÷",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              iconButton(CupertinoIcons.settings, context),
              texButton(r"x^2", context),
              texButton(r"x^3", context),
              texButton(r"x^y", context),
              texButton(r"e^x", context),
              texButton(r"10^x", context),
              normalButton("7", context, color: const Color(0xFF625B5B)),
              normalButton("8", context, color: const Color(0xFF625B5B)),
              normalButton("9", context, color: const Color(0xFF625B5B)),
              normalButton(
                "×",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"\frac{1}{x}", context),
              texButton(r"\sqrt[2]{x}", context),
              texButton(r"\sqrt[3]{x}", context),
              texButton(r"\sqrt[y]{x}", context),
              texButton(r"\ln", context),
              texButton(r"\log_{10}", context),
              normalButton("4", context, color: const Color(0xFF625B5B)),
              normalButton("5", context, color: const Color(0xFF625B5B)),
              normalButton("6", context, color: const Color(0xFF625B5B)),
              normalButton(
                "–",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              texButton(r"x!", context),
              texButton(r"\sin", context),
              texButton(r"\cos", context),
              texButton(r"\tan", context),
              texButton(r"e", context),
              normalButton("EE", context),
              normalButton("1", context, color: const Color(0xFF625B5B)),
              normalButton("2", context, color: const Color(0xFF625B5B)),
              normalButton("3", context, color: const Color(0xFF625B5B)),
              normalButton(
                "+",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("Rad", context),
              texButton(r"\sinh", context),
              texButton(r"\cosh", context),
              texButton(r"\tanh", context),
              texButton(r"\pi", context),
              iconButton(CupertinoIcons.question_square, context),
              normalButton(".", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              iconButton(CupertinoIcons.delete_left, context,
                  color: const Color(0xFFE84545)),
              normalButton(
                "=",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget normalButton(String text, BuildContext context,
    {Color color = const Color(0xFF433A3A)}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 10,
    height: MediaQuery.of(context).size.height / 1.5 / 5,
    child: TextButton(
      onPressed: () {},
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

Widget iconButton(IconData xIcon, BuildContext context,
    {Color color = const Color(0xFF433A3A)}) {
  Icon icon = Icon(xIcon, size: 42);
  return SizedBox(
    width: MediaQuery.of(context).size.width / 10,
    height: MediaQuery.of(context).size.height / 1.5 / 5,
    child: Container(
      color: color,
      child: TextButton(
        onPressed: () {},
        child: icon,
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
      ),
    ),
  );
}

Widget texButton(String tex, BuildContext context,
    {Color color = const Color(0xFF433A3A)}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 10,
    height: MediaQuery.of(context).size.height / 1.5 / 5,
    child: TextButton(
      onPressed: () {},
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
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
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
