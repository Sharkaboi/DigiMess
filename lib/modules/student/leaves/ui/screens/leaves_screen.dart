import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/student/leaves/ui/widgets/leave_entry_card.dart';
import 'package:DigiMess/modules/student/leaves/ui/widgets/place_leave_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentLeavesScreen extends StatefulWidget {
  @override
  _StudentLeavesScreenState createState() => _StudentLeavesScreenState();
}

class _StudentLeavesScreenState extends State<StudentLeavesScreen> {
  bool _isLoading = false;
  bool _isLeaveOngoing = false;
  List<LeaveEntry> leavesList = [];
  StudentLeaveBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        dismissible: false,
        inAsyncCall: _isLoading,
        child: BlocConsumer<StudentLeaveBloc, StudentLeaveStates>(
            listener: (context, state) {
          setState(() {
            _isLoading = state is StudentLeaveLoading;
          });
          if (state is StudentLeaveError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentLeaveFetchSuccess) {
            setState(() {
              leavesList = state.listOfLeaves;
              final DateTime now = DateTime.now();
              _isLeaveOngoing = leavesList.isNotEmpty &&
                  ((leavesList.first.startDate.compareTo(now) <= 0 &&
                          leavesList.first.endDate
                                  .copyWith(
                                      day: leavesList.first.endDate.day + 1)
                                  .compareTo(now) >=
                              0) ||
                      leavesList.first.startDate.isAfter(now));
            });
          } else if (state is StudentLeaveSuccess) {
            DMSnackBar.show(context, "Leave placed!");
            _bloc.add(GetAllLeaves());
          }
        }, builder: (context, state) {
          _bloc = BlocProvider.of<StudentLeaveBloc>(context);
          if (state is StudentLeaveIdle) {
            _bloc.add(GetAllLeaves());
            return Container();
          } else if (state is StudentLeaveLoading) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: leavesList == null || leavesList.isEmpty
                  ? 6
                  : leavesList.length + 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Text("Take leave",
                            style: DMTypo.bold16BlackTextStyle)),
                  );
                } else if (index == 1) {
                  return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Divider(
                        color: DMColors.primaryBlue,
                        thickness: 1,
                      ));
                } else if (index == 2) {
                  return PlaceLeaveCard(
                      onLeaveSubmit: onLeaveSubmit,
                      isLeaveOngoing: _isLeaveOngoing);
                } else if (index == 3) {
                  return Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Text("Leave history",
                            style: DMTypo.bold16BlackTextStyle)),
                  );
                } else if (index == 4) {
                  return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Divider(
                        color: DMColors.primaryBlue,
                        thickness: 1,
                      ));
                } else if (index == 5 &&
                    (leavesList == null || leavesList.isEmpty)) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("No leaves taken yet.",
                          style: DMTypo.bold12MutedTextStyle),
                    ),
                  );
                } else {
                  return LeaveEntryCard(
                    leaveEntry: leavesList[index - 5],
                    isOnGoingLeave: _isLeaveOngoing && index == 5,
                  );
                }
              },
            );
          }
        }));
  }

  void onLeaveSubmit(DateTimeRange leaveInterval) {
    _bloc.add(PlaceLeave(leaveInterval));
  }
}
