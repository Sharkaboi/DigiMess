import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/student/payment_history/data/payments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPaymentsBloc extends Bloc<StudentPaymentsEvents, StudentPaymentsStates> {
  final StudentPaymentsRepository _paymentsRepository;

  StudentPaymentsBloc(
      StudentPaymentsStates initialState, this._paymentsRepository)
      : super(initialState);

  @override
  Stream<StudentPaymentsStates> mapEventToState(StudentPaymentsEvents event) async* {
    yield StudentPaymentsLoading();
    if (event is GetAllPayments) {
      final DMTaskState result = await _paymentsRepository.getAllPayments();
      if (result.isTaskSuccess) {
        yield StudentPaymentsSuccess(result.taskResultData);
      } else {
        yield StudentPaymentsError(result.error);
      }
    }
  }
}
