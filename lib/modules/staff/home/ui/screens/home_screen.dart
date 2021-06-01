import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_events.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/home_bg_scroll_view.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/student_enrolled_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/student_present_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/todays_food_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/todays_food_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffHomeScreen extends StatefulWidget {
  final VoidCallback noticesCallback;

  const StaffHomeScreen({Key key, this.noticesCallback}) : super(key: key);

  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  bool _isLoading = false;
  StaffHomeBloc _homeBloc;
  StudentEnrolledCount studentEnrolledCount;
  StudentPresentCount studentPresentCount;
  List<MenuItem> listOfTodaysMeals;
  Notice latestNotice;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StaffHomeBloc, StaffHomeStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffHomeLoading;
          });
          if (state is StaffHomeError) {
            DMSnackBar.show(context, state.errors.message);
          } else if (state is StaffHomeFetchSuccess) {
            setState(() {
              listOfTodaysMeals = state.listOfTodaysMeals;
              latestNotice = state.latestNotice.takeFirstOrNull();
              studentEnrolledCount = state.studentEnrolledCount;
              studentPresentCount = state.studentPresentCount;
            });
          }
        },
        builder: (context, state) {
          _homeBloc = BlocProvider.of<StaffHomeBloc>(context);
          if (state is StaffHomeIdle) {
            _homeBloc.add(FetchStaffHomeDetails());
            return Container();
          } else if (state is StaffHomeFetchSuccess) {
            return HomeScrollView(
                child: Column(
              children: [
                TodaysFoodCard(listOfTodaysMeals: listOfTodaysMeals),
                Visibility(
                    visible: !DateExtensions.isNightTime(),
                    child: TodaysFoodPageView(listOfTodaysMeals: listOfTodaysMeals)),
                Visibility(
                    visible: studentEnrolledCount != null,
                    child: StudentEnrolledCard(studentEnrolledCount: studentEnrolledCount)),
                Visibility(
                    visible: studentPresentCount != null,
                    child: StudentPresentCard(studentPresentCount: studentPresentCount)),
                Visibility(
                  visible: latestNotice != null,
                  child: NoticeCard(
                      latestNotice: latestNotice, noticesCallback: widget.noticesCallback),
                ),
              ],
            ));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
