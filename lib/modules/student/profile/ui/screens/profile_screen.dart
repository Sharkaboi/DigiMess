import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/annual_poll_card.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_bloc.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_events.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_states.dart';
import 'package:DigiMess/modules/student/profile/ui/widgets/profile_card.dart';
import 'package:DigiMess/modules/student/profile/ui/widgets/profile_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _isLoading = false;
  StudentProfileBloc _bloc;
  User _userDetails;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        dismissible: false,
        inAsyncCall: _isLoading,
        child: BlocConsumer<StudentProfileBloc, StudentProfileStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StudentProfileLoading;
            });

            if (state is StudentProfileError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StudentProfileFetchSuccess) {
              setState(() {
                _userDetails = state.userDetails;
              });
            } else if (state is StudentCloseAccountSuccess) {
              BlocProvider.of<DMBloc>(context).add(LogOutUser());
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StudentProfileBloc>(context);
            if (state is StudentProfileIdle) {
              _bloc.add(GetUserDetails());
              return Container();
            } else if (state is StudentProfileLoading) {
              return Container();
            } else {
              return ProfileScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileCard(userDetails: _userDetails),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: DMRoundedPrimaryButton(
                                  onPressed: () async {
                                    final bool choice = await DMAlertDialog.show(
                                        context,
                                        "Do you want to close your account?",
                                        description:
                                            "This will permanently close your  mess subcription");
                                    if (choice) {
                                      _bloc.add(CloseAccount());
                                    }
                                  },
                                  text: "CLOSE ACCOUNT",
                                  textStyle: DMTypo.bold16WhiteTextStyle,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: DMRoundedWhiteButton(
                                text: "LOG OUT",
                                onPressed: () async {
                                  final bool choice = await DMAlertDialog.show(
                                      context, "Logout of Digimess?");
                                  if (choice) {
                                    BlocProvider.of<DMBloc>(context)
                                        .add(LogOutUser());
                                  }
                                },
                                textStyle: DMTypo.bold16BlackTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      StudentAnnualPollCard()
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
