import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/student/about/ui/screens/about_screen.dart';
import 'package:DigiMess/modules/student/complaints/ui/screens/complaints_screen.dart';
import 'package:DigiMess/modules/student/help/ui/screens/help_screen.dart';
import 'package:DigiMess/modules/student/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/data/home_repository.dart';
import 'package:DigiMess/modules/student/home/ui/screens/home_screen.dart';
import 'package:DigiMess/modules/student/leaves/ui/screens/leaves_screen.dart';
import 'package:DigiMess/modules/student/main/ui/widgets/student_nav_drawer.dart';
import 'package:DigiMess/modules/student/main/util/nav_destination_enum.dart';
import 'package:DigiMess/modules/student/menu/ui/screens/menu_screen.dart';
import 'package:DigiMess/modules/student/notices/ui/screens/notices_screen.dart';
import 'package:DigiMess/modules/student/payment_history/ui/screens/payment_history_screen.dart';
import 'package:DigiMess/modules/student/profile/ui/screens/profile_screen.dart';
import 'package:DigiMess/modules/student/settings/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentMainScreen extends StatefulWidget {
  @override
  _StudentMainScreenState createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  String currentScreen = StudentNavDestinations.HOME.toStringValue();

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: getTitleFromCurrentScreen(),
      body: getCurrentScreen(),
      floatingActionButton: getFab(),
      drawer: StudentNavDrawer(
        currentScreen: currentScreen,
        itemOnClickCallBack: itemOnClick,
      ),
    );
  }

  Widget getCurrentScreen() {
    if (currentScreen == StudentNavDestinations.HOME.toStringValue()) {
      return BlocProvider(
          create: (_) => StudentHomeBloc(
              StudentHomeIdle(),
              HomeRepository(
                  FirebaseClient.getMenuCollectionReference(),
                  FirebaseClient.getNoticesCollectionReference(),
                  FirebaseClient.getPaymentsCollectionReference())),
          child: StudentHomeScreen(
            noticesCallback: noticesCallback,
          ));
    } else if (currentScreen == StudentNavDestinations.MENU.toStringValue()) {
      return StudentMenuScreen();
    } else if (currentScreen ==
        StudentNavDestinations.COMPLAINTS.toStringValue()) {
      return StudentComplaintsScreen();
    } else if (currentScreen ==
        StudentNavDestinations.PAYMENTS.toStringValue()) {
      return StudentPaymentHistoryScreen();
    } else if (currentScreen == StudentNavDestinations.LEAVES.toStringValue()) {
      return StudentLeavesScreen();
    } else if (currentScreen ==
        StudentNavDestinations.NOTICES.toStringValue()) {
      return StudentNoticesScreen();
    } else if (currentScreen ==
        StudentNavDestinations.PROFILE.toStringValue()) {
      return StudentProfileScreen();
    } else if (currentScreen ==
        StudentNavDestinations.SETTINGS.toStringValue()) {
      return StudentSettingsScreen();
    } else if (currentScreen == StudentNavDestinations.HELP.toStringValue()) {
      return StudentHelpScreen();
    } else if (currentScreen == StudentNavDestinations.ABOUT.toStringValue()) {
      return StudentAboutScreen();
    } else {
      return Container();
    }
  }

  itemOnClick(String destination) {
    Navigator.pop(context);
    if (destination == StudentNavDestinations.SHARE.toStringValue()) {
      showShareDialog();
    } else {
      setState(() {
        currentScreen = destination;
      });
    }
  }

  String getTitleFromCurrentScreen() {
    return currentScreen;
  }

  void showShareDialog() {
    //todo: navigate to share dialog screen
  }

  void noticesCallback() {
    setState(() {
      currentScreen = StudentNavDestinations.NOTICES.toStringValue();
    });
  }

  FloatingActionButton getFab() {
    if (currentScreen == StudentNavDestinations.HOME.toStringValue()) {
      return FloatingActionButton(
          onPressed: openMessCard,
          heroTag: "messCard",
          backgroundColor: DMColors.darkBlue,
          child: SvgPicture.asset("assets/icons/mess_card_icon.svg",
              color: DMColors.white));
    } else {
      return null;
    }
  }

  void openMessCard() {
    //todo: navigate to mess card screen
  }
}
