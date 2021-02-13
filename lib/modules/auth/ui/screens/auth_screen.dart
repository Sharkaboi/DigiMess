import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/user_types.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      body: Center(
          child: Container(
        height: 60,
        child: DarkButton(
          onPressed: () {
            SharedPrefRepository.setUserType(UserType.STUDENT);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.MAIN_SCREEN, (route) => false);
          },
          text: "Log In",
        ),
      )),
    );
  }
}
