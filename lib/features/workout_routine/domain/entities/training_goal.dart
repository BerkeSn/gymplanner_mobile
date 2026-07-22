// features/workout_routine/domain/entities/training_goal.dart

enum TrainingGoal {
  hypertrophy,
  strength,
  endurance,
  fatLoss,
}

extension TrainingGoalX on TrainingGoal {
  String get apiValue {
    switch (this) {
      case TrainingGoal.hypertrophy:
        return 'Hypertrophy';
      case TrainingGoal.strength:
        return 'Strength';
      case TrainingGoal.endurance:
        return 'Endurance';
      case TrainingGoal.fatLoss:
        return 'Fat Loss';
    }
  }

  String get turkishLabel {
    switch (this) {
      case TrainingGoal.hypertrophy:
        return 'Kas Gelişimi';
      case TrainingGoal.strength:
        return 'Kuvvet';
      case TrainingGoal.endurance:
        return 'Dayanıklılık';
      case TrainingGoal.fatLoss:
        return 'Yağ Yakımı';
    }
  }

  static TrainingGoal fromApi(String value) {
    return TrainingGoal.values.firstWhere(
      (g) => g.apiValue == value,
      orElse: () => TrainingGoal.hypertrophy,
    );
  }
}
