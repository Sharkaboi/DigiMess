import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/auth_repository.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_events.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterStates> {
  final AuthenticationRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterIdle());

  @override
  Stream<RegisterStates> mapEventToState(RegisterEvents event) async* {
    yield RegisterLoading();
    if (event is AvailableUserCheck) {
      final DMTaskState result = await _authRepository.usernameAvailableCheck(event.username);
      if (result.isTaskSuccess) {
        yield UserNameAvailableSuccess();
      } else {
        yield RegisterError(result.error);
      }
    } else if (event is RegisterUser) {
      final DMTaskState result = await _authRepository.register(event.userCredentials);
      if (result.isTaskSuccess) {
        yield RegisterSuccess();
      } else {
        yield RegisterError(result.error);
      }
    }
  }
}
