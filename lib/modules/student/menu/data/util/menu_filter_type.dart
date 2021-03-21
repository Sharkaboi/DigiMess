enum MenuFilterType { VEG, NONVEG, BOTH}

extension FilterExtension on MenuFilterType{
  String toStringValue() {
    return this.toString().split('.').last;
  }
}