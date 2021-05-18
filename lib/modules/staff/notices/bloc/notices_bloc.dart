import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/data/notices_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffNoticesBloc extends Bloc<StaffNoticesEvents, StaffNoticesStates> {
  final StaffNoticesRepository _noticesRepository;

  StaffNoticesBloc(StaffNoticesStates initialState, this._noticesRepository) : super(initialState);

  @override
  Stream<StaffNoticesStates> mapEventToState(StaffNoticesEvents event) async* {
    yield NoticesLoading();
    if (event is GetAllNotices) {
      final DMTaskState result = await _noticesRepository.getAllNotices();
      if (result.isTaskSuccess) {
        yield NoticesFetchSuccess(result.taskResultData);
      } else {
        yield NoticesError(result.error);
      }
    } else if (event is PlaceNotice) {
      final DMTaskState result = await _noticesRepository.placeNotice(event.title);
      if (result.isTaskSuccess) {
        yield PlaceNoticesSuccess();
      } else {
        yield NoticesError(result.error);
      }
    }
  }
}
