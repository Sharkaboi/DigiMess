import 'dart:async';

import 'package:DigiMess/common/bloc/internet_events.dart';
import 'package:DigiMess/common/bloc/internet_states.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetBloc extends Bloc<InternetEvents, InternetStates> {
  StreamSubscription _internetStateStream;
  Connectivity connectivity = Connectivity();

  InternetBloc(InternetStates initialState) : super(initialState);

  @override
  Stream<InternetStates> mapEventToState(InternetEvents event) async* {
    if (event is InitNetworkStateListener) {
      ConnectivityResult result = await connectivity.checkConnectivity();
      add(OnNetworkStateChanged(result));
      _internetStateStream = connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) => add(OnNetworkStateChanged(result)));
    } else if (event is OnNetworkStateChanged) {
      if (event.connectivityResult == ConnectivityResult.none) {
        yield NoNetworkState();
      } else {
        yield NetworkConnectedState();
      }
    }
  }

  @override
  Future<void> close() {
    _internetStateStream.cancel();
    return super.close();
  }
}
