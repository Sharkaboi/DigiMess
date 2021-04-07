import 'package:equatable/equatable.dart';

class VoteEntry extends Equatable {
  final String internalMenuId;
  final _MenuItemTiming menuItemTiming;

  VoteEntry(this.internalMenuId, this.menuItemTiming);

  @override
  List<Object> get props => [internalMenuId, menuItemTiming];
}

enum _MenuItemTiming { BREAKFAST, LUNCH, DINNER }
