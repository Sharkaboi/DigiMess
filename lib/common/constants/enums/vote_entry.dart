import 'package:equatable/equatable.dart';

class VoteEntry extends Equatable {
  final String internalMenuId;
  final MenuItemTiming menuItemTiming;

  VoteEntry(this.internalMenuId, this.menuItemTiming);

  @override
  List<Object> get props => [internalMenuId, menuItemTiming];
}

enum MenuItemTiming { BREAKFAST, LUNCH, DINNER }

extension MenuItemTimingExtension on MenuItemTiming {
  String getFirebaseFieldName() {
    if (this == MenuItemTiming.BREAKFAST) {
      return "forBreakFast";
    } else if (this == MenuItemTiming.LUNCH) {
      return "forLunch";
    } else {
      return "forDinner";
    }
  }
}
