import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/styles/colors.dart';
import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: "DigiMess",
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo/ic_launcher_playstore.png"),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Welcome to DigiMess.\nAn app to help organizations manage their food mess, mainly colleges.\nUniversity Android mini project.",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              child: DarkButton(
                onPressed: () {
                  SharedPrefRepository.setUserType(UserType.GUEST);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.AUTH_SCREEN, (route) => false);
                },
                text: "Log Out",
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Text(
                "Hello",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: DMColors.accentBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
