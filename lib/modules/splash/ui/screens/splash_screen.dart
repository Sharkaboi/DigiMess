import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/util/user_types.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_events.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: true,
        dismissible: false,
        child: BlocConsumer<SplashBloc,SplashState>(
          listener: (context, state) {
            if (state is SplashError) {
              showError(context, state.error);
            } else if (state is UserLoginStatus) {
              switch (state.userType) {
                case UserType.STUDENT:
                  Navigator.pushNamed(context, Routes.MAIN_SCREEN);
                  break;
                case UserType.GUEST:
                  Navigator.pushNamed(context, Routes.AUTH_SCREEN);
                  break;
                default:
                  Navigator.pushNamed(context, Routes.MAIN_SCREEN_COORDINATOR);
              }
            }
          },
          builder: (context, state) {
            final SplashBloc _splashBloc = BlocProvider.of<SplashBloc>(context);
            if (state is SplashIdle) {
              _splashBloc.add(InitApp());
              return Container();
            } else {
              //todo: show better splash screen
              return Container();
            }
          },
        ),
      ),
    );
  }

  void showError(BuildContext context, DMError error) {
    //todo: show better error screen
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.message)));
  }
}
