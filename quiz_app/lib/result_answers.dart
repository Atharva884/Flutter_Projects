import 'package:flutter/material.dart';
import 'package:quiz_app/styled_text.dart';

class ResultAnswers extends StatelessWidget {
  const ResultAnswers(this.summaryData, {super.key});
  final List<Map<String, Object>> summaryData;
  // final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData
              .map(
                (data) => Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.redAccent),
                      child: Text(
                        ((data['question_index'] as int) + 1).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            data['question'].toString(),
                            fontsize: 20,
                          ),
                          const SizedBox(height: 10),
                          StyledText(
                            data['user_answer'].toString(),
                            color: Colors.greenAccent,
                            fontsize: 16,
                          ),
                          const SizedBox(height: 5),
                          StyledText(
                            data['correct_answer'].toString(),
                            color: const Color.fromARGB(255, 206, 126, 220),
                            fontsize: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
