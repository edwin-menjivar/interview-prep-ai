import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/src/features/interview_cards/application/interview_cards_controller.dart';
import 'package:interview_cards_pro/src/features/interview_cards/data/bookmark_store.dart';
import 'package:interview_cards_pro/src/features/interview_cards/data/seed_interview_card_repository.dart';
import 'package:interview_cards_pro/src/features/interview_cards/domain/interview_field.dart';

class InMemoryBookmarkStore implements BookmarkStore {
  Set<String> saved = <String>{};

  @override
  Future<Set<String>> load() async => saved;

  @override
  Future<void> save(Set<String> ids) async {
    saved = ids;
  }
}

void main() {
  test('seed repository includes at least two career fields', () async {
    final repo = SeedInterviewCardRepository();
    final cards = await repo.fetchCards();
    final fields = cards.map((e) => e.field).toSet();

    expect(fields.contains(InterviewField.softwareEngineering), isTrue);
    expect(fields.contains(InterviewField.productManagement), isTrue);
    expect(cards.length, greaterThanOrEqualTo(8));
  });

  test('controller filters by field and search query', () async {
    final store = InMemoryBookmarkStore();
    final controller = InterviewCardsController(
      repository: SeedInterviewCardRepository(),
      bookmarkStore: store,
    );

    await controller.initialize();
    controller.setField(InterviewField.productManagement);
    controller.setQuery('metrics');

    final visible = controller.visibleCards;
    expect(visible.isNotEmpty, isTrue);
    expect(
      visible.every((c) => c.field == InterviewField.productManagement),
      isTrue,
    );
    expect(
      visible.every(
        (c) =>
            c.question.toLowerCase().contains('metrics') ||
            c.tags.any((tag) => tag.toLowerCase().contains('metrics')),
      ),
      isTrue,
    );
  });

  test('controller toggles bookmark persistence', () async {
    final store = InMemoryBookmarkStore();
    final controller = InterviewCardsController(
      repository: SeedInterviewCardRepository(),
      bookmarkStore: store,
    );

    await controller.initialize();
    await controller.toggleBookmark('se_01');

    expect(controller.bookmarkedIds.contains('se_01'), isTrue);
    expect(store.saved.contains('se_01'), isTrue);
  });
}
