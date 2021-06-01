import 'dart:async';

import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DMBloc extends Bloc<DMEvents, DMStates> {
  StreamSubscription _internetStateStream;
  Connectivity connectivity = Connectivity();

  DMBloc(DMStates initialState) : super(initialState);

  @override
  Stream<DMStates> mapEventToState(DMEvents event) async* {
    try {
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
      } else if (event is LogOutUser) {
        await SharedPrefRepository.logOutUser();
        // await FirebaseAuth.instance.signOut();
        yield UserLoggedOut();
      } else {
        final AppStatus appStatus = await SharedPrefRepository.getAppClientStatus();
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.signInAnonymously();
        }
        if (appStatus.userType == UserType.GUEST ||
            appStatus.username == null ||
            appStatus.userId == null) {
          await SharedPrefRepository.logOutUser();
          await FirebaseAuth.instance.signOut();
          yield UserLoggedOut();
        } else {
          yield UserLoggedIn();
        }
      }
    } catch (e) {
      print(e);
      yield DMErrorState(e.toString());
    }
  }

  @override
  Future<void> close() {
    _internetStateStream.cancel();
    return super.close();
  }
}
