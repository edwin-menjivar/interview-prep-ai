import '../data/bookmark_store.dart';
import '../data/interview_card_repository.dart';
import '../domain/interview_card.dart';
import '../domain/interview_field.dart';

class InterviewCardsController {
  InterviewCardsController({
    required InterviewCardRepository repository,
    required BookmarkStore bookmarkStore,
  })  : _repository = repository,
        _bookmarkStore = bookmarkStore;

  final InterviewCardRepository _repository;
  final BookmarkStore _bookmarkStore;

  List<InterviewCard> _allCards = <InterviewCard>[];
  Set<String> _bookmarkedIds = <String>{};
  InterviewField? _selectedField;
  String _query = '';
  bool _bookmarkedOnly = false;
  bool _isLoading = false;
  String? _error;

  List<InterviewCard> get visibleCards => _allCards.where((card) {
        final fieldOk = _selectedField == null || card.field == _selectedField;
        final queryLower = _query.trim().toLowerCase();
        final questionHit = card.question.toLowerCase().contains(queryLower);
        final tagsHit = card.tags.any((tag) => tag.toLowerCase().contains(queryLower));
        final queryOk = queryLower.isEmpty || questionHit || tagsHit;
        final bookmarkedOk = !_bookmarkedOnly || _bookmarkedIds.contains(card.id);

        return fieldOk && queryOk && bookmarkedOk;
      }).toList(growable: false);

  bool get isLoading => _isLoading;
  String? get error => _error;
  InterviewField? get selectedField => _selectedField;
  bool get bookmarkedOnly => _bookmarkedOnly;
  Set<String> get bookmarkedIds => _bookmarkedIds;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    try {
      _allCards = await _repository.fetchCards();
      _bookmarkedIds = await _bookmarkStore.load();
    } catch (_) {
      _error = 'Could not load interview cards. Try again.';
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    await initialize();
  }

  void setField(InterviewField? field) {
    _selectedField = field;
  }

  void setQuery(String query) {
    _query = query;
  }

  void setBookmarkedOnly(bool value) {
    _bookmarkedOnly = value;
  }

  bool isBookmarked(String cardId) => _bookmarkedIds.contains(cardId);

  Future<void> toggleBookmark(String cardId) async {
    if (_bookmarkedIds.contains(cardId)) {
      _bookmarkedIds.remove(cardId);
    } else {
      _bookmarkedIds.add(cardId);
    }

    try {
      await _bookmarkStore.save(_bookmarkedIds);
    } catch (_) {
      _error = 'Bookmark update failed. Try again.';
    }
  }
}
