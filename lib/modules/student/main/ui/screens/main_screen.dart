import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/student/complaints/data/complaints_repository.dart';
import 'package:DigiMess/modules/student/complaints/ui/screens/complaints_screen.dart';
import 'package:DigiMess/modules/student/help/ui/screens/help_screen.dart';
import 'package:DigiMess/modules/student/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/data/home_repository.dart';
import 'package:DigiMess/modules/student/home/ui/screens/home_screen.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/student/leaves/data/leaves_repository.dart';
import 'package:DigiMess/modules/student/leaves/ui/screens/leaves_screen.dart';
import 'package:DigiMess/modules/student/main/ui/widgets/student_nav_drawer.dart';
import 'package:DigiMess/modules/student/main/util/student_nav_destinations.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_bloc.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_states.dart';
import 'package:DigiMess/modules/student/menu/data/menu_repository.dart';
import 'package:DigiMess/modules/student/menu/ui/screens/menu_screen.dart';
import 'package:DigiMess/modules/student/mess_card/ui/mess_card.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/student/notices/data/notices_repository.dart';
import 'package:DigiMess/modules/student/notices/ui/screens/notices_screen.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/student/payment_history/data/payments_repository.dart';
import 'package:DigiMess/modules/student/payment_history/ui/screens/payment_history_screen.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_bloc.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_states.dart';
import 'package:DigiMess/modules/student/profile/data/profile_repository.dart';
import 'package:DigiMess/modules/student/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';

class StudentMainScreen extends StatefulWidget {
  @override
  _StudentMainScreenState createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  StudentNavDestinations currentScreen = StudentNavDestinations.HOME;

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: getTitleFromCurrentScreen(),
      body: WillPopScope(onWillPop: _willPop, child: getCurrentScreen()),
      floatingActionButton: getFab(),
      drawer: StudentNavDrawer(
        currentScreen: currentScreen,
        itemOnClickCallBack: itemOnClick,
      ),
    );
  }

  Widget getCurrentScreen() {
    if (currentScreen == StudentNavDestinations.HOME) {
      return BlocProvider(
          create: (_) => StudentHomeBloc(
              StudentHomeIdle(),
              StudentHomeRepository(
                  FirebaseClient.getMenuCollectionReference(),
                  FirebaseClient.getNoticesCollectionReference(),
                  FirebaseClient.getPaymentsCollectionReference(),
                  FirebaseClient.getAbsenteesCollectionReference())),
          child: StudentHomeScreen(
            noticesCallback: noticesCallback,
          ));
    } else if (currentScreen == StudentNavDestinations.MENU) {
      return BlocProvider(
          create: (_) => StudentMenuBloc(StudentMenuIdle(),
              StudentMenuRepository(FirebaseClient.getMenuCollectionReference())),
          child: StudentMenuScreen());
    } else if (currentScreen == StudentNavDestinations.COMPLAINTS) {
      return BlocProvider(
          create: (_) => StudentComplaintsBloc(StudentComplaintsIdle(),
              StudentComplaintsRepository(FirebaseClient.getComplaintsCollectionReference())),
          child: StudentComplaintsScreen());
    } else if (currentScreen == StudentNavDestinations.PAYMENTS) {
      return BlocProvider(
          create: (_) => StudentPaymentsBloc(StudentPaymentsIdle(),
              StudentPaymentsRepository(FirebaseClient.getPaymentsCollectionReference())),
          child: StudentPaymentHistoryScreen());
    } else if (currentScreen == StudentNavDestinations.LEAVES) {
      return BlocProvider(
          create: (_) => StudentLeaveBloc(StudentLeaveIdle(),
              StudentLeavesRepository(FirebaseClient.getAbsenteesCollectionReference())),
          child: StudentLeavesScreen());
    } else if (currentScreen == StudentNavDestinations.NOTICES) {
      return BlocProvider(
          create: (_) => StudentNoticesBloc(StudentNoticesIdle(),
              StudentNoticesRepository(FirebaseClient.getNoticesCollectionReference())),
          child: StudentNoticesScreen());
    } else if (currentScreen == StudentNavDestinations.PROFILE) {
      return BlocProvider(
          create: (_) => StudentProfileBloc(StudentProfileIdle(),
              StudentProfileRepository(FirebaseClient.getUsersCollectionReference())),
          child: StudentProfileScreen());
    } else if (currentScreen == StudentNavDestinations.HELP) {
      return StudentHelpScreen();
    } else {
      return Container();
    }
  }

  itemOnClick(StudentNavDestinations destination) {
    Navigator.pop(context);
    if (destination == StudentNavDestinations.SHARE) {
      showShareDialog();
    } else if (destination == StudentNavDestinations.ABOUT) {
      openAboutDialog();
    } else {
      setState(() {
        currentScreen = destination;
      });
    }
  }

  String getTitleFromCurrentScreen() {
    return currentScreen.toStringValue();
  }

  void showShareDialog() {
    Share.share(DMDetails.description + "\n" + DMDetails.githubLink);
  }

  void noticesCallback() {
    setState(() {
      currentScreen = StudentNavDestinations.NOTICES;
    });
  }

  FloatingActionButton getFab() {
    if (currentScreen == StudentNavDestinations.HOME ||
        currentScreen == StudentNavDestinations.PROFILE) {
      return FloatingActionButton(
          onPressed: openMessCard,
          heroTag: "messCard",
          backgroundColor: DMColors.darkBlue,
          child: SvgPicture.asset("assets/icons/mess_card_icon.svg", color: DMColors.white));
    } else {
      return null;
    }
  }

  void openMessCard() {
    StudentMessCard.show(context);
  }

  void openAboutDialog() async {
    await DMAboutDialog.show(context);
  }

  Future<bool> _willPop() async {
    if (currentScreen != StudentNavDestinations.HOME) {
      setState(() {
        currentScreen = StudentNavDestinations.HOME;
      });
      return false;
    } else {
      return true;
    }
  }
}
