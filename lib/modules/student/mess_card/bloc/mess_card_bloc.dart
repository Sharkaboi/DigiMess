import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_events.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_states.dart';
import 'package:DigiMess/modules/student/mess_card/data/mess_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessCardBloc extends Bloc<MessCardEvents, MessCardStates> {
  final MessCardRepository _repository;

  MessCardBloc(MessCardStates initialState, this._repository)
      : super(initialState);

  @override
  Stream<MessCardStates> mapEventToState(MessCardEvents event) async* {
    yield MessCardLoading();
    if (event is GetMessCardStatus) {
      final DMTaskState result = await _repository.getMessCardStatus();
      if (result.isTaskSuccess) {
        final String admissionNo = await SharedPrefRepository.getUsername();
        yield MessCardSuccess(result.taskResultData, admissionNo);
      } else {
        yield MessCardError(result.error);
      }
    }
  }
}
