import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHashManager {
  static const HASH_ALGO = "sha256";

  static String hashPassword(String unHashedPassword) {
    final List<int> utf8FormattedList = utf8.encode(unHashedPassword);
    final Digest hashedPassword = sha256.convert(utf8FormattedList);
    return hashedPassword.toString();
  }

  static bool verifyPassword(
      {String hashedPasswordFromServer, String unHashedPassword}) {
    final List<int> utf8FormattedList = utf8.encode(unHashedPassword);
    final String hashedPassword = sha256.convert(utf8FormattedList).toString();
    return hashedPassword == hashedPasswordFromServer;
  }
}
