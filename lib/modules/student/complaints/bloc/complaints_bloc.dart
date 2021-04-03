import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/student/complaints/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentComplaintsBloc
    extends Bloc<StudentComplaintsEvents, StudentComplaintsStates> {
  final StudentComplaintsRepository _complaintsRepository;

  StudentComplaintsBloc(
      StudentComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StudentComplaintsStates> mapEventToState(
      StudentComplaintsEvents event) async* {
    yield StudentComplaintsLoading();
    if (event is PlaceComplaint) {
      final DMTaskState result = await _complaintsRepository.placeComplaint(
          event.categories, event.complaint);
      if (result.isTaskSuccess) {
        yield StudentComplaintsSuccess();
      } else {
        yield StudentComplaintsError(result.error);
      }
    }
  }
}
