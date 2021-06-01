import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/auth_repository.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_events.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final AuthenticationRepository _authRepository;

  LoginBloc(this._authRepository)
      : super(LoginIdle());

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async*{
    yield LoginLoading();
    if (event is LoginButtonClick) {
      final DMTaskState result = await _authRepository.login(event.username, event.password, event.userType);
      if (result.isTaskSuccess) {
        yield LoginSuccess();
      } else {
        yield LoginError(result.error);
      }
    }
  }
}
