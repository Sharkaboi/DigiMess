import 'package:DigiMess/common/constants/vote_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentAnnualPollScreen extends StatefulWidget {
  final VoidCallback onVoteCallback;

  const StudentAnnualPollScreen({Key key, this.onVoteCallback})
      : super(key: key);

  @override
  _StudentAnnualPollScreenState createState() =>
      _StudentAnnualPollScreenState();
}

class _StudentAnnualPollScreenState extends State<StudentAnnualPollScreen> {
  bool _isLoading = false;
  StudentAnnualPollBloc _bloc;
  List<MenuItem> _listOfFoodItems = [];

  Set<VoteEntry> listOfSelectedVotes = Set();

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
        isAppBarRequired: true,
        appBarTitleText: "Poll",
        body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocConsumer<StudentAnnualPollBloc, StudentAnnualPollStates>(
            listener: (context, state) {
              setState(() {
                _isLoading = state is StudentAnnualPollLoading;
              });

              if (state is StudentAnnualPollError) {
                DMSnackBar.show(context, state.error.message);
              } else if (state is StudentAnnualPollFetchSuccess) {
                setState(() {
                  _listOfFoodItems = state.listOfItems;
                });
              } else if (state is StudentVoteSuccess) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              _bloc = BlocProvider.of<StudentAnnualPollBloc>(context);
              if (state is StudentAnnualPollIdle) {
                _bloc.add(GetAllMenuItems());
                return Container();
              } else if (state is StudentAnnualPollLoading) {
                return Container();
              } else {
                return Column(
                  children: [],
                );
              }
            },
          ),
        ));
  }
}
