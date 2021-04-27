import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/auth/ui/widgets/background.dart';
import 'package:flutter/material.dart';


class LoginChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Text('SIGN IN AS',
                  style: DMTypo.normal24BlackTextStyle
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 200,
              height: 60,
              padding: const EdgeInsets.all(5.0),
              child: Hero(

                tag: 'signIn-Student',
                child: DarkButton(
                  text: "Student",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN, arguments: UserType.STUDENT



                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 200,
              height: 60,
              padding: const EdgeInsets.all(5.0),
              child: Hero(
                tag: 'signUp-Staff',
                child: DarkButton(
                  text: "Staff",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN, arguments: UserType.STAFF);
                  },
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
