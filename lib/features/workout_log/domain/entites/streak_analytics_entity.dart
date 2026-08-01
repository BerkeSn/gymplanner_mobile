class StreakAnalyticsEntity {
  final int currentStreak;
  final int longestStreak;
  final int totalActiveDays;
  final Set<DateTime> activeDates;

  const StreakAnalyticsEntity({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActiveDays,
    required this.activeDates,
  });

  bool isActiveOn(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return activeDates.contains(normalized);
  }
}