import 'package:flutter/material.dart';
import 'package:quiz_app/styled_text.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.switchScreen, {super.key});
  final void Function() switchScreen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/quiz-logo.png",
            width: 400,
          ),
          const SizedBox(height: 50),
          const StyledText(
            "Learn Flutter the fun way!",
            fontsize: 30,
            color: Colors.white54,
          ),
          const SizedBox(height: 50),
          OutlinedButton.icon(
            onPressed: switchScreen,
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            label: const StyledText(
              "Start Quiz",
              fontsize: 20,
            ),
          )
        ],
      ),
    );
  }
}
