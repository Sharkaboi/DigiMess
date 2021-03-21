import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class StudentMenuEvents extends Equatable {
  const StudentMenuEvents();
}

class GetAllMenuItems extends StudentMenuEvents {
  @override
  List<Object> get props => [];
}

class FilterMenuItems extends StudentMenuEvents {
  final String searchQuery;
  final MenuFilterType menuFilterType;

  FilterMenuItems(this.searchQuery, this.menuFilterType);

  @override
  List<Object> get props => [this.searchQuery, this.menuFilterType];
}
