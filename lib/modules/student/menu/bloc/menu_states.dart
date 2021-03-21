import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:equatable/equatable.dart';

abstract class StudentMenuStates extends Equatable {
  const StudentMenuStates();
}

class StudentMenuLoading extends StudentMenuStates {
  @override
  List<Object> get props => [];
}

class StudentMenuIdle extends StudentMenuStates {
  @override
  List<Object> get props => [];
}

class StudentMenuError extends StudentMenuStates {
  final DMError error;

  StudentMenuError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentMenuSuccess extends StudentMenuStates {
  final List<MenuItem> menuItems;

  StudentMenuSuccess(this.menuItems);

  @override
  List<Object> get props => [menuItems];
}
