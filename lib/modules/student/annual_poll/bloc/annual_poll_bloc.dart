import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/data/annual_poll_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAnnualPollBloc
    extends Bloc<StudentAnnualPollEvents, StudentAnnualPollStates> {
  final StudentAnnualPollRepository _annualPollRepository;

  StudentAnnualPollBloc(
      StudentAnnualPollStates initialState, this._annualPollRepository)
      : super(initialState);

  @override
  Stream<StudentAnnualPollStates> mapEventToState(
      StudentAnnualPollEvents event) async* {
    yield StudentAnnualPollLoading();
    if (event is GetAllMenuItems) {
      final DMTaskState result = await _annualPollRepository.getAllMenuItems();
      if (result.isTaskSuccess) {
        yield StudentAnnualPollFetchSuccess(result.taskResultData);
      } else {
        yield StudentAnnualPollError(result.error);
      }
    } else if (event is PlaceVote) {
      final DMTaskState result =
          await _annualPollRepository.placeVotes(event.listOfVotes);
      if (result.isTaskSuccess) {
        yield StudentVoteSuccess();
      } else {
        yield StudentAnnualPollError(result.error);
      }
    }
  }
}
