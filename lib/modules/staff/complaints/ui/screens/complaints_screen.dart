import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:DigiMess/modules/staff/complaints/ui/widgets/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffComplaintsScreen extends StatefulWidget {
  @override
  _StaffComplaintsScreenState createState() => _StaffComplaintsScreenState();
}

class _StaffComplaintsScreenState extends State<StaffComplaintsScreen> {
  bool _isLoading = false;
  List<ComplaintWrapper> listOfComplaints = [];
  StaffComplaintsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffComplaintsBloc, StaffComplaintsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is ComplaintsLoading;
          });

          if (state is ComplaintsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is ComplaintsSuccess) {
            setState(() {
              listOfComplaints = state.listOfComplaints;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffComplaintsBloc>(context);
          if (state is ComplaintsIdle) {
            _bloc.add(GetAllComplaints());
            return Container();
          } else if (state is ComplaintsLoading) {
            return Container();
          } else {
            return Container(child: getListOrEmptyHint());
          }
        },
      ),
    );
  }

  Widget getListOrEmptyHint() {
    print("called");
    if (listOfComplaints == null || listOfComplaints.isEmpty) {
      return Center(
        child: Text("No Complaints received yet.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: listOfComplaints.length,
          itemBuilder: (context, index) {
            return ComplaintsCard(complaintWrapper: listOfComplaints[index]);
          });
    }
  }
}
