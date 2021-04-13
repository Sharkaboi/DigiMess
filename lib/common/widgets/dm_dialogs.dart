import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMAlertDialog {
  DMAlertDialog._();

  static Future<bool> show(BuildContext context, String title,
      {String description}) async {
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
                              style: DMTypo.bold16BlackTextStyle,
                              textAlign: TextAlign.center),
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
                          child: Divider(
                              color: DMColors.primaryBlue,
                              thickness: 1,
                              height: 1),
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
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      onTap: () => Navigator.pop(context, true),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("Yes",
                                                  style: DMTypo
                                                      .bold16PrimaryBlueTextStyle))))),
                              Container(
                                  width: 1,
                                  color: DMColors.primaryBlue,
                                  height: 60),
                              Expanded(
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      onTap: () =>
                                          Navigator.pop(context, false),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("No",
                                                  style: DMTypo
                                                      .bold16PrimaryBlueTextStyle)))))
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
