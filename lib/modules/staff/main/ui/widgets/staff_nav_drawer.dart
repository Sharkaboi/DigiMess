import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/widgets/nav_item.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StaffNavDrawer extends StatelessWidget {
  final Function(StaffNavDestinations) itemOnClickCallBack;
  final StaffNavDestinations currentScreen;

  const StaffNavDrawer({Key key, this.itemOnClickCallBack, this.currentScreen})
      : super(key: key);

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
                    SvgPicture.asset("assets/logo/ic_foreground.svg",
                        height: 30),
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
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavItem(
                          text: "Home",
                          iconAsset: "assets/icons/home.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.HOME,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.HOME),
                        ),
                        NavItem(
                          text: "Students",
                          iconAsset: "assets/icons/students.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.STUDENTS,
                          onClick: () => itemOnClickCallBack(
                              StaffNavDestinations.STUDENTS),
                        ),
                        NavItem(
                          text: "Menu",
                          iconAsset: "assets/icons/menu.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.MENU,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.MENU),
                        ),
                        NavItem(
                          text: "Notices",
                          iconAsset: "assets/icons/notices.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.NOTICES,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.NOTICES),
                        ),
                        NavItem(
                          text: "Mess cuts",
                          iconAsset: "assets/icons/leaves.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.LEAVES,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.LEAVES),
                        ),
                        NavItem(
                          text: "Annual Poll",
                          iconAsset: "assets/icons/poll.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.POLL,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.POLL),
                        ),
                        NavItem(
                          text: "Complaints",
                          iconAsset: "assets/icons/complaints.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.COMPLAINTS,
                          onClick: () => itemOnClickCallBack(
                              StaffNavDestinations.COMPLAINTS),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Divider(
                            color: DMColors.mutedBlue,
                          ),
                        ),
                        NavItem(
                          text: "Help",
                          iconAsset: "assets/icons/help.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.HELP,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.HELP),
                        ),
                        NavItem(
                          text: "About",
                          iconAsset: "assets/icons/about.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.ABOUT,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.ABOUT),
                        ),
                        NavItem(
                          text: "Logout",
                          iconAsset: "assets/icons/log_out.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.LOGOUT,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.LOGOUT),
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
