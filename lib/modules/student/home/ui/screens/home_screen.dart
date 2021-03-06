import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/annual_poll_card.dart';
import 'package:DigiMess/modules/student/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/student/home/bloc/home_events.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/home_bg_scroll_view.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/payment_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentHomeScreen extends StatefulWidget {
  final VoidCallback noticesCallback;

  const StudentHomeScreen({Key key, this.noticesCallback}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<MenuItem> listOfTodaysMeals;
  Notice latestNotice;
  PaymentStatus paymentStatus;
  int lastMonthLeaveCount = 0;
  bool _isLoading = false;
  StudentHomeBloc _homeBloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentHomeBloc, StudentHomeStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentHomeLoading;
          });
          if (state is StudentHomeError) {
            DMSnackBar.show(context, state.errors.message);
          } else if (state is StudentHomeFetchSuccess) {
            setState(() {
              paymentStatus = state.paymentStatus;
              listOfTodaysMeals = state.listOfTodaysMeals;
              latestNotice = state.latestNotice.takeFirstOrNull();
              lastMonthLeaveCount = state.leaveCount;
            });
          } else if (state is StudentHomePaymentSuccess) {
            setState(() {
              paymentStatus = state.paymentStatus;
            });
          }
        },
        builder: (context, state) {
          _homeBloc = BlocProvider.of<StudentHomeBloc>(context);
          if (state is StudentHomeIdle) {
            _homeBloc.add(FetchStudentHomeDetails());
            return Container();
          } else if (state is StudentHomeFetchSuccess ||
              state is StudentHomePaymentSuccess) {
            return HomeScrollView(
                child: Column(
              children: [
                TodaysFoodCard(listOfTodaysMeals: listOfTodaysMeals),
                Visibility(
                    visible: !DateExtensions.isNightTime(),
                    child: TodaysFoodPageView(
                        listOfTodaysMeals: listOfTodaysMeals)),
                Visibility(
                  visible: !DateExtensions.isNightTime(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                ),
                Visibility(
                  visible: latestNotice != null,
                  child: NoticeCard(
                      latestNotice: latestNotice,
                      noticesCallback: widget.noticesCallback),
                ),
                HomePaymentCard(
                  paymentStatus: paymentStatus,
                  lastMonthLeaveCount: lastMonthLeaveCount,
                  onPaymentSuccessCallback: onPaymentSuccessCallback,
                ),
                StudentAnnualPollCard()
              ],
            ));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  onPaymentSuccessCallback(Payment payment) {
    _homeBloc.add(MakePayment(payment));
  }
}
