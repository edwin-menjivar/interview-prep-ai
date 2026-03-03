import 'package:flutter/material.dart';

import '../../application/practice_session_evaluator.dart';
import '../../domain/interview_card.dart';

class PracticeSessionScreen extends StatefulWidget {
  const PracticeSessionScreen({
    super.key,
    required this.groupTitle,
    required this.cards,
  });

  final String groupTitle;
  final List<InterviewCard> cards;

  @override
  State<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  late final List<InterviewCard> _cards;
  late final List<int?> _ratings;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _cards = [...widget.cards]..shuffle();
    _ratings = List<int?>.filled(_cards.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final done = _ratings.whereType<int>().length;
    final current = _cards[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice: ${widget.groupTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _cards.isEmpty ? 0 : done / _cards.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 10),
            Text('Card ${_index + 1} of ${_cards.length}'),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(
                        current.cardTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      _Block(label: 'Priority 1', text: current.priorityOne),
                      if (current.priorityTwo.isNotEmpty)
                        _Block(label: 'Priority 2', text: current.priorityTwo),
                      if (current.priorityThree.isNotEmpty)
                        _Block(label: 'Priority 3', text: current.priorityThree),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => _setRating(1),
                  child: const Text('Needs Work'),
                ),
                FilledButton.tonal(
                  onPressed: () => _setRating(2),
                  child: const Text('Solid'),
                ),
                FilledButton(
                  onPressed: () => _setRating(3),
                  child: const Text('Strong'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _index == 0
                      ? null
                      : () => setState(() {
                            _index--;
                          }),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                TextButton.icon(
                  onPressed: _index == _cards.length - 1
                      ? null
                      : () => setState(() {
                            _index++;
                          }),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: done == _cards.length ? _showSummary : null,
                icon: const Icon(Icons.flag),
                label: const Text('Finish Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setRating(int rating) {
    setState(() {
      _ratings[_index] = rating;
      if (_index < _cards.length - 1) {
        _index++;
      }
    });
  }

  Future<void> _showSummary() async {
    final score = PracticeSessionEvaluator.calculate(_ratings);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completion: ${score.completionPercent}%'),
            Text('Confidence: ${score.confidencePercent}%'),
            const SizedBox(height: 8),
            Text('Strong: ${score.strong}'),
            Text('Solid: ${score.solid}'),
            Text('Needs Work: ${score.needsWork}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
