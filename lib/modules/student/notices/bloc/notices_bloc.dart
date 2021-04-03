import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/student/notices/data/notices_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentNoticesBloc
    extends Bloc<StudentNoticesEvents, StudentNoticesStates> {
  final StudentNoticesRepository _noticesRepository;

  StudentNoticesBloc(StudentNoticesStates initialState, this._noticesRepository)
      : super(initialState);

  @override
  Stream<StudentNoticesStates> mapEventToState(
      StudentNoticesEvents event) async* {
    yield StudentNoticesLoading();
    if (event is GetAllNotices) {
      final DMTaskState result = await _noticesRepository.getAllNotices();
      if (result.isTaskSuccess) {
        yield StudentNoticesSuccess(result.taskResultData);
      } else {
        yield StudentNoticesError(result.error);
      }
    }
  }
}
