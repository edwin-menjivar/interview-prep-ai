import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/interview_card.dart';
import '../domain/interview_field.dart';
import '../domain/interview_group.dart';
import 'interview_card_repository.dart';

class SeedInterviewCardRepository implements InterviewCardRepository {
  static const _groupsKey = 'hiredeck.groups.v1';
  static const _cardsKey = 'hiredeck.cards.v1';

  @override
  Future<List<InterviewCard>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cardsKey);
    if (raw == null || raw.isEmpty) {
      return _seedCards;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return _seedCards;
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => InterviewCard(
            id: json['id'] as String,
            groupId: json['groupId'] as String,
            cardTitle: json['cardTitle'] as String,
            priorityOne: json['priorityOne'] as String? ?? '',
            priorityTwo: json['priorityTwo'] as String? ?? '',
            priorityThree: json['priorityThree'] as String? ?? '',
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<InterviewGroup>> loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_groupsKey);
    if (raw == null || raw.isEmpty) {
      return _seedGroups;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return _seedGroups;
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => InterviewGroup(
            id: json['id'] as String,
            title: json['title'] as String,
            field: InterviewField.values.firstWhere(
              (f) => f.name == json['field'],
              orElse: () => InterviewField.softwareEngineering,
            ),
            description: json['description'] as String? ?? '',
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveCards(List<InterviewCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cardsKey,
      jsonEncode(
        cards
            .map(
              (card) => {
                'id': card.id,
                'groupId': card.groupId,
                'cardTitle': card.cardTitle,
                'priorityOne': card.priorityOne,
                'priorityTwo': card.priorityTwo,
                'priorityThree': card.priorityThree,
              },
            )
            .toList(growable: false),
      ),
    );
  }

  @override
  Future<void> saveGroups(List<InterviewGroup> groups) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _groupsKey,
      jsonEncode(
        groups
            .map(
              (group) => {
                'id': group.id,
                'title': group.title,
                'field': group.field.name,
                'description': group.description,
              },
            )
            .toList(growable: false),
      ),
    );
  }
}

const List<InterviewGroup> _seedGroups = [
  InterviewGroup(
    id: 'group_se_behavioral',
    title: 'SWE Behavioral',
    field: InterviewField.softwareEngineering,
    description: 'Ownership, conflict, incidents, and leadership stories.',
  ),
  InterviewGroup(
    id: 'group_se_systems',
    title: 'SWE System Design',
    field: InterviewField.softwareEngineering,
    description: 'Scalability, tradeoffs, APIs, and production readiness.',
  ),
  InterviewGroup(
    id: 'group_pm_core',
    title: 'PM Core Interview',
    field: InterviewField.productManagement,
    description: 'Prioritization, metrics, roadmap, and strategy prompts.',
  ),
];

const List<InterviewCard> _seedCards = [
  InterviewCard(
    id: 'card_1',
    groupId: 'group_se_behavioral',
    cardTitle: 'Tell me about a production incident you owned.',
    priorityOne:
        'Situation + impact. Clarify urgency and customer blast radius in 1-2 sentences.',
    priorityTwo:
        'Actions: mitigation, communication, and timeline. Show cross-team leadership.',
    priorityThree:
        'Outcome + learning: root cause fix and what you changed to prevent recurrence.',
  ),
  InterviewCard(
    id: 'card_2',
    groupId: 'group_se_systems',
    cardTitle: 'Design a URL shortener.',
    priorityOne:
        'Requirements and scale assumptions. Define read/write ratio and latency targets.',
    priorityTwo:
        'Core architecture, data model, sharding, cache, and failure handling.',
    priorityThree:
        'Tradeoffs and rollout plan. Add observability and anti-abuse strategy.',
  ),
  InterviewCard(
    id: 'card_3',
    groupId: 'group_pm_core',
    cardTitle: 'How do you prioritize roadmap items?',
    priorityOne:
        'Define objective and user problem. Show measurable business outcome.',
    priorityTwo:
        'Use a scoring framework with impact, confidence, effort, and strategic alignment.',
    priorityThree:
        'Share stakeholder alignment and what you de-prioritized with reasoning.',
  ),
];
