import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/splash/bloc/splash_events.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository _splashRepository;

  SplashBloc(SplashState initialState, this._splashRepository)
      : super(initialState);

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    yield SplashLoading();
    if (event is InitApp) {
      final DMTaskState result = await _splashRepository.initApp();
      if (result.isTaskSuccess) {
        yield SplashSuccess(result.taskResultData);
      } else {
        yield SplashError(result.error);
      }
    } else if (event is LogOutUserSplash) {
      await SharedPrefRepository.logOutUser();
      yield UserLoggedOutSplash();
    } else {
      yield SplashError(DMError(message: "Invalid event passed!"));
    }
  }
}
