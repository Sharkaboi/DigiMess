import 'package:intl/intl.dart';

extension IntExtension on int {
  String getFormattedCurrency({bool isSymbol = true}) {
    final format = NumberFormat.currency(
        locale: 'en_IN', symbol: isSymbol ? "₹" : "Rs.", decimalDigits: 0);
    return format.format(this ?? 0);
  }
}
