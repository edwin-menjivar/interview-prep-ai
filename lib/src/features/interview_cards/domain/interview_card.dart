import 'interview_field.dart';

class InterviewCard {
  const InterviewCard({
    required this.id,
    required this.field,
    required this.question,
    required this.strongAnswer,
    required this.redFlags,
    required this.tags,
    required this.difficulty,
  });

  final String id;
  final InterviewField field;
  final String question;
  final String strongAnswer;
  final String redFlags;
  final List<String> tags;
  final int difficulty;
}
