import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_screen.dart';
import 'package:DigiMess/modules/auth/register/ui/screens/register_screen.dart';
import 'package:DigiMess/modules/auth/ui/screens/auth_screen.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:DigiMess/modules/splash/ui/screens/splash_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/screens/main_screen.dart';
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
                create: (context) =>
                    SplashBloc(SplashIdle(), SplashRepository()),
                child: SplashScreen()));
      case Routes.AUTH_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: AuthScreen());
      case Routes.LOGIN_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: LoginScreen());
      case Routes.REGISTER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: RegisterScreen());
      case Routes.MAIN_SCREEN_STUDENT:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: StudentMainScreen());
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
                create: (_) => StudentAnnualPollBloc(
                    StudentAnnualPollIdle(),
                    StudentAnnualPollRepository(
                        FirebaseClient.getMenuCollectionReference())),
                child: StudentAnnualPollScreen(
                    onVoteCallback: settings.arguments)));
      case Routes.MAIN_SCREEN_STAFF:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: StaffMainScreen());
      default:
        return null;
    }
  }
}
