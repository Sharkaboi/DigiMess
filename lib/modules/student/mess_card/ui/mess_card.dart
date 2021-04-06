import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_bloc.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_events.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_states.dart';
import 'package:DigiMess/modules/student/mess_card/data/mess_card_repository.dart';
import 'package:DigiMess/modules/student/mess_card/ui/mess_card_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMessCard {
  StudentMessCard._();

  static show(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return BlocProvider(
            create: (_) => MessCardBloc(
                MessCardIdle(),
                MessCardRepository(
                    FirebaseClient.getPaymentsCollectionReference())),
            child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: BlocConsumer<MessCardBloc, MessCardStates>(
                  listener: (context, state) {
                    if (state is MessCardError) {
                      DMSnackBar.show(context, state.error.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is MessCardIdle) {
                      BlocProvider.of<MessCardBloc>(context)
                          .add(GetMessCardStatus());
                      return Container();
                    } else if (state is MessCardSuccess) {
                      return MessCardScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(50).copyWith(bottom: 0),
                              child: Text("MESS CARD",
                                  style: DMTypo.bold30PrimaryBlueTextStyle,
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              margin: EdgeInsets.all(40).copyWith(top: 10),
                              child: Text(
                                  "ID : ${state.admissionNo ?? "Unavailable, Log in again"}",
                                  style: DMTypo.bold18PrimaryBlueTextStyle,
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 80)
                                    .copyWith(top: 0),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: DMColors.primaryBlue)),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text.rich(
                                          TextSpan(
                                            style: DMTypo.bold18BlackTextStyle,
                                            children: <TextSpan>[
                                              TextSpan(text: 'Status : '),
                                              TextSpan(
                                                  text: state.isActive
                                                      ? "Active"
                                                      : "Inactive",
                                                  style: state.isActive
                                                      ? DMTypo
                                                          .bold18GreenTextStyle
                                                      : DMTypo
                                                          .bold18RedTextStyle),
                                            ],
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    state.isActive
                                        ? Icon(Icons.circle,
                                            color: DMColors.green, size: 80)
                                        : Icon(Icons.circle,
                                            color: DMColors.red, size: 80)
                                  ],
                                ))
                          ],
                        ),
                      );
                    } else if (state is MessCardLoading) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                              height: constraints.maxWidth,
                              margin: EdgeInsets.all(20),
                              child:
                                  Center(child: CircularProgressIndicator()));
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                      return Container(height: 0);
                    }
                  },
                )),
          );
        });
  }
}
