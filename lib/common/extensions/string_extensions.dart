import 'package:intl/intl.dart';

extension StringExtensions on String {
  String capitalize() {
    if (this.trim().isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeFirst() {
    if (this.trim().isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String getFormattedCurrency({bool isSymbol = true}) {
    final format = NumberFormat.currency(
        locale: 'en_IN', symbol: isSymbol ? "₹" : "Rs.", decimalDigits: 0);
    return format.format(int.tryParse(this) ?? double.tryParse(this) ?? 0);
  }

  bool isEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (this == null || !regex.hasMatch(this))
      return false;
    else
      return true;
  }

  bool isPhoneNumber() {
    Pattern mobileNoPattern = r'(^[0-9]{10}$)';
    RegExp regex = new RegExp(mobileNoPattern);
    if (this == null || !regex.hasMatch(this))
      return false;
    else
      return true;
  }
}
