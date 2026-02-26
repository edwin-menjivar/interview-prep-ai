import 'package:flutter/material.dart';

import '../domain/interview_card.dart';

class InterviewCardDetailScreen extends StatelessWidget {
  const InterviewCardDetailScreen({super.key});

  static const routeName = '/card';

  @override
  Widget build(BuildContext context) {
    final card = ModalRoute.of(context)?.settings.arguments;
    if (card is! InterviewCard) {
      return const Scaffold(
        body: Center(child: Text('Card not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Card Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            card.question,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Strong Answer Framework',
            text: card.strongAnswer,
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Red Flags to Avoid',
            text: card.redFlags,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: card.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
