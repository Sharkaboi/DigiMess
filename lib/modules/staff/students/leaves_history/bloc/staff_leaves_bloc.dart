import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leave_events.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/data/staff_leaves_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffStudentLeavesBloc extends Bloc<StaffStudentLeavesEvents, StaffStudentLeavesStates> {
  final StaffStudentLeavesRepository _leavesRepository;

  StaffStudentLeavesBloc(StaffStudentLeavesStates initialState, this._leavesRepository)
      : super(initialState);

  @override
  Stream<StaffStudentLeavesStates> mapEventToState(StaffStudentLeavesEvents event) async* {
    yield StaffLeavesLoading();
    if (event is GetAllLeaves) {
      final DMTaskState result = await _leavesRepository.getAllLeaves(event.userId);
      if (result.isTaskSuccess) {
        yield StaffLeavesSuccess(result.taskResultData);
      } else {
        yield StaffLeavesError(result.error);
      }
    }
  }
}
