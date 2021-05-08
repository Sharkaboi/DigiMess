import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/data/payments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPaymentsBloc extends Bloc<StaffPaymentsEvents, StaffPaymentsStates> {
  final StaffPaymentsRepository _paymentsRepository;

  StaffPaymentsBloc(StaffPaymentsStates initialState, this._paymentsRepository)
      : super(initialState);

  @override
  Stream<StaffPaymentsStates> mapEventToState(StaffPaymentsEvents event) async* {
    yield StaffPaymentsLoading();
    if (event is GetAllPayments) {
      final DMTaskState result = await _paymentsRepository.getAllPayments(event.userId);
      if (result.isTaskSuccess) {
        yield StaffPaymentsSuccess(result.taskResultData);
      } else {
        yield StaffPaymentsError(result.error);
      }
    }
  }
}
