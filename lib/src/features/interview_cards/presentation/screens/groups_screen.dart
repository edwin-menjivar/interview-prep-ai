import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_providers.dart';
import '../../application/interview_cards_providers.dart';
import '../../domain/interview_field.dart';
import '../../domain/interview_group.dart';
import 'cards_screen.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider);
    final notifier = ref.read(studyControllerProvider.notifier);
    final groups = notifier.visibleGroups;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('HireDeck AI'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGroupEditor(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Group'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SafeArea(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 8),
                    _FieldFilterBar(
                      selected: state.selectedField,
                      onChange: notifier.setField,
                    ),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Expanded(
                      child: groups.isEmpty
                          ? const Center(
                              child: Text(
                                'No groups yet. Create one to start practicing.',
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 6,
                                bottom: 100,
                              ),
                              itemCount: groups.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.95,
                              ),
                              itemBuilder: (context, index) {
                                final group = groups[index];
                                final cardCount = notifier
                                    .cardsForGroup(group.id).length;
                                return _GroupTile(
                                  group: group,
                                  cardCount: cardCount,
                                  onOpen: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CardsScreen(group: group),
                                      ),
                                    );
                                  },
                                  onEdit: () => _showGroupEditor(
                                    context,
                                    ref,
                                    existing: group,
                                  ),
                                  onDelete: () => _confirmDeleteGroup(
                                    context,
                                    ref,
                                    group,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    InterviewGroup group,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete group?'),
        content: Text('This will remove ${group.title} and all cards in it.'),
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
      await ref.read(studyControllerProvider.notifier).deleteGroup(group.id);
    }
  }

  Future<void> _showGroupEditor(
    BuildContext context,
    WidgetRef ref, {
    InterviewGroup? existing,
  }) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descriptionController =
        TextEditingController(text: existing?.description ?? '');
    var selectedField = existing?.field ?? InterviewField.softwareEngineering;
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'Create Group' : 'Update Group',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Group Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<InterviewField>(
                      initialValue: selectedField,
                      items: InterviewField.values
                          .map(
                            (field) => DropdownMenuItem(
                              value: field,
                              child: Text(field.label),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) return;
                        setLocalState(() => selectedField = value);
                      },
                      decoration: const InputDecoration(labelText: 'Field'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final notifier = ref.read(studyControllerProvider.notifier);
                          if (existing == null) {
                            await notifier.addGroup(
                              title: titleController.text,
                              field: selectedField,
                              description: descriptionController.text,
                            );
                          } else {
                            await notifier.updateGroup(
                              groupId: existing.id,
                              title: titleController.text,
                              field: selectedField,
                              description: descriptionController.text,
                            );
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(existing == null ? 'Create' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }
}

class _FieldFilterBar extends StatelessWidget {
  const _FieldFilterBar({
    required this.selected,
    required this.onChange,
  });

  final InterviewField? selected;
  final void Function(InterviewField? field) onChange;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onChange(null),
          ),
          const SizedBox(width: 8),
          ...InterviewField.values.map(
            (field) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(field.label),
                selected: selected == field,
                onSelected: (_) => onChange(field),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.cardCount,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final InterviewGroup group;
  final int cardCount;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFEFF6FF)],
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.field.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                group.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                group.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Text('$cardCount cards'),
                  const Spacer(),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
