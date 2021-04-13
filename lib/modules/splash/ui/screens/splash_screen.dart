import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_events.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is SplashSuccess) {
            if (state.appStatus.userType == UserType.GUEST ||
                state.appStatus.username == null ||
                state.appStatus.userId == null ||
                !state.appStatus.isEnabledInFirebase) {
              BlocProvider.of<SplashBloc>(context).add(LogOutUserSplash());
            } else {
              switch (state.appStatus.userType) {
                case UserType.STUDENT:
                  Navigator.popAndPushNamed(
                      context, Routes.MAIN_SCREEN_STUDENT);
                  break;
                case UserType.STAFF:
                  Navigator.popAndPushNamed(context, Routes.MAIN_SCREEN_STAFF);
                  break;
                default:
                  break;
              }
            }
          } else if (state is UserLoggedOutSplash) {
            Navigator.popAndPushNamed(context, Routes.AUTH_SCREEN);
          }
        },
        builder: (context, state) {
          BlocProvider.of<SplashBloc>(context).add(InitApp());
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: DMColors.darkBlue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    child: SvgPicture.asset("assets/logo/ic_foreground.svg",
                        width: 64, height: 64),
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Setting things up....",
                        style: DMTypo.bold18WhiteTextStyle,
                      )),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
