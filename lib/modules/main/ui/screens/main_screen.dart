import 'package:DigiMess/common/styles/colors.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DigiMess"),
      ),
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
