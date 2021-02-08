import 'package:DigiMess/common/errors/error_wrapper.dart';
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
        yield UserLoginStatus(result.taskResultData);
      } else {
        yield SplashError(result.errors);
      }
    } else {
      yield SplashError(DMError(message: "Invalid event passed!"));
    }
  }
}
