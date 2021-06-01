import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/staff/annual_poll/data/annual_poll_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffAnnualPollBloc extends Bloc<StaffAnnualPollEvents, StaffAnnualPollStates> {
  final StaffAnnualPollRepository _annualPollRepository;

  StaffAnnualPollBloc(StaffAnnualPollStates initialState, this._annualPollRepository)
      : super(initialState);

  @override
  Stream<StaffAnnualPollStates> mapEventToState(StaffAnnualPollEvents event) async* {
    yield AnnualPollLoading();
    if (event is GetAllVotes) {
      final DMTaskState result = await _annualPollRepository.getMenuItems();
      if (result.isTaskSuccess) {
        yield AnnualPollFetchSuccess(result.taskResultData);
      } else {
        yield AnnualPollError(result.error);
      }
    } else if (event is ResetAnnualPoll) {
      final DMTaskState result = await _annualPollRepository.resetAnnualPoll();
      if (result.isTaskSuccess) {
        yield AnnualPollResetSuccess();
      } else {
        yield AnnualPollError(result.error);
      }
    }
  }
}
