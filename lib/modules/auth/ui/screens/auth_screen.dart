import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child:
                        SvgPicture.asset('assets/logo/ic_launcher_round.svg'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(DMDetails.appName.toUpperCase(),
                        style: DMTypo.alefBold36DarkBlueTextStyle),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: Hero(
                      tag: 'signIn-Student',
                      child: DMPillButton(
                        text: "Sign in",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.LOGIN_CHOOSER_SCREEN);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    margin: const EdgeInsets.only(top: 20),
                    child: Hero(
                      tag: 'signUp-Staff',
                      child: DMPillButton(
                        text: "Sign up",
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.REGISTER_SCREEN);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
