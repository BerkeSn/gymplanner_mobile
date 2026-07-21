// entities/week_day.dart

/// Backend'in RoutineExercise.day ENUM'u ile birebir eşleşir.
enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekDayX on WeekDay {
  String get apiValue {
    switch (this) {
      case WeekDay.monday:
        return 'Monday';
      case WeekDay.tuesday:
        return 'Tuesday';
      case WeekDay.wednesday:
        return 'Wednesday';
      case WeekDay.thursday:
        return 'Thursday';
      case WeekDay.friday:
        return 'Friday';
      case WeekDay.saturday:
        return 'Saturday';
      case WeekDay.sunday:
        return 'Sunday';
    }
  }

  String get turkishLabel {
    switch (this) {
      case WeekDay.monday:
        return 'Pazartesi';
      case WeekDay.tuesday:
        return 'Salı';
      case WeekDay.wednesday:
        return 'Çarşamba';
      case WeekDay.thursday:
        return 'Perşembe';
      case WeekDay.friday:
        return 'Cuma';
      case WeekDay.saturday:
        return 'Cumartesi';
      case WeekDay.sunday:
        return 'Pazar';
    }
  }

  static WeekDay fromApi(String value) {
    return WeekDay.values.firstWhere(
      (d) => d.apiValue == value,
      orElse: () => WeekDay.monday,
    );
  }
}
