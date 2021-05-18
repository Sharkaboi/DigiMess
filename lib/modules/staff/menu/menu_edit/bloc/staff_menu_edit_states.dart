import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEditStates extends Equatable {
  const StaffMenuEditStates();
}

class StaffMenuEditIdle extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditLoading extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditSuccess extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditError extends StaffMenuEditStates {
  final DMError error;

  StaffMenuEditError(this.error);

  @override
  List<Object> get props => [error];
}
