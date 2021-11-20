import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
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
    Expression expression = Expression.parse("(e^(3 * 2)) / (e^5)");

    // Create context containing all the variables and functions used in the expression

    // Evaluate expression
    var evaluator = const MyEvaluator();

    var r = evaluator.eval(expression, expressionContext);

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
                children: [
                  const Text(
                    'cos(x)*cos(x)+sin(x)*sin(x)==2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    '$r',
                    style: const TextStyle(
                      color: Colors.white,
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
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton(
                "=",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton(
                "=",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton(
                "=",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton(
                "=",
                context,
                color: const Color(0xFFF0A500),
              ),
            ],
          ),
          Row(
            children: [
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFF625B5B)),
              normalButton("0", context, color: const Color(0xFFE84545)),
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

class MyEvaluator extends ExpressionEvaluator {
  const MyEvaluator();

  @override
  evalBinaryExpression(
      BinaryExpression expression, Map<String, dynamic> context) {
    if (expression.operator == '^') {
      var leftExpression = Expression.parse(expression.left.toString());

      eval(leftExpression, expressionContext);
      final left = eval(expression.left, context);
      final right = () => eval(expression.right, context);
      return pow(left, right());
    }
    return super.evalBinaryExpression(expression, context);
  }
}
