// entities/meal_type.dart

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeX on MealType {
  String get apiValue {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  static MealType fromApi(String value) {
    switch (value) {
      case 'Breakfast':
        return MealType.breakfast;
      case 'Lunch':
        return MealType.lunch;
      case 'Dinner':
        return MealType.dinner;
      default:
        return MealType.snack;
    }
  }
}