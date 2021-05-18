enum MealTiming { BREAKFAST, LUNCH, DINNER }

extension MealTimingExtensions on MealTiming {
  String toStringValue() {
    return this
        .toString()
        .split('.')
        .last;
  }
}