import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leave_events.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_bloc.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/widgets/leave_card.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/widgets/ongoing_leave_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffStudentLeavesHistoryScreen extends StatefulWidget {
  final User user;

  const StaffStudentLeavesHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffStudentLeavesHistoryScreenState createState() => _StaffStudentLeavesHistoryScreenState();
}

class _StaffStudentLeavesHistoryScreenState extends State<StaffStudentLeavesHistoryScreen> {
  bool _isLoading = false;
  List<LeaveEntry> listOfLeaves = [];
  bool _isLeaveOngoing = false;
  StaffStudentLeavesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Leaves taken",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffStudentLeavesBloc, StaffStudentLeavesStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffLeavesLoading;
            });

            if (state is StaffLeavesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffLeavesSuccess) {
              setState(() {
                listOfLeaves = state.listOfLeaves;
                final DateTime now = DateTime.now();
                _isLeaveOngoing = listOfLeaves.isNotEmpty &&
                    ((listOfLeaves.first.startDate.compareTo(now) <= 0 &&
                            listOfLeaves.first.endDate
                                    .copyWith(day: listOfLeaves.first.endDate.day + 1)
                                    .compareTo(now) >=
                                0) ||
                        listOfLeaves.first.startDate.isAfter(now));
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffStudentLeavesBloc>(context);
            if (state is StaffLeavesIdle) {
              _bloc.add(GetAllLeaves(widget.user.userId));
              return Container();
            } else if (state is StaffLeavesLoading) {
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
    if (listOfLeaves == null || listOfLeaves.isEmpty) {
      return Center(
        child: Text("No leaves taken so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isLeaveOngoing,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Ongoing leave", style: DMTypo.bold16BlackTextStyle)),
                  OngoingLeaveCard(leave: listOfLeaves.first)
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              child: Text("Previous leaves", style: DMTypo.bold16BlackTextStyle)),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                itemCount: listOfLeaves.length - (_isLeaveOngoing ? 1 : 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return LeaveCard(leave: listOfLeaves[index + (_isLeaveOngoing ? 1 : 0)]);
                }),
          )
        ],
      );
    }
  }
}
