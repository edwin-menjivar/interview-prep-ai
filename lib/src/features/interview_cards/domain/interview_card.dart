class InterviewCard {
  const InterviewCard({
    required this.id,
    required this.groupId,
    required this.cardTitle,
    required this.priorityOne,
    required this.priorityTwo,
    required this.priorityThree,
  });

  final String id;
  final String groupId;
  final String cardTitle;
  final String priorityOne;
  final String priorityTwo;
  final String priorityThree;

  InterviewCard copyWith({
    String? id,
    String? groupId,
    String? cardTitle,
    String? priorityOne,
    String? priorityTwo,
    String? priorityThree,
  }) {
    return InterviewCard(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      cardTitle: cardTitle ?? this.cardTitle,
      priorityOne: priorityOne ?? this.priorityOne,
      priorityTwo: priorityTwo ?? this.priorityTwo,
      priorityThree: priorityThree ?? this.priorityThree,
    );
  }
}
