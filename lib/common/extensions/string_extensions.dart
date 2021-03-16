import 'package:intl/intl.dart';

extension StringExtensions on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeFirst() {
    if (this.isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String getFormattedCurrency() {
    final format =
        NumberFormat.currency(locale: 'en_IN', symbol: "₹", decimalDigits: 0);
    return format.format(int.tryParse(this) ?? double.tryParse(this) ?? 0);
  }
}
