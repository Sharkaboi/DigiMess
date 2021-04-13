enum Branch { IT, CS, ME, EEE, EC, SE, CE }

extension BranchExtensions on Branch {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static Branch fromString(String formattedString) {
    switch (formattedString) {
      case "IT":
        return Branch.IT;
      case "CS":
        return Branch.CS;
      case "ME":
        return Branch.ME;
      case "EEE":
        return Branch.EEE;
      case "EC":
        return Branch.EC;
      case "SE":
        return Branch.SE;
      case "CE":
        return Branch.CE;
      default:
        return null;
    }
  }
}
