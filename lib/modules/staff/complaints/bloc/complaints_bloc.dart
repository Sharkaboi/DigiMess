import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvents, ComplaintsStates> {
  final ComplaintsRepository _complaintsRepository;

  ComplaintsBloc(
      ComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<ComplaintsStates> mapEventToState(ComplaintsEvents event) async* {
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