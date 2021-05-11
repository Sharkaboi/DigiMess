import 'package:DigiMess/modules/staff/menu/data/staff-menu-screen-data/util/staff_menu_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEvents extends Equatable {
  const StaffMenuEvents();
}

class FilterMenuItems extends StaffMenuEvents {
  final MenuFilterType menuFilterType;

  FilterMenuItems({this.menuFilterType = MenuFilterType.BOTH});

  @override
  List<Object> get props => [this.menuFilterType];
}