import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/student/payment_history/ui/widgets/payments_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentPaymentHistoryScreen extends StatefulWidget {
  @override
  _StudentPaymentHistoryScreenState createState() =>
      _StudentPaymentHistoryScreenState();
}

class _StudentPaymentHistoryScreenState
    extends State<StudentPaymentHistoryScreen> {
  bool _isLoading = false;
  List<Payment> listOfPayments = [];
  StudentPaymentsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StudentPaymentsBloc, StudentPaymentsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentPaymentsLoading;
          });

          if (state is StudentPaymentsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentPaymentsSuccess) {
            setState(() {
              listOfPayments = state.listOfPayments;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentPaymentsBloc>(context);
          if (state is StudentPaymentsIdle) {
            _bloc.add(GetAllPayments());
            return Container();
          } else if (state is StudentPaymentsLoading) {
            return Container();
          } else {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Text("All payments",
                          style: DMTypo.bold16BlackTextStyle)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Divider(
                      color: DMColors.primaryBlue,
                      thickness: 1,
                    ),
                  ),
                  getListOrEmptyHint()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfPayments == null || listOfPayments.isEmpty) {
      return Expanded(
        child: Center(
          child: Text("No payments done so far.",
              style: DMTypo.bold14MutedTextStyle),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: listOfPayments.length,
            itemBuilder: (context, index) {
              return PaymentsCard(payment: listOfPayments[index]);
            }),
      );
    }
  }
}
