import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/home/bloc/home_events.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvents, StudentHomeStates> {
  final HomeRepository _homeRepository;

  StudentHomeBloc(StudentHomeStates initialState, this._homeRepository)
      : super(initialState);

  @override
  Stream<StudentHomeStates> mapEventToState(StudentHomeEvents event) async* {
    yield StudentHomeLoading();
    if (event is FetchStudentHomeDetails) {
      final DMTaskState menuResult = await _homeRepository.getTodaysMenu();
      if (menuResult.isTaskSuccess) {
        final DMTaskState noticeResult =
            await _homeRepository.getLatestNotice();
        if (noticeResult.isTaskSuccess) {
          final DMTaskState paymentResult =
              await _homeRepository.getPaymentStatus();
          if (paymentResult.isTaskSuccess) {
            yield StudentHomeFetchSuccess(
                hasPaidFees: paymentResult.taskResultData,
                latestNotice: noticeResult.taskResultData,
                listOfTodaysMeals: menuResult.taskResultData);
          } else {
            yield StudentHomeError(paymentResult.error);
          }
        } else {
          yield StudentHomeError(noticeResult.error);
        }
      } else {
        yield StudentHomeError(menuResult.error);
      }
    }
  }
}
