import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/widgets/nav_item.dart';
import 'package:DigiMess/modules/student/main/util/student_nav_destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentNavDrawer extends StatelessWidget {
  final Function(StudentNavDestinations) itemOnClickCallBack;
  final StudentNavDestinations currentScreen;

  const StudentNavDrawer({Key key, this.itemOnClickCallBack, this.currentScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: DMColors.primaryBlue,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/logo/ic_foreground.svg", height: 30),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.clear),
                        color: DMColors.white,
                        iconSize: 24,
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: DMColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavItem(
                          text: "Home",
                          iconAsset: "assets/icons/home.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.HOME,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.HOME),
                        ),
                        NavItem(
                          text: "Menu",
                          iconAsset: "assets/icons/menu.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.MENU,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.MENU),
                        ),
                        NavItem(
                          text: "Complaints",
                          iconAsset: "assets/icons/complaints.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.COMPLAINTS,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.COMPLAINTS),
                        ),
                        NavItem(
                          text: "Payments",
                          iconAsset: "assets/icons/payments.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.PAYMENTS,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.PAYMENTS),
                        ),
                        NavItem(
                          text: "Leaves",
                          iconAsset: "assets/icons/leaves.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.LEAVES,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.LEAVES),
                        ),
                        NavItem(
                          text: "Notices",
                          iconAsset: "assets/icons/notices.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.NOTICES,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.NOTICES),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Divider(
                            color: DMColors.mutedBlue,
                          ),
                        ),
                        NavItem(
                          text: "Profile",
                          iconAsset: "assets/icons/profile.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.PROFILE,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.PROFILE),
                        ),
                        NavItem(
                          text: "Help",
                          iconAsset: "assets/icons/help.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.HELP,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.HELP),
                        ),
                        NavItem(
                          text: "About",
                          iconAsset: "assets/icons/about.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.ABOUT,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.ABOUT),
                        ),
                        NavItem(
                          text: "Share",
                          iconAsset: "assets/icons/share.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.SHARE,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.SHARE),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
