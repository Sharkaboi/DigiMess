import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/constants/app_strings.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/student/main/ui/widgets/student_nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: "Dashboard",
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
                DMStrings.description,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              child: DarkButton(
                onPressed: () {
                  BlocProvider.of<DMBloc>(context).add(LogOutUser());
                },
                text: "Log Out",
              ),
            )
          ],
        ),
      ),
      drawer: StudentNavDrawer(),
    );
  }
}
