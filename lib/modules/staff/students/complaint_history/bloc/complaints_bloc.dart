import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffComplaintsBloc extends Bloc<StaffComplaintsEvents, StaffComplaintsStates> {
  final StaffComplaintsRepository _complaintsRepository;

  StaffComplaintsBloc(StaffComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StaffComplaintsStates> mapEventToState(StaffComplaintsEvents event) async* {
    yield StaffComplaintsLoading();
    if (event is GetAllComplaints) {
      final DMTaskState result = await _complaintsRepository.getAllComplaints(event.userId);
      if (result.isTaskSuccess) {
        yield StaffComplaintsSuccess(result.taskResultData);
      } else {
        yield StaffComplaintsError(result.error);
      }
    }
  }
}
