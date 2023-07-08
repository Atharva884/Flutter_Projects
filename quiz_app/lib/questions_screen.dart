import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/styled_buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectedAnswer});
  final void Function(String answer) onSelectedAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentIndex = 0;

  void incrementIndex(String answer) {
    widget.onSelectedAnswer(answer);
    setState(() {
      currentIndex++;

      // Alternatives
      // currentIndex+=1;
      // currentIndex = currentIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[currentIndex].question,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            // Here, (...) is a spread operator. map() is a built-in function which will return a new list without changing the original

            // Example(map): numbers = [1, 2, 3] => numbers.map((e)=>return e * 2) => [2, 4, 6]
            // Example(spread[...]): numbers = [[1,2,3], 4] => ...numbers => [1, 2, 3, 4]

            ...questions[currentIndex].getShuffledAnswers().map((answer) {
              return StyledButton(
                text: answer,
                onTap: () {
                  incrementIndex(answer);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
