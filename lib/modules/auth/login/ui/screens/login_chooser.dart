import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';

class LoginChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              child: Text('SIGN IN AS', style: DMTypo.bold24BlackTextStyle),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60,
              child: Hero(
                tag: 'signIn-Student',
                child: DMPillButton(
                  text: "Student",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN,
                        arguments: UserType.STUDENT);
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60,
              margin: EdgeInsets.all(20),
              child: Hero(
                tag: 'signUp-Staff',
                child: DMPillButton(
                  text: "Staff",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN,
                        arguments: UserType.STAFF);
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
