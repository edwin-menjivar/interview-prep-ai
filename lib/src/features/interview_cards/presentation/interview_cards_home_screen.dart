import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/interview_cards_controller.dart';
import '../application/interview_cards_providers.dart';
import '../domain/interview_field.dart';
import 'interview_card_detail_screen.dart';

class InterviewCardsHomeScreen extends ConsumerStatefulWidget {
  const InterviewCardsHomeScreen({super.key});

  static const routeName = '/';

  @override
  ConsumerState<InterviewCardsHomeScreen> createState() =>
      _InterviewCardsHomeScreenState();
}

class _InterviewCardsHomeScreenState
    extends ConsumerState<InterviewCardsHomeScreen> {
  late final InterviewCardsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(interviewCardsControllerProvider);
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _refresh() async {
    await _controller.refresh();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = _controller.visibleCards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Cards Pro'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload cards',
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_controller.error!),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search by question or tag',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() => _controller.setQuery(value));
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _controller.selectedField == null,
                            onSelected: (_) {
                              setState(() => _controller.setField(null));
                            },
                          ),
                          const SizedBox(width: 8),
                          ...InterviewField.values.map(
                            (field) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(field.label),
                                selected: _controller.selectedField == field,
                                onSelected: (_) {
                                  setState(() => _controller.setField(field));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Show bookmarked only'),
                      value: _controller.bookmarkedOnly,
                      onChanged: (value) {
                        setState(() => _controller.setBookmarkedOnly(value));
                      },
                    ),
                    Expanded(
                      child: cards.isEmpty
                          ? const Center(
                              child: Text(
                                'No cards match this filter yet.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
                                final card = cards[index];
                                final bookmarked =
                                    _controller.isBookmarked(card.id);
                                return Card(
                                  child: ListTile(
                                    title: Text(card.question),
                                    subtitle: Text(
                                      card.field.label +
                                          ' • Difficulty ' +
                                          card.difficulty.toString() +
                                          '/5',
                                    ),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        await _controller
                                            .toggleBookmark(card.id);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        bookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        InterviewCardDetailScreen.routeName,
                                        arguments: card,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
