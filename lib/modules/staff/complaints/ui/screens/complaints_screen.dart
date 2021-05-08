import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/ui/widgets/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() =>
      _ComplaintsScreenState();
}

class _ComplaintsScreenState
    extends State<ComplaintsScreen> {
  bool _isLoading = false;
  List<Complaint> listOfComplaints = [];
  ComplaintsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<ComplaintsBloc, ComplaintsStates>(
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
          _bloc = BlocProvider.of<ComplaintsBloc>(context);
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
    if (listOfComplaints == null || listOfComplaints.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text("No Complaints !",
                  style: DMTypo.bold24MutedTextStyle),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: listOfComplaints.length,
          itemBuilder: (context, index) {

              return ComplaintsCard(complaints: listOfComplaints[index]);

          });
    }
  }
}