import 'package:DigiMess/common/styles/colors.dart';
import 'package:flutter/material.dart';

class StudentNavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Menu",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Complaints",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Payments",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Cancel mess",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Notices",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Help",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "About",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
            Text(
              "Share app",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: DMColors.accentBlue),
            ),
          ],
        ),
      ),
    );
  }
}
