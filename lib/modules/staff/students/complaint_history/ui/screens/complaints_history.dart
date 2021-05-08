import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/ui/widgets/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffComplaintsHistoryScreen extends StatefulWidget {
  final User user;

  const StaffComplaintsHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffComplaintsHistoryScreenState createState() => _StaffComplaintsHistoryScreenState();
}

class _StaffComplaintsHistoryScreenState extends State<StaffComplaintsHistoryScreen> {
  bool _isLoading = false;
  List<Complaint> listOfComplaints = [];
  StaffComplaintsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Complaints",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffComplaintsBloc, StaffComplaintsStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffComplaintsLoading;
            });

            if (state is StaffComplaintsError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffComplaintsSuccess) {
              setState(() {
                listOfComplaints = state.listOfComplaints;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffComplaintsBloc>(context);
            if (state is StaffComplaintsIdle) {
              _bloc.add(GetAllComplaints(widget.user.userId));
              return Container();
            } else if (state is StaffComplaintsLoading) {
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
    if (listOfComplaints == null || listOfComplaints.isEmpty) {
      return Center(
        child: Text("No complaints done so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: listOfComplaints.length,
          itemBuilder: (context, index) {
            return ComplaintsCard(complaint: listOfComplaints[index]);
          });
    }
  }
}
