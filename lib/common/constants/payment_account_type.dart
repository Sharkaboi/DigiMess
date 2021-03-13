enum PaymentAccountType { CARD, CASH }

extension PaymentAccountTypeExtensions on PaymentAccountType {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static PaymentAccountType fromString(String formattedString) {
    switch (formattedString) {
      case "CARD":
        return PaymentAccountType.CARD;
      case "CASH":
        return PaymentAccountType.CASH;
      default:
        return null;
    }
  }
}
