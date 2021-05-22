import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/ui/widgets/payments_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffPaymentHistoryScreen extends StatefulWidget {
  final User user;

  const StaffPaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffPaymentHistoryScreenState createState() => _StaffPaymentHistoryScreenState();
}

class _StaffPaymentHistoryScreenState extends State<StaffPaymentHistoryScreen> {
  bool _isLoading = false;
  List<Payment> listOfPayments = [];
  StaffPaymentsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Payment history",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffPaymentsBloc, StaffPaymentsStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffPaymentsLoading;
            });

            if (state is StaffPaymentsError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffPaymentsSuccess) {
              setState(() {
                listOfPayments = state.listOfPayments;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffPaymentsBloc>(context);
            if (state is StaffPaymentsIdle) {
              _bloc.add(GetAllPayments(widget.user.userId));
              return Container();
            } else if (state is StaffPaymentsLoading) {
              return Container();
            } else {
              return Container(child: getListOrEmptyHint());
            }
          },
        ),
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfPayments == null || listOfPayments.isEmpty) {
      return Center(
        child: Text("No payments done so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: listOfPayments.length,
          itemBuilder: (context, index) {
            return PaymentsCard(payment: listOfPayments[index]);
          });
    }
  }
}
