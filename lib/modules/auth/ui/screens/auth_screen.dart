import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:DigiMess/modules/auth/background.dart';

class AuthScreen extends StatelessWidget {
  final String logo = 'assets/logo/ic_launcher_round.svg';
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
        body: Background(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            child: Container(
              // logo and app name container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Container(
                      // logo image container
                      width: 150,
                      height: 150,
                      child: SvgPicture.asset(logo,
                          semanticsLabel: 'DigiMess Logo'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      // app name container
                      child: Text("DIGIMESS",
                          style: DMTypo.bold30DarkBlueTextStyle),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 195,
                height: 60,
                padding: const EdgeInsets.all(5.0),
                child: DarkButton(
                  text: "Sign in",
                  onPressed: () {},
                ),
              ),
              Container(
                width: 195,
                height: 60,
                padding: const EdgeInsets.all(5.0),
                child: DarkButton(
                  text: "Sign up",
                  onPressed: () {},
                ),
              )
            ],
          )),
        ),
      ],
    )));
  }
}
