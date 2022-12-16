import 'package:calculator/calculate.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../operands/number.dart';

void openAboutDialog(BuildContext context, Calculator calculator) {
  showAboutDialog(
      context: context,
      applicationVersion: "v1.0.0",
      applicationName: "Calculator",
      applicationLegalese: "Made by Louis Stanko",
      applicationIcon: Image.asset("assets/icon/icon.png", height: 85),
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        const Text("Thanks for using my app. ❤️"),
        const SizedBox(
          height: 5,
        ),
        const Text(
            "It will NEVER have any advertisements and will ALWAYS be for free!"),
        const SizedBox(
          height: 5,
        ),
        const Text(
            "If you want to support me somehow,\nleaving a positive review in the App Store would help me out A LOT!"),
        const SizedBox(
          height: 5,
        ),
        const Text(
            "If you have noticed any bugs or issues, please report them on github."),
        const SizedBox(
          height: 5,
        ),
        const Text("Icon made by Tristan Edwards."),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  String stringCalculation = "**History:**\n";
                  for (var calculation in calculator.history) {
                    stringCalculation += calculation.toString() + "\n\n";
                  }

                  Calculation lastCalculation = Calculation(Number(-1));
                  if (calculator.history.isNotEmpty) {
                    lastCalculation = calculator.history.last;
                  }

                  String issueUrl = Uri.encodeFull(
                      "https://github.com/Throvn/calculator/issues/new?title=Bug in: ${lastCalculation.toAscii}&body=**LaTeX:** ${lastCalculation.toString()}\n**Ascii:** ${lastCalculation.toAscii}\n$stringCalculation\nFurther details (Expected Outcome):");
                  // open newly generated github issue in in-app browser.
                  launchUrlString(issueUrl);
                },
                child: const Text("Report Issue")),
            ElevatedButton(
                onPressed: () async {
                  InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                child: const Text("Leave a Review")),
          ],
        )
      ]);
}
