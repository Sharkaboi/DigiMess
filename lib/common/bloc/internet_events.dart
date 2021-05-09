import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class InternetEvents extends Equatable {
  const InternetEvents();
}

class InitNetworkStateListener extends InternetEvents {
  @override
  List<Object> get props => [];
}

class OnNetworkStateChanged extends InternetEvents {
  final ConnectivityResult connectivityResult;

  OnNetworkStateChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult];
}
