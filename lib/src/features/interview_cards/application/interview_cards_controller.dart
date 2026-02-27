import '../data/interview_card_repository.dart';
import '../domain/interview_card.dart';
import '../domain/interview_field.dart';
import '../domain/interview_group.dart';

class StudyState {
  const StudyState({
    required this.isLoading,
    required this.groups,
    required this.cards,
    this.error,
    this.selectedField,
  });

  final bool isLoading;
  final List<InterviewGroup> groups;
  final List<InterviewCard> cards;
  final String? error;
  final InterviewField? selectedField;

  StudyState copyWith({
    bool? isLoading,
    List<InterviewGroup>? groups,
    List<InterviewCard>? cards,
    String? error,
    InterviewField? selectedField,
    bool resetError = false,
  }) {
    return StudyState(
      isLoading: isLoading ?? this.isLoading,
      groups: groups ?? this.groups,
      cards: cards ?? this.cards,
      error: resetError ? null : error ?? this.error,
      selectedField: selectedField ?? this.selectedField,
    );
  }
}

class StudyController {
  StudyController(this._repository)
      : state = const StudyState(
          isLoading: true,
          groups: <InterviewGroup>[],
          cards: <InterviewCard>[],
        );

  final InterviewCardRepository _repository;
  StudyState state;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, resetError: true);
    try {
      final groups = await _repository.loadGroups();
      final cards = await _repository.loadCards();
      state = state.copyWith(
        isLoading: false,
        groups: groups,
        cards: cards,
        resetError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Could not load interview data. Try again.',
      );
    }
  }

  List<InterviewGroup> get visibleGroups {
    if (state.selectedField == null) {
      return state.groups;
    }
    return state.groups
        .where((group) => group.field == state.selectedField)
        .toList(growable: false);
  }

  List<InterviewCard> cardsForGroup(String groupId) {
    return state.cards
        .where((card) => card.groupId == groupId)
        .toList(growable: false);
  }

  void setField(InterviewField? field) {
    state = state.copyWith(selectedField: field, resetError: true);
  }

  Future<void> addGroup({
    required String title,
    required InterviewField field,
    required String description,
  }) async {
    final group = InterviewGroup(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      field: field,
      description: description.trim(),
    );

    final updated = [...state.groups, group];
    state = state.copyWith(groups: updated, resetError: true);
    await _repository.saveGroups(updated);
  }

  Future<void> updateGroup({
    required String groupId,
    required String title,
    required InterviewField field,
    required String description,
  }) async {
    final updated = state.groups
        .map(
          (group) => group.id == groupId
              ? group.copyWith(
                  title: title.trim(),
                  field: field,
                  description: description.trim(),
                )
              : group,
        )
        .toList(growable: false);

    state = state.copyWith(groups: updated, resetError: true);
    await _repository.saveGroups(updated);
  }

  Future<void> deleteGroup(String groupId) async {
    final updatedGroups =
        state.groups.where((group) => group.id != groupId).toList(growable: false);
    final updatedCards =
        state.cards.where((card) => card.groupId != groupId).toList(growable: false);

    state = state.copyWith(
      groups: updatedGroups,
      cards: updatedCards,
      resetError: true,
    );
    await _repository.saveGroups(updatedGroups);
    await _repository.saveCards(updatedCards);
  }

  Future<void> addCard({
    required String groupId,
    required String cardTitle,
    required String priorityOne,
    required String priorityTwo,
    required String priorityThree,
  }) async {
    final card = InterviewCard(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      groupId: groupId,
      cardTitle: cardTitle.trim(),
      priorityOne: priorityOne.trim(),
      priorityTwo: priorityTwo.trim(),
      priorityThree: priorityThree.trim(),
    );

    final updated = [...state.cards, card];
    state = state.copyWith(cards: updated, resetError: true);
    await _repository.saveCards(updated);
  }

  Future<void> updateCard({
    required String cardId,
    required String cardTitle,
    required String priorityOne,
    required String priorityTwo,
    required String priorityThree,
  }) async {
    final updated = state.cards
        .map(
          (card) => card.id == cardId
              ? card.copyWith(
                  cardTitle: cardTitle.trim(),
                  priorityOne: priorityOne.trim(),
                  priorityTwo: priorityTwo.trim(),
                  priorityThree: priorityThree.trim(),
                )
              : card,
        )
        .toList(growable: false);

    state = state.copyWith(cards: updated, resetError: true);
    await _repository.saveCards(updated);
  }

  Future<void> deleteCard(String cardId) async {
    final updated =
        state.cards.where((card) => card.id != cardId).toList(growable: false);
    state = state.copyWith(cards: updated, resetError: true);
    await _repository.saveCards(updated);
  }
}
