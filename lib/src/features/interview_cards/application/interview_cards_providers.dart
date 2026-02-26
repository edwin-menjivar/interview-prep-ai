import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bookmark_store.dart';
import '../data/interview_card_repository.dart';
import '../data/seed_interview_card_repository.dart';
import 'interview_cards_controller.dart';

final interviewCardRepositoryProvider = Provider<InterviewCardRepository>((ref) {
  return SeedInterviewCardRepository();
});

final bookmarkStoreProvider = Provider<BookmarkStore>((ref) {
  return SharedPrefsBookmarkStore();
});

final interviewCardsControllerProvider = Provider<InterviewCardsController>((ref) {
  return InterviewCardsController(
    repository: ref.watch(interviewCardRepositoryProvider),
    bookmarkStore: ref.watch(bookmarkStoreProvider),
  );
});
