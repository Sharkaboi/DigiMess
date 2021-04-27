import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class StudentMenuEvents extends Equatable {
  const StudentMenuEvents();
}

class FilterMenuItems extends StudentMenuEvents {
  final MenuFilterType menuFilterType;

  FilterMenuItems({this.menuFilterType = MenuFilterType.BOTH});

  @override
  List<Object> get props => [this.menuFilterType];
}
