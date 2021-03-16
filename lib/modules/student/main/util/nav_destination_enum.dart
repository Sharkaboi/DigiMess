enum StudentNavDestinations {
  HOME,
  MENU,
  COMPLAINTS,
  PAYMENTS,
  LEAVES,
  NOTICES,
  PROFILE,
  SETTINGS,
  HELP,
  ABOUT,
  SHARE
}

extension StudentNavDestinationExtensions on StudentNavDestinations {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
