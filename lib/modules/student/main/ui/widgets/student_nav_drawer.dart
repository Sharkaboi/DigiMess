import 'package:DigiMess/common/styles/colors.dart';
import 'package:DigiMess/common/widgets/nav_item.dart';
import 'package:DigiMess/modules/student/main/ui/util/nav_destination_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentNavDrawer extends StatelessWidget {
  final Function(String) itemOnClickCallBack;
  final String currentScreen;

  const StudentNavDrawer(
      {Key key, this.itemOnClickCallBack, this.currentScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 300,
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
                        color: Colors.white,
                        iconSize: 24,
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavItem(
                        text: "Home",
                        iconAsset: "assets/icons/home.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.HOME.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.HOME.toStringValue()),
                      ),
                      NavItem(
                        text: "Menu",
                        iconAsset: "assets/icons/menu.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.MENU.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.MENU.toStringValue()),
                      ),
                      NavItem(
                        text: "Complaints",
                        iconAsset: "assets/icons/complaints.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.COMPLAINTS.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.COMPLAINTS.toStringValue()),
                      ),
                      NavItem(
                        text: "Payments",
                        iconAsset: "assets/icons/payments.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.PAYMENTS.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.PAYMENTS.toStringValue()),
                      ),
                      NavItem(
                        text: "Leaves",
                        iconAsset: "assets/icons/leaves.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.LEAVES.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.LEAVES.toStringValue()),
                      ),
                      NavItem(
                        text: "Notices",
                        iconAsset: "assets/icons/notices.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.NOTICES.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.NOTICES.toStringValue()),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Divider(
                          color: DMColors.mutedBlue,
                        ),
                      ),
                      NavItem(
                        text: "Profile",
                        iconAsset: "assets/icons/profile.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.PROFILE.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.PROFILE.toStringValue()),
                      ),
                      NavItem(
                        text: "Settings",
                        iconAsset: "assets/icons/settings.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.SETTINGS.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.SETTINGS.toStringValue()),
                      ),
                      NavItem(
                        text: "Help",
                        iconAsset: "assets/icons/help.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.HELP.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.HELP.toStringValue()),
                      ),
                      NavItem(
                        text: "About",
                        iconAsset: "assets/icons/about.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.ABOUT.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.ABOUT.toStringValue()),
                      ),
                      NavItem(
                        text: "Share",
                        iconAsset: "assets/icons/share.svg",
                        isItemSelected: currentScreen ==
                            StudentNavDestinations.SHARE.toStringValue(),
                        onClick: () => itemOnClickCallBack(
                            StudentNavDestinations.SHARE.toStringValue()),
                      ),
                    ],
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
