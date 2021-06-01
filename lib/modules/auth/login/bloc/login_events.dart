import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvents extends Equatable {
  const LoginEvents();
}

class LoginButtonClick extends LoginEvents {
  final String username;
  final String password;
  final UserType userType;
  LoginButtonClick({this.userType, this.username, this.password});

  @override
  List<Object> get props => [username, password, userType];
}
