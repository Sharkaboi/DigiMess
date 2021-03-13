enum UserType { STUDENT, STAFF, GUEST }

extension UserTypeExtensions on UserType {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static UserType fromString(String formattedString) {
    switch (formattedString) {
      case "STUDENT":
        return UserType.STUDENT;
      case "STAFF":
        return UserType.STAFF;
      default:
        return UserType.GUEST;
    }
  }
}
