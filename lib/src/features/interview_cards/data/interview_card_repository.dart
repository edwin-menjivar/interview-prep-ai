import '../domain/interview_card.dart';
import '../domain/interview_group.dart';

abstract interface class InterviewCardRepository {
  Future<List<InterviewGroup>> loadGroups();
  Future<List<InterviewCard>> loadCards();
  Future<void> saveGroups(List<InterviewGroup> groups);
  Future<void> saveCards(List<InterviewCard> cards);
}
