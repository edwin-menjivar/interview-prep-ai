import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/interview_card_repository.dart';
import '../data/seed_interview_card_repository.dart';
import '../domain/interview_card.dart';
import '../domain/interview_field.dart';
import '../domain/interview_group.dart';
import 'interview_cards_controller.dart';

final interviewCardRepositoryProvider = Provider<InterviewCardRepository>((ref) {
  return SeedInterviewCardRepository();
});

class StudyControllerNotifier extends StateNotifier<StudyState> {
  StudyControllerNotifier(this._controller) : super(_controller.state) {
    initialize();
  }

  final StudyController _controller;

  Future<void> initialize() async {
    await _controller.initialize();
    state = _controller.state;
  }

  List<InterviewGroup> get visibleGroups => _controller.visibleGroups;

  List<InterviewCard> cardsForGroup(String groupId) =>
      _controller.cardsForGroup(groupId);

  void setField(InterviewField? field) {
    _controller.setField(field);
    state = _controller.state;
  }

  Future<void> addGroup({
    required String title,
    required InterviewField field,
    required String description,
  }) async {
    await _controller.addGroup(
      title: title,
      field: field,
      description: description,
    );
    state = _controller.state;
  }

  Future<void> updateGroup({
    required String groupId,
    required String title,
    required InterviewField field,
    required String description,
  }) async {
    await _controller.updateGroup(
      groupId: groupId,
      title: title,
      field: field,
      description: description,
    );
    state = _controller.state;
  }

  Future<void> deleteGroup(String groupId) async {
    await _controller.deleteGroup(groupId);
    state = _controller.state;
  }

  Future<void> addCard({
    required String groupId,
    required String cardTitle,
    required String priorityOne,
    required String priorityTwo,
    required String priorityThree,
  }) async {
    await _controller.addCard(
      groupId: groupId,
      cardTitle: cardTitle,
      priorityOne: priorityOne,
      priorityTwo: priorityTwo,
      priorityThree: priorityThree,
    );
    state = _controller.state;
  }

  Future<void> updateCard({
    required String cardId,
    required String cardTitle,
    required String priorityOne,
    required String priorityTwo,
    required String priorityThree,
  }) async {
    await _controller.updateCard(
      cardId: cardId,
      cardTitle: cardTitle,
      priorityOne: priorityOne,
      priorityTwo: priorityTwo,
      priorityThree: priorityThree,
    );
    state = _controller.state;
  }

  Future<void> deleteCard(String cardId) async {
    await _controller.deleteCard(cardId);
    state = _controller.state;
  }
}

final studyControllerProvider =
    StateNotifierProvider<StudyControllerNotifier, StudyState>((ref) {
  final controller = StudyController(ref.watch(interviewCardRepositoryProvider));
  return StudyControllerNotifier(controller);
});
