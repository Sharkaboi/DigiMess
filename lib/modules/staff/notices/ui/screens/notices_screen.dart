import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/staff/notices/ui/widgets/notice_wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffNoticesScreen extends StatefulWidget {
  const StaffNoticesScreen({Key key}) : super(key: key);

  @override
  _StaffNoticesScreenState createState() => _StaffNoticesScreenState();
}

class _StaffNoticesScreenState extends State<StaffNoticesScreen> {
  bool _isLoading = false;
  List<Notice> listOfNotices = [];
  StaffNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StaffNoticesWrapper(
      onNoticePlaced: onNoticePlaced,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffNoticesBloc, StaffNoticesStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is NoticesLoading;
            });

            if (state is NoticesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is NoticesFetchSuccess) {
              setState(() {
                listOfNotices = state.listOfNotices;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffNoticesBloc>(context);
            if (state is NoticesIdle) {
              _bloc.add(GetAllNotices());
              return Container();
            } else if (state is NoticesLoading) {
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
    if (listOfNotices == null || listOfNotices.isEmpty) {
      return Center(
        child: Text("No notices raised yet.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: listOfNotices.length,
          itemBuilder: (context, index) {
            return NoticeCard(notice: listOfNotices[index]);
          });
    }
  }

  void onNoticePlaced() {
    if (_bloc != null) {
      _bloc.add(GetAllNotices());
    }
  }
}
