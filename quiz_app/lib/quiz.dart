import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/result_screen.dart';
import 'package:quiz_app/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});


  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  String activeScreen = "start-screen";

  void switchScreen(){
    setState(() {
      activeScreen = "questions-screen";
    });
  }

  void chosenAnswer(String answer){
    selectedAnswers.add(answer);

    if(selectedAnswers.length == questions.length){
      setState(() {
        activeScreen = "result-screen";
      });
    }

  }

  void restartQuiz(){
    setState(() {
      selectedAnswers = [];
      activeScreen = "questions-screen";
    });
  }

  

  @override
  Widget build(BuildContext context) {
    Widget screen = StartScreen(switchScreen);

    if(activeScreen == "questions-screen"){
      screen = QuestionsScreen(onSelectedAnswer: chosenAnswer);
    }
    
    if(activeScreen == "result-screen"){
      screen = ResultScreen(selectedAnswers, restartQuiz);
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
          child: screen,
        ),
      ),
    );
  }
}