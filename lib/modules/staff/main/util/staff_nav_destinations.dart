enum StaffNavDestinations {
  HOME,
  STUDENTS,
  MENU,
  NOTICES,
  LEAVES,
  ANNUAL_POLL,
  COMPLAINTS,
  HELP,
  ABOUT,
  LOGOUT
}

extension StaffNavDestinationExtensions on StaffNavDestinations {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
