class QuizQuestion{
  const QuizQuestion(this.question, this.answers);

  final String question;
  final List<String> answers;

  List<String> getShuffledAnswers(){
    List<String> shuffledAnswers = List.of(answers); // List.of() is used to make a copy of the list
    shuffledAnswers.shuffle();  // It will shuffled the original list. that's why me made a copy of the list
    return shuffledAnswers; 
  }
}