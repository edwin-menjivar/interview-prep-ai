import 'package:flutter/material.dart';

import '../../domain/interview_card.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({
    super.key,
    required this.cards,
    required this.initialIndex,
  });

  final List<InterviewCard> cards;
  final int initialIndex;

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_index];

    return Scaffold(
      appBar: AppBar(title: const Text('Card View')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  card.cardTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _Section(title: 'Priority 1', content: card.priorityOne),
                if (card.priorityTwo.isNotEmpty)
                  _Section(title: 'Priority 2', content: card.priorityTwo),
                if (card.priorityThree.isNotEmpty)
                  _Section(title: 'Priority 3', content: card.priorityThree),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _index == 0
                    ? null
                    : () => setState(() {
                          _index--;
                        }),
                iconSize: 36,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 30),
              Text('${_index + 1}/${widget.cards.length}'),
              const SizedBox(width: 30),
              IconButton(
                onPressed: _index == widget.cards.length - 1
                    ? null
                    : () => setState(() {
                          _index++;
                        }),
                iconSize: 36,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF8FAFC),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(content),
          ],
        ),
      ),
    );
  }
}
