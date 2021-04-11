import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            child: DMPillButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onPressed: () {
                SharedPrefRepository.setUserType(UserType.STUDENT);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.MAIN_SCREEN_STUDENT, (route) => false);
              },
              text: "Log In",
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.only(top: 20),
            child: DMPillButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onPressed: () {
                SharedPrefRepository.setUserType(UserType.STAFF);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.MAIN_SCREEN_STAFF, (route) => false);
              },
              text: "Log In Admin",
            ),
          )
        ],
      )),
    );
  }
}
