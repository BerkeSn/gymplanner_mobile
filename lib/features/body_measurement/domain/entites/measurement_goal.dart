// entities/measurement_goal.dart

enum MeasurementGoal {
  loseWeight,
  gainMuscle,
  maintain,
}

extension MeasurementGoalX on MeasurementGoal {
  String get apiValue {
    switch (this) {
      case MeasurementGoal.loseWeight:
        return 'Lose Weight';
      case MeasurementGoal.gainMuscle:
        return 'Gain Muscle';
      case MeasurementGoal.maintain:
        return 'Maintain';
    }
  }

  static MeasurementGoal fromApi(String value) {
    switch (value) {
      case 'Lose Weight':
        return MeasurementGoal.loseWeight;
      case 'Gain Muscle':
        return MeasurementGoal.gainMuscle;
      default:
        return MeasurementGoal.maintain;
    }
  }
}
