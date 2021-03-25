enum ComplaintType { HYGIENE, TASTE, SERVICE, PORTION, APP, OTHER }

extension ComplaintTypeExtensions on ComplaintType {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static ComplaintType fromString(String formattedString) {
    switch (formattedString) {
      case "HYGIENE":
        return ComplaintType.HYGIENE;
      case "TASTE":
        return ComplaintType.TASTE;
      case "SERVICE":
        return ComplaintType.SERVICE;
      case "PORTION":
        return ComplaintType.PORTION;
      case "APP":
        return ComplaintType.APP;
      case "OTHER":
        return ComplaintType.OTHER;
      default:
        return null;
    }
  }
}
