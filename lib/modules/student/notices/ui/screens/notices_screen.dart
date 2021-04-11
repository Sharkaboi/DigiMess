import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/student/notices/ui/widgets/notices_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentNoticesScreen extends StatefulWidget {
  @override
  _StudentNoticesScreenState createState() => _StudentNoticesScreenState();
}

class _StudentNoticesScreenState extends State<StudentNoticesScreen> {
  List<Notice> noticesList = [];
  List<Notice> recentNoticesList = [];
  List<Notice> oldNoticesList = [];
  bool _isLoading = false;
  StudentNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentNoticesBloc, StudentNoticesStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentNoticesLoading;
          });
          if (state is StudentNoticesError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentNoticesSuccess) {
            final DateTime now = DateTime.now();
            setState(() {
              noticesList = state.listOfNotices;
              final ListResult result = noticesList.splitWhere((element) =>
                  element.date.month == now.month &&
                  element.date.year == now.year);
              recentNoticesList = result.matched;
              oldNoticesList = result.unmatched;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentNoticesBloc>(context);
          if (state is StudentNoticesIdle) {
            _bloc.add(GetAllNotices());
            return Container();
          } else if (state is StudentNoticesLoading) {
            return Container();
          } else {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        margin: EdgeInsets.all(20).copyWith(bottom: 0),
                        child: Center(
                          child: Text("Recent notices",
                              style: DMTypo.bold16BlackTextStyle),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          thickness: 1,
                          color: DMColors.primaryBlue,
                        ))
                  ]),
                ),
                SliverList(
                  delegate: getRecentNoticesOrEmptyHint(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                                .copyWith(bottom: 0),
                        child: Center(
                          child: Text("Old notices",
                              style: DMTypo.bold16BlackTextStyle),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          thickness: 1,
                          color: DMColors.primaryBlue,
                        ))
                  ]),
                ),
                SliverList(
                  delegate: getOldNoticesOrEmptyHint(),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        [Container(margin: EdgeInsets.only(bottom: 20))]))
              ],
            );
          }
        },
      ),
    );
  }

  SliverChildDelegate getRecentNoticesOrEmptyHint() {
    if (recentNoticesList == null || recentNoticesList.isEmpty) {
      return SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(50),
          child: Center(
              child: Text("No recent notices",
                  style: DMTypo.bold12MutedTextStyle)),
        )
      ]);
    } else {
      return SliverChildBuilderDelegate((_, index) {
        return NoticesCardItem(notice: recentNoticesList[index]);
      }, childCount: recentNoticesList.length);
    }
  }

  SliverChildDelegate getOldNoticesOrEmptyHint() {
    if (oldNoticesList == null || oldNoticesList.isEmpty) {
      return SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(50),
          child: Center(
              child:
                  Text("No old notices", style: DMTypo.bold12MutedTextStyle)),
        )
      ]);
    } else {
      return SliverChildBuilderDelegate((_, index) {
        return NoticesCardItem(notice: oldNoticesList[index]);
      }, childCount: oldNoticesList.length);
    }
  }
}
