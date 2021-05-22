import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDialog {
  static _launchURL() async {
    const url = DMDetails.githubLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  AboutDialog._();


  static show(BuildContext context) async {
    await showDialog(context: context, builder:(context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: Text("About", style: DMTypo.bold16BlackTextStyle),
                margin:EdgeInsets.only(top:5,left: 5).copyWith(bottom: 0),),
              Container(child: Text("Digimess is an all in one solution for managing everything related to your mess", style: DMTypo.bold14BlackTextStyle),
                margin:EdgeInsets.only(top: 15,left: 5).copyWith(bottom: 0),),
              Row(
                children: [

                  Expanded(
                    child: InkWell(
                      onTap:() {
                        showLicensePage(context: context,applicationName:"Digimess");
                      } ,
                      child: Container(child: Text("Licenses", style: DMTypo.bold14PrimaryBlueTextStyle),
                        margin:EdgeInsets.only(top: 15,left: 5,).copyWith(bottom: 0),),

                    ),
                  ),
                  InkWell(
                    onTap:() =>_launchURL(),
                    child: Container(child: Text("View github", style: DMTypo.bold14PrimaryBlueTextStyle),
                      margin:EdgeInsets.only(top: 15,left:0).copyWith(bottom: 0),),
                  ),
                  InkWell(
                    onTap:() =>Navigator.pop(context),
                    child: Container(child: Text("Ok", style: DMTypo.bold14PrimaryBlueTextStyle),
                      margin:EdgeInsets.only(top: 15,left: 20).copyWith(bottom: 0),),
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
