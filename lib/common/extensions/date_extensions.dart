import 'package:cloud_firestore/cloud_firestore.dart';

extension DateExtensions on DateTime {}

DateTime getDateTimeOrNull(timestamp) {
  if (timestamp == null) {
    return null;
  } else if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return DateTime.tryParse(timestamp);
}
