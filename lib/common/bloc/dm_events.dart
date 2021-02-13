import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class DMEvents extends Equatable {
  const DMEvents();
}

class CheckDMStatus extends DMEvents {
  @override
  List<Object> get props => [];
}

class LogOutUser extends DMEvents {
  @override
  List<Object> get props => [];
}

class InitNetworkStateListener extends DMEvents {
  @override
  List<Object> get props => [];
}

class OnNetworkStateChanged extends DMEvents {
  final ConnectivityResult connectivityResult;

  OnNetworkStateChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult];
}
