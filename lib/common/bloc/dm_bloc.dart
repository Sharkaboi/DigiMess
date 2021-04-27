import 'dart:async';

import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DMBloc extends Bloc<DMEvents, DMStates> {
  StreamSubscription _internetStateStream;

  DMBloc(DMStates initialState) : super(initialState);

  @override
  Stream<DMStates> mapEventToState(DMEvents event) async* {
    try {
      if (event is InitNetworkStateListener) {
        _internetStateStream = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) => add(OnNetworkStateChanged(result)));
      } else if (event is OnNetworkStateChanged) {
        if (event.connectivityResult == ConnectivityResult.none) {
          yield NoNetworkState();
        } else {
          yield NetworkConnectedState();
        }
      } else if (event is LogOutUser) {
        await SharedPrefRepository.logOutUser();
        yield UserLoggedOut();
      } else {
        final AppStatus appStatus =
            await SharedPrefRepository.getAppClientStatus();
        if (appStatus.userType == UserType.GUEST ||
            appStatus.username == null ||
            appStatus.userId == null) {
          await SharedPrefRepository.logOutUser();
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
