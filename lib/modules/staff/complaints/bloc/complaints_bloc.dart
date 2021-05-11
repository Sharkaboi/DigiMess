import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffComplaintsBloc extends Bloc<StaffComplaintsEvents, StaffComplaintsStates> {
  final StaffComplaintsRepository _complaintsRepository;

  StaffComplaintsBloc(
      StaffComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StaffComplaintsStates> mapEventToState(StaffComplaintsEvents event) async* {
    yield ComplaintsLoading();
    if (event is GetAllComplaints) {
      final DMTaskState result = await _complaintsRepository.getAllComplaints();
      if (result.isTaskSuccess) {
        yield ComplaintsSuccess(result.taskResultData);
      } else {
        yield ComplaintsError(result.error);
      }
    }
  }
}