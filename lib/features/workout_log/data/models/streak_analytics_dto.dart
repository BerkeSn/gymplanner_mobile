import 'package:gymplanner_mobile/features/workout_log/domain/entites/streak_analytics_entity.dart';

class StreakAnalyticsDto {
  final int currentStreak;
  final int longestStreak;
  final int totalActiveDays;
  final List<String> activeDates;

  StreakAnalyticsDto({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActiveDays,
    required this.activeDates,
  });

  factory StreakAnalyticsDto.fromJson(Map<String, dynamic> json) {
    try {
      return StreakAnalyticsDto(
        currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int,
        totalActiveDays: json['totalActiveDays'] as int,
        activeDates: (json['activeDates'] as List<dynamic>).cast<String>(),
      );
    } catch (error, stackTrace) {
      throw Exception(
          '[StreakAnalyticsDto - fromJson]: ${error.toString()}\n$stackTrace');
    }
  }

  StreakAnalyticsEntity toEntity() {
    final parsedDates = activeDates
        .map((s) => DateTime.tryParse(s))
        .whereType<DateTime>()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
    return StreakAnalyticsEntity(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalActiveDays: totalActiveDays,
      activeDates: parsedDates,
    );
  }
}