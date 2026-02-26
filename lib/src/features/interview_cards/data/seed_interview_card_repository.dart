import '../domain/interview_card.dart';
import '../domain/interview_field.dart';
import 'interview_card_repository.dart';

class SeedInterviewCardRepository implements InterviewCardRepository {
  @override
  Future<List<InterviewCard>> fetchCards() async {
    return const [
      InterviewCard(
        id: 'se_01',
        field: InterviewField.softwareEngineering,
        question: 'Tell me about a system you designed end-to-end.',
        strongAnswer:
            'Define scope, constraints, tradeoffs, architecture, rollout, metrics, and post-launch improvements.',
        redFlags:
            'Only describing coding details without architecture or tradeoff reasoning.',
        tags: ['system design', 'architecture', 'ownership'],
        difficulty: 4,
      ),
      InterviewCard(
        id: 'se_02',
        field: InterviewField.softwareEngineering,
        question: 'How do you handle production incidents?',
        strongAnswer:
            'Stabilize first, communicate impact, identify root cause, ship corrective action, and prevent recurrence with runbooks.',
        redFlags: 'Blaming others, no incident timeline, or no prevention plan.',
        tags: ['incident response', 'ops', 'leadership'],
        difficulty: 3,
      ),
      InterviewCard(
        id: 'se_03',
        field: InterviewField.softwareEngineering,
        question: 'Describe a difficult technical decision you made.',
        strongAnswer:
            'Compare options with explicit tradeoffs, justify the final choice, and quantify outcomes after launch.',
        redFlags: 'Decision made by preference only, no measurable impact.',
        tags: ['tradeoffs', 'decision making'],
        difficulty: 3,
      ),
      InterviewCard(
        id: 'se_04',
        field: InterviewField.softwareEngineering,
        question: 'How do you ensure code quality at scale?',
        strongAnswer:
            'Use linting, tests, CI checks, clear code ownership, and change management standards.',
        redFlags: 'Reliance on manual review only or skipping tests under pressure.',
        tags: ['quality', 'testing', 'ci/cd'],
        difficulty: 2,
      ),
      InterviewCard(
        id: 'pm_01',
        field: InterviewField.productManagement,
        question: 'How do you prioritize roadmap items?',
        strongAnswer:
            'Tie goals to business outcomes, score opportunities, align stakeholders, and sequence by impact/risk.',
        redFlags: 'Feature-first thinking without user problem clarity or metrics.',
        tags: ['roadmap', 'prioritization', 'strategy'],
        difficulty: 3,
      ),
      InterviewCard(
        id: 'pm_02',
        field: InterviewField.productManagement,
        question: 'How would you launch a new feature with limited data?',
        strongAnswer:
            'Frame hypotheses, define success metrics, ship MVP, and iterate using structured feedback loops.',
        redFlags: 'No experiment design, no rollback plan, no measurable KPI.',
        tags: ['go-to-market', 'experimentation'],
        difficulty: 4,
      ),
      InterviewCard(
        id: 'pm_03',
        field: InterviewField.productManagement,
        question: 'Tell me about a time engineering pushed back on your plan.',
        strongAnswer:
            'Show alignment process: problem reframing, constraints review, compromise, and measurable shared outcome.',
        redFlags: 'Escalation-only behavior or ignoring engineering constraints.',
        tags: ['cross-functional', 'leadership'],
        difficulty: 3,
      ),
      InterviewCard(
        id: 'pm_04',
        field: InterviewField.productManagement,
        question: 'What metrics do you use to judge product success?',
        strongAnswer:
            'Track north-star + guardrail metrics, segment users, and connect movement to product decisions.',
        redFlags: 'Vanity metrics only or no causal reasoning.',
        tags: ['metrics', 'analytics'],
        difficulty: 2,
      ),
    ];
  }
}
