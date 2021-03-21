import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  static bool isBreakfastTime() {
    final DateTime now = DateTime.now();
    return now.hour > 5 && now.hour < 11;
  }

  static bool isLunchTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 11 && now.hour < 13;
  }

  static bool isDinnerTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 13 && now.hour < 21;
  }

  static bool isNightTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 21 || now.hour <= 5;
  }

  static bool isBeforeDueDate() {
    final DateTime now = DateTime.now();
    final DateTime dueDate = DateTime(now.year, now.month, 7);
    return now.isBefore(dueDate);
  }

  String getDayKey() {
    switch (this.weekday) {
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      case 7:
        return "sunday";
      default:
        return "";
    }
  }

  String getTimeAgo({bool numericDates = true}) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 8) {
      final dateFormatter = DateFormat("d MMM, yyyy");
      return "on " + dateFormatter.format(this);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

DateTime getDateTimeOrNull(timestamp) {
  if (timestamp == null) {
    return null;
  } else if (timestamp is Timestamp) {
    return timestamp.toDate();
  }

  return DateTime.tryParse(timestamp);
}
