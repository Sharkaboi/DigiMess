import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DMAlertDialog {
  DMAlertDialog._();

  static Future<bool> show(BuildContext context, String title, {String description}) async {
    return await showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20).copyWith(bottom: 0),
                          child: Text(title,
                              style: DMTypo.bold16BlackTextStyle, textAlign: TextAlign.center),
                        ),
                        description != null
                            ? Container(
                                margin: EdgeInsets.all(40).copyWith(bottom: 0),
                                child: Text(description,
                                    style: DMTypo.bold16MutedTextStyle,
                                    textAlign: TextAlign.center),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Divider(color: DMColors.primaryBlue, thickness: 1, height: 1),
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                                      ),
                                      onTap: () => Navigator.pop(context, true),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("Yes",
                                                  style: DMTypo.bold16PrimaryBlueTextStyle))))),
                              Container(width: 1, color: DMColors.primaryBlue, height: 60),
                              Expanded(
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.only(bottomRight: Radius.circular(10)),
                                      ),
                                      onTap: () => Navigator.pop(context, false),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("No",
                                                  style: DMTypo.bold16PrimaryBlueTextStyle)))))
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            }) ??
        false;
  }
}

class DMAboutDialog {
  DMAboutDialog._();

  static _launchURL() async {
    const url = DMDetails.githubLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  static show(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: DMTypo.bold24BlackTextStyle),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(DMDetails.description, style: DMTypo.bold18BlackTextStyle),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showLicensePage(
                                context: context,
                                applicationName: DMDetails.appName,
                                applicationVersion: DMDetails.appVersion);
                          },
                          child: Text("Licenses", style: DMTypo.bold18PrimaryBlueTextStyle),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text("Ok", style: DMTypo.bold18PrimaryBlueTextStyle)),
                      ),
                      InkWell(
                        onTap: () => _launchURL(),
                        child: Text("View github", style: DMTypo.bold18PrimaryBlueTextStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
