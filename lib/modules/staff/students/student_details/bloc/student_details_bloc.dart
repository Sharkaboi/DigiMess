import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_events.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/data/student_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsBloc extends Bloc<StudentDetailsEvents, StudentDetailsStates> {
  final StudentDetailsRepository _studentDetailsRepository;

  StudentDetailsBloc(StudentDetailsStates initialState, this._studentDetailsRepository)
      : super(initialState);

  @override
  Stream<StudentDetailsStates> mapEventToState(StudentDetailsEvents event) async* {
    yield StudentDetailsLoading();
    if (event is DisableStudent) {
      final DMTaskState result =
          await _studentDetailsRepository.toggleUserStatus(event.userId, event.isDisabled);
      if (result.isTaskSuccess) {
        yield StudentDetailsDisableSuccess();
      } else {
        yield StudentDetailsError(result.error);
      }
    }
  }
}
