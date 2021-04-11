enum StaffNavDestinations {
  HOME,
  STUDENTS,
  MENU,
  TODAYS_FOOD,
  NOTICES,
  PAYMENTS,
  LEAVES,
  POLL,
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
