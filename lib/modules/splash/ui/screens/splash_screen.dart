import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/colors.dart';
import 'package:DigiMess/common/constants/user_types.dart';
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
          } else if (state is UserLoginStatus) {
            switch (state.userType) {
              case UserType.STUDENT:
                Navigator.popAndPushNamed(context, Routes.MAIN_SCREEN_STUDENT);
                break;
              case UserType.GUEST:
                Navigator.popAndPushNamed(context, Routes.AUTH_SCREEN);
                break;
              default:
                Navigator.popAndPushNamed(
                    context, Routes.MAIN_SCREEN_STAFF);
            }
          }
        },
        builder: (context, state) {
          BlocProvider.of<SplashBloc>(context).add(InitApp());
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: DMColors.darkBlue,
            child: Center(
              child: SvgPicture.asset("assets/logo/ic_foreground.svg",
                  width: 64, height: 64),
            ),
          );
        },
      ),
    );
  }
}
