import 'package:equatable/equatable.dart';

abstract class DMStates extends Equatable {
  const DMStates();
}

class DMIdleState extends DMStates {
  @override
  List<Object> get props => [];
}

class DMErrorState extends DMStates {
  final String errorMessage;

  DMErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UserLoggedOut extends DMStates {
  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DMStates {
  @override
  List<Object> get props => [];
}

class NoNetworkState extends DMStates {
  @override
  List<Object> get props => [];
}

class NetworkConnectedState extends DMStates {
  @override
  List<Object> get props => [];
}
