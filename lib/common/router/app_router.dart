import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_chooser.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_screen.dart';
import 'package:DigiMess/modules/auth/register/ui/screens/register_screen.dart';
import 'package:DigiMess/modules/auth/ui/screens/auth_screen.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:DigiMess/modules/splash/ui/screens/splash_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/screens/main_screen.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/data/notices_repository.dart';
import 'package:DigiMess/modules/staff/notices/ui/screens/add_notice_screen.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/data/complaints_repository.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/ui/screens/complaints_history.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_bloc.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/data/staff_leaves_repository.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/screens/leave_history_screen.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/data/payments_repository.dart';
import 'package:DigiMess/modules/staff/students/payment_history/ui/screens/payment_history_screen.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_bloc.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/data/student_details_repository.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/screens/student_details_screen.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/data/annual_poll_repository.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/screens/annual_poll_screen.dart';
import 'package:DigiMess/modules/student/main/ui/screens/main_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/card_details_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/dummy_payments_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/otp_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/payment_fail_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/payment_success_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  AppRouter._();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (context) => SplashBloc(SplashIdle(), SplashRepository()),
                child: SplashScreen()));
      case Routes.AUTH_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: AuthScreen());
      case Routes.LOGIN_CHOOSER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: LoginChooser());
      case Routes.LOGIN_SCREEN:
        final UserType userType = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: LoginScreen(userType: userType));
      case Routes.REGISTER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: RegisterScreen());
      case Routes.MAIN_SCREEN_STUDENT:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(create: (_) => DMBloc(DMIdleState()), child: StudentMainScreen()));
      case Routes.DUMMY_PAYMENT_SCREEN:
        final DummyPaymentArguments args = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: DummyPaymentsScreen(
              message: args.message,
              paymentAmount: args.paymentAmount,
              paymentSuccessCallback: args.paymentSuccessCallback,
            ));
      case Routes.PAYMENT_CARD_DETAILS_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: CardDetailsScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_OTP_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: OtpScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_SUCCESS_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: PaymentSuccessScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_FAILED_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: PaymentFailScreen());
      case Routes.ANNUAL_POLL_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            settings: settings,
            child: BlocProvider(
                create: (_) => StudentAnnualPollBloc(StudentAnnualPollIdle(),
                    StudentAnnualPollRepository(FirebaseClient.getMenuCollectionReference())),
                child: StudentAnnualPollScreen(onVoteCallback: settings.arguments)));
      case Routes.MAIN_SCREEN_STAFF:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(create: (_) => DMBloc(DMIdleState()), child: StaffMainScreen()));
      case Routes.STUDENT_DETAILS_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StudentDetailsBloc(StudentDetailsIdle(),
                    StudentDetailsRepository(FirebaseClient.getUsersCollectionReference())),
                child: StudentDetailsScreen(user: user)));
      case Routes.STUDENT_PAYMENT_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffPaymentsBloc(StaffPaymentsIdle(),
                    StaffPaymentsRepository(FirebaseClient.getPaymentsCollectionReference())),
                child: StaffPaymentHistoryScreen(user: user)));
      case Routes.STUDENT_COMPLAINT_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffComplaintsBloc(StaffComplaintsIdle(),
                    StaffComplaintsRepository(FirebaseClient.getComplaintsCollectionReference())),
                child: StaffComplaintsHistoryScreen(user: user)));
      case Routes.STUDENT_LEAVES_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffStudentLeavesBloc(StaffLeavesIdle(),
                    StaffStudentLeavesRepository(FirebaseClient.getAbsenteesCollectionReference())),
                child: StaffStudentLeavesHistoryScreen(user: user)));
      case Routes.STAFF_ADD_NOTICE_SCREEN:
        final VoidCallback callback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffNoticesBloc(NoticesIdle(),
                    StaffNoticesRepository(FirebaseClient.getNoticesCollectionReference())),
                child: StaffAddNoticeScreen(callback:callback)));
      default:
        return null;
    }
  }
}
