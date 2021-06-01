import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/modules/auth/data/util/userDetails.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvents extends Equatable {
  const RegisterEvents();
}

class RegisterUser extends RegisterEvents {
  final UserDetails userCredentials;

  RegisterUser(this.userCredentials);


  @override
  List<Object> get props => [userCredentials];
}

class AvailableUserCheck extends RegisterEvents{
  final String username;
  AvailableUserCheck(this.username);

  @override
  List<Object> get props => [username];
}