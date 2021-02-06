import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.AUTH_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.REGISTER_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.MAIN_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      default:
        return null;
    }
  }
}
