enum UserType { STUDENT, COORDINATOR, GUEST }

extension ToString on UserType {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}