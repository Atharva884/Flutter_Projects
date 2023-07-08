import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/result_answers.dart';
import 'package:quiz_app/styled_text.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen(this.chosenAnswer, this.restartQuiz,{super.key});
  final List<String> chosenAnswer;
  final void Function() restartQuiz;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add({
        "question_index": i,
        "question": questions[i].question,
        "user_answer": chosenAnswer[i],
        "correct_answer": questions[i].answers[0]
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> summary = getSummaryData();
    int totalQuestions = questions.length;
    var totalCorrectAnswers = summary
        .where((element) => element['user_answer'] == element['correct_answer'])
        .length;
    // final isCorrectAnswer = summary.((e)=>{
    //   e['user_answer'] == e['correct_answer']
    // });

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StyledText(
              "You Answered $totalCorrectAnswers out of $totalQuestions questions correctly!",
              color: Colors.white,
              fontsize: 24,
              textalign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            ResultAnswers(summary),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
              onPressed: restartQuiz,
              icon: const Icon(
                Icons.restart_alt_rounded,
                color: Colors.white,
              ),
              label: const StyledText("Restart Quiz"),
            )
          ],
        ),
      ),
    );
  }
}
