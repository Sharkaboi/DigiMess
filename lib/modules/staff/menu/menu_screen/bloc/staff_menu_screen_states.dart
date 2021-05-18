import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuStates extends Equatable {
  const StaffMenuStates();
}

class StaffMenuLoading extends StaffMenuStates {
  @override
  List<Object> get props => [];
}

class StaffMenuIdle extends StaffMenuStates {
  @override
  List<Object> get props => [];
}

class StaffMenuError extends StaffMenuStates {
  final DMError error;

  StaffMenuError(this.error);

  @override
  List<Object> get props => [error];
}

class StaffMenuSuccess extends StaffMenuStates {
  final List<MenuItem> menuItems;

  StaffMenuSuccess(this.menuItems);

  @override
  List<Object> get props => [menuItems];
}
