import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_events.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffHomeBloc extends Bloc<StaffHomeEvents, StaffHomeStates> {
  final StaffHomeRepository _homeRepository;

  StaffHomeBloc(StaffHomeStates initialState, this._homeRepository) : super(initialState);

  @override
  Stream<StaffHomeStates> mapEventToState(StaffHomeEvents event) async* {
    yield StaffHomeLoading();
    if (event is FetchStaffHomeDetails) {
      final DMTaskState menuResult = await _homeRepository.getTodaysMenu();
      if (menuResult.isTaskSuccess) {
        final DMTaskState noticeResult = await _homeRepository.getLatestNotice();
        if (noticeResult.isTaskSuccess) {
          final DMTaskState enrolledCountResult = await _homeRepository.getEnrolledCount();
          if (enrolledCountResult.isTaskSuccess) {
            final DMTaskState presentCountResult =
                await _homeRepository.getPresentCount(enrolledCountResult.taskResultData);
            if (presentCountResult.isTaskSuccess) {
              yield StaffHomeFetchSuccess(
                  studentEnrolledCount: enrolledCountResult.taskResultData,
                  latestNotice: noticeResult.taskResultData,
                  listOfTodaysMeals: menuResult.taskResultData,
                  studentPresentCount: presentCountResult.taskResultData);
            } else {
              yield StaffHomeError(presentCountResult.error);
            }
          } else {
            yield StaffHomeError(enrolledCountResult.error);
          }
        } else {
          yield StaffHomeError(noticeResult.error);
        }
      } else {
        yield StaffHomeError(menuResult.error);
      }
    }
  }
}
