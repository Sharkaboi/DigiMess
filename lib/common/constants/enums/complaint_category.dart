enum ComplaintCategory { HYGIENE, TASTE, SERVICE, PORTION, APP, OTHER }

extension ComplaintCategoryExtensions on ComplaintCategory {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static const ComplaintCategoryHints = [
    "Hygiene",
    "Taste of food",
    "Service",
    "Portion size",
    "App related",
    "Others"
  ];

  static String getComplaintCategoryHint(ComplaintCategory complaintType) {
    return ComplaintCategoryHints[ComplaintCategory.values.indexOf(complaintType)];
  }

  static ComplaintCategory fromString(String formattedString) {
    switch (formattedString) {
      case "HYGIENE":
        return ComplaintCategory.HYGIENE;
      case "TASTE":
        return ComplaintCategory.TASTE;
      case "SERVICE":
        return ComplaintCategory.SERVICE;
      case "PORTION":
        return ComplaintCategory.PORTION;
      case "APP":
        return ComplaintCategory.APP;
      case "OTHER":
        return ComplaintCategory.OTHER;
      default:
        return null;
    }
  }
}
