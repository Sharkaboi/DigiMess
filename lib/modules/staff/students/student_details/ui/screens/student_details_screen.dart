import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_bloc.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_events.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/widgets/student_details_bg.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/widgets/student_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentDetailsScreen extends StatefulWidget {
  final User user;

  const StudentDetailsScreen({Key key, this.user}) : super(key: key);

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  bool _isLoading = false;
  bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.user.isEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Student details",
      isAppBarRequired: true,
      body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocListener<StudentDetailsBloc, StudentDetailsStates>(
              listener: (context, state) {
                setState(() {
                  _isLoading = state is StudentDetailsLoading;
                });

                if (state is StudentDetailsError) {
                  DMSnackBar.show(context, state.error.message);
                } else if (state is StudentDetailsDisableSuccess) {
                  setState(() {
                    _isEnabled = !_isEnabled;
                  });
                }
              },
              child: StudentDetailsScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StudentDetailsCard(userDetails: widget.user),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(color: DMColors.white, boxShadow: [
                          BoxShadow(
                              color: DMColors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, -4))
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.STUDENT_PAYMENT_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                child: Text("Show payment history",
                                    style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.STUDENT_COMPLAINT_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text("Complaints registered",
                                    style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.STUDENT_LEAVES_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text("Leaves taken", style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 30),
                                          child: Text("Account status",
                                              style: DMTypo.bold16BlackTextStyle)),
                                      Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(_isEnabled ? "Enabled" : "Disabled",
                                              style: DMTypo.normal14MutedTextStyle))
                                    ])),
                                Switch(
                                    value: _isEnabled,
                                    activeColor: DMColors.primaryBlue,
                                    onChanged: (value) async {
                                      final bool choice = await DMAlertDialog.show(context,
                                          "Do you want to ${_isEnabled ? "disable" : "enable"} this account?");
                                      if (choice) {
                                        BlocProvider.of<StudentDetailsBloc>(context)
                                            .add(DisableStudent(widget.user.userId, value));
                                      }
                                    })
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
