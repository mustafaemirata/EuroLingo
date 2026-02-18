class GrammarTopic {
  final String id;
  final String title;
  final String level; 
  final String explanation;
  final List<GrammarExample> examples;
  final List<GrammarQuizQuestion> quizQuestions;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.level,
    required this.explanation,
    required this.examples,
    this.quizQuestions = const [],
  });
}

class GrammarExample {
  final String en;
  final String tr;
  final String? note;

  const GrammarExample({required this.en, required this.tr, this.note});
}

class GrammarQuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const GrammarQuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
