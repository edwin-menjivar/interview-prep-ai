import '../domain/interview_card.dart';

abstract interface class InterviewCardRepository {
  Future<List<InterviewCard>> fetchCards();
}
