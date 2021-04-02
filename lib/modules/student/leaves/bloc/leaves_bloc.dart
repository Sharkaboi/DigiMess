import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/student/leaves/data/leaves_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLeaveBloc extends Bloc<StudentLeaveEvents, StudentLeaveStates> {
  final StudentLeavesRepository _leavesRepository;

  StudentLeaveBloc(StudentLeaveStates initialState, this._leavesRepository)
      : super(initialState);

  @override
  Stream<StudentLeaveStates> mapEventToState(StudentLeaveEvents event) async* {
    yield StudentLeaveLoading();
    if (event is GetAllLeaves) {
      final DMTaskState result = await _leavesRepository.getAllLeaves();
      if (result.isTaskSuccess) {
        yield StudentLeaveFetchSuccess(result.taskResultData);
      } else {
        yield StudentLeaveError(result.error);
      }
    } else if (event is PlaceLeave) {
      final DMTaskState result =
          await _leavesRepository.applyForLeave(event.leaveInterval);
      if (result.isTaskSuccess) {
        yield StudentLeaveSuccess();
      } else {
        yield StudentLeaveError(result.error);
      }
    }
  }
}
