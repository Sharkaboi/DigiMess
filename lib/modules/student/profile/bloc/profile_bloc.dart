import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_events.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_states.dart';
import 'package:DigiMess/modules/student/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvents, StudentProfileStates> {
  final StudentProfileRepository _profileRepository;

  StudentProfileBloc(StudentProfileStates initialState, this._profileRepository)
      : super(initialState);

  @override
  Stream<StudentProfileStates> mapEventToState(
      StudentProfileEvents event) async* {
    yield StudentProfileLoading();
    if (event is GetUserDetails) {
      final DMTaskState result = await _profileRepository.getUserDetails();
      if (result.isTaskSuccess) {
        yield StudentProfileFetchSuccess(result.taskResultData);
      } else {
        yield StudentProfileError(result.error);
      }
    } else if (event is CloseAccount) {
      final DMTaskState result = await _profileRepository.closeAccount();
      if (result.isTaskSuccess) {
        yield StudentCloseAccountSuccess();
      } else {
        yield StudentProfileError(result.error);
      }
    }
  }
}
