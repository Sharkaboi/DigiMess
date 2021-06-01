import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:DigiMess/modules/staff/leaves/ui/widgets/leaves_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffLeavesHistoryScreen extends StatefulWidget {
  @override
  _StaffLeavesHistoryScreenState createState() => _StaffLeavesHistoryScreenState();
}

class _StaffLeavesHistoryScreenState extends State<StaffLeavesHistoryScreen> {
  bool _isLoading = false;
  List<LeavesWrapper> listOfLeaves = [];
  StaffLeavesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffLeavesBloc, StaffLeavesStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffLeavesLoading;
          });

          if (state is StaffLeavesError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StaffLeavesSuccess) {
            setState(() {
              listOfLeaves = state.listOfLeaves;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffLeavesBloc>(context);
          if (state is StaffLeavesIdle) {
            _bloc.add(GetAllLeaves());
            return Container();
          } else if (state is StaffLeavesLoading) {
            return Container();
          } else {
            return Container(child: getListOrEmptyHint());
          }
        },
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              child: Text("All leaves", style: DMTypo.bold18BlackTextStyle)),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: listOfLeaves.length,
                itemBuilder: (context, index) {
                  return LeaveCard(leave: listOfLeaves[index]);
                }),
          )
        ],
      );
    }
  }
}
