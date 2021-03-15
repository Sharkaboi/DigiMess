import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_screen.dart';
import 'package:DigiMess/modules/auth/register/ui/screens/register_screen.dart';
import 'package:DigiMess/modules/auth/ui/screens/auth_screen.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:DigiMess/modules/splash/ui/screens/splash_screen.dart';
import 'package:DigiMess/modules/student/main/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          type: PageTransitionType.fade,
            child: BlocProvider(
                create: (context) =>
                    SplashBloc(SplashIdle(), SplashRepository()),
                child: SplashScreen()));
      case Routes.AUTH_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            child: AuthScreen());
      case Routes.LOGIN_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            child:  LoginScreen());
      case Routes.REGISTER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            child:  RegisterScreen());
      case Routes.MAIN_SCREEN_STUDENT:
        return PageTransition(
            type: PageTransitionType.fade,
            child:  StudentMainScreen());
      default:
        return null;
    }
  }
}
