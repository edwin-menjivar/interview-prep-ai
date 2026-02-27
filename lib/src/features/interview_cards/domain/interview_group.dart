import 'interview_field.dart';

class InterviewGroup {
  const InterviewGroup({
    required this.id,
    required this.title,
    required this.field,
    required this.description,
  });

  final String id;
  final String title;
  final InterviewField field;
  final String description;

  InterviewGroup copyWith({
    String? id,
    String? title,
    InterviewField? field,
    String? description,
  }) {
    return InterviewGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      field: field ?? this.field,
      description: description ?? this.description,
    );
  }
}
