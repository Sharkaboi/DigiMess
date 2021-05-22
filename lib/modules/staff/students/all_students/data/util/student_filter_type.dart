enum StudentFilterType { VEG, NONVEG, BOTH }

extension FilterExtension on StudentFilterType {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
