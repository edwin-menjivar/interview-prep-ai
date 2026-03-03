class PracticeSessionScore {
  const PracticeSessionScore({
    required this.total,
    required this.strong,
    required this.solid,
    required this.needsWork,
  });

  final int total;
  final int strong;
  final int solid;
  final int needsWork;

  int get completionPercent {
    if (total == 0) return 0;
    return ((strong + solid + needsWork) * 100 / total).round();
  }

  int get confidencePercent {
    if (total == 0) return 0;
    final weighted = (strong * 100) + (solid * 70) + (needsWork * 35);
    return (weighted / total).round();
  }
}

class PracticeSessionEvaluator {
  static PracticeSessionScore calculate(List<int?> ratings) {
    var strong = 0;
    var solid = 0;
    var needsWork = 0;

    for (final rating in ratings) {
      switch (rating) {
        case 3:
          strong++;
        case 2:
          solid++;
        case 1:
          needsWork++;
        default:
          break;
      }
    }

    return PracticeSessionScore(
      total: ratings.length,
      strong: strong,
      solid: solid,
      needsWork: needsWork,
    );
  }
}
