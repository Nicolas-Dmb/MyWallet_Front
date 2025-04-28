class QuestionModel {
  QuestionModel({
    required this.question,
    required this.type,
    required this.required,
    required this.defaultValue,
    required this.answers,
    this.answer,
  });

  final String question;
  final String type;
  final bool required;
  final String defaultValue;
  final List<dynamic> answers;
  final dynamic answer;

  static QuestionModel fromJson(Map<String, dynamic> data) {
    return QuestionModel(
      question: data['question'],
      type: data['type'],
      required: data['required'],
      defaultValue: data['default_value'],
      answers: data['answer'],
    );
  }

  QuestionModel setAnswer(dynamic newAnswer) {
    return QuestionModel(
      question: question,
      type: type,
      required: required,
      defaultValue: defaultValue,
      answers: answers,
      answer: newAnswer,
    );
  }
}
