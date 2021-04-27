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
}
