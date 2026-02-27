import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/interview_cards_providers.dart';
import '../../domain/interview_card.dart';
import '../../domain/interview_group.dart';
import 'card_detail_screen.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key, required this.group});

  final InterviewGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(studyControllerProvider.notifier);
    final cards = notifier.cardsForGroup(group.id).cast<InterviewCard>();

    return Scaffold(
      appBar: AppBar(
        title: Text(group.title),
        actions: [
          IconButton(
            onPressed: () => _showCardEditor(context, ref, group.id),
            icon: const Icon(Icons.add),
            tooltip: 'Add card',
          ),
        ],
      ),
      body: cards.isEmpty
          ? const Center(
              child: Text('No cards yet. Press + to add your first one.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CardDetailScreen(
                            cards: cards,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.cardTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              card.priorityOne,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _showCardEditor(
                                  context,
                                  ref,
                                  group.id,
                                  existing: card,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: () => _confirmDeleteCard(
                                  context,
                                  ref,
                                  card,
                                ),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _confirmDeleteCard(
    BuildContext context,
    WidgetRef ref,
    InterviewCard card,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete card?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ref.read(studyControllerProvider.notifier).deleteCard(card.id);
    }
  }

  Future<void> _showCardEditor(
    BuildContext context,
    WidgetRef ref,
    String groupId, {
    InterviewCard? existing,
  }) async {
    final titleController = TextEditingController(text: existing?.cardTitle ?? '');
    final priorityOneController =
        TextEditingController(text: existing?.priorityOne ?? '');
    final priorityTwoController =
        TextEditingController(text: existing?.priorityTwo ?? '');
    final priorityThreeController =
        TextEditingController(text: existing?.priorityThree ?? '');
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  existing == null ? 'Create Card' : 'Update Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Prompt'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Prompt is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priorityOneController,
                  decoration: const InputDecoration(labelText: 'Priority 1'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Priority 1 is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priorityTwoController,
                  decoration: const InputDecoration(labelText: 'Priority 2'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priorityThreeController,
                  decoration: const InputDecoration(labelText: 'Priority 3'),
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final notifier = ref.read(studyControllerProvider.notifier);
                    if (existing == null) {
                      await notifier.addCard(
                        groupId: groupId,
                        cardTitle: titleController.text,
                        priorityOne: priorityOneController.text,
                        priorityTwo: priorityTwoController.text,
                        priorityThree: priorityThreeController.text,
                      );
                    } else {
                      await notifier.updateCard(
                        cardId: existing.id,
                        cardTitle: titleController.text,
                        priorityOne: priorityOneController.text,
                        priorityTwo: priorityTwoController.text,
                        priorityThree: priorityThreeController.text,
                      );
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(existing == null ? 'Create' : 'Save'),
                ),
              ],
            ),
          ),
        );
      },
    );

    titleController.dispose();
    priorityOneController.dispose();
    priorityTwoController.dispose();
    priorityThreeController.dispose();
  }
}
