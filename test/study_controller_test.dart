import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/src/features/interview_cards/application/interview_cards_controller.dart';
import 'package:interview_cards_pro/src/features/interview_cards/data/interview_card_repository.dart';
import 'package:interview_cards_pro/src/features/interview_cards/domain/interview_card.dart';
import 'package:interview_cards_pro/src/features/interview_cards/domain/interview_field.dart';
import 'package:interview_cards_pro/src/features/interview_cards/domain/interview_group.dart';

class FakeRepo implements InterviewCardRepository {
  List<InterviewGroup> groups = const [
    InterviewGroup(
      id: 'g1',
      title: 'SWE',
      field: InterviewField.softwareEngineering,
      description: 'desc',
    ),
  ];

  List<InterviewCard> cards = const [
    InterviewCard(
      id: 'c1',
      groupId: 'g1',
      cardTitle: 'Question',
      priorityOne: 'One',
      priorityTwo: 'Two',
      priorityThree: 'Three',
    ),
  ];

  @override
  Future<List<InterviewCard>> loadCards() async => cards;

  @override
  Future<List<InterviewGroup>> loadGroups() async => groups;

  @override
  Future<void> saveCards(List<InterviewCard> cards) async {
    this.cards = cards;
  }

  @override
  Future<void> saveGroups(List<InterviewGroup> groups) async {
    this.groups = groups;
  }
}

void main() {
  test('initialize loads groups and cards', () async {
    final repo = FakeRepo();
    final controller = StudyController(repo);

    await controller.initialize();

    expect(controller.state.groups.length, 1);
    expect(controller.state.cards.length, 1);
    expect(controller.state.isLoading, isFalse);
  });

  test('add card persists and appears in group', () async {
    final repo = FakeRepo();
    final controller = StudyController(repo);
    await controller.initialize();

    await controller.addCard(
      groupId: 'g1',
      cardTitle: 'New',
      priorityOne: 'A',
      priorityTwo: 'B',
      priorityThree: 'C',
    );

    expect(controller.cardsForGroup('g1').length, 2);
    expect(repo.cards.length, 2);
  });

  test('delete group removes dependent cards', () async {
    final repo = FakeRepo();
    final controller = StudyController(repo);
    await controller.initialize();

    await controller.deleteGroup('g1');

    expect(controller.state.groups, isEmpty);
    expect(controller.state.cards, isEmpty);
  });
}
