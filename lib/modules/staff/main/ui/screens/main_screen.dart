import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/staff/help/ui/screen/help_screen.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/home_repository.dart';
import 'package:DigiMess/modules/staff/home/ui/screens/home_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/widgets/staff_nav_drawer.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:DigiMess/modules/student/about/ui/about_dialog.dart';
import 'package:flutter/material.dart'hide AboutDialog;
import 'package:flutter_bloc/flutter_bloc.dart';


class StaffMainScreen extends StatefulWidget {
  @override
  _StaffMainScreenState createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  StaffNavDestinations currentScreen = StaffNavDestinations.HOME;

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: getTitleFromCurrentScreen(),
      body: getCurrentScreen(),
      floatingActionButton: getFab(),
      drawer: StaffNavDrawer(
        currentScreen: currentScreen,
        itemOnClickCallBack: itemOnClick,
      ),
    );
  }

  Widget getCurrentScreen() {
    if (currentScreen == StaffNavDestinations.HOME) {
      return BlocProvider(
          create: (_) => StaffHomeBloc(
              StaffHomeIdle(),
              StaffHomeRepository(
                  FirebaseClient.getMenuCollectionReference(),
                  FirebaseClient.getNoticesCollectionReference(),
                  FirebaseClient.getAbsenteesCollectionReference(),
                  FirebaseClient.getUsersCollectionReference())),
          child: StaffHomeScreen(
            noticesCallback: noticesCallback,
          ));
    } else if (currentScreen == StaffNavDestinations.STUDENTS) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.MENU) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.NOTICES) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.LEAVES) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.POLL) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.COMPLAINTS) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.HELP) {
      return StaffHelpScreen();
    } else if (currentScreen == StaffNavDestinations.ABOUT) {
      return Container();
    } else {
      return Container();
    }
  }

  void noticesCallback() {
    setState(() {
      currentScreen = StaffNavDestinations.NOTICES;
    });
  }

  itemOnClick(StaffNavDestinations destination) {
    Navigator.pop(context);
    if (destination == StaffNavDestinations.LOGOUT) {
      showLogOutAlertDialog();
    } else if(destination == StaffNavDestinations.ABOUT) {
      openAboutDialog();
    }else {
      setState(() {
        currentScreen = destination;
      });
    }
  }

  String getTitleFromCurrentScreen() {
    return currentScreen.toStringValue();
  }

  void showLogOutAlertDialog() async {
    final bool choice = await DMAlertDialog.show(context, "Logout of Digimess?");
    if (choice) {
      BlocProvider.of<DMBloc>(context).add(LogOutUser());
    }
  }
  void openAboutDialog() async{
    await AboutDialog.show(context);
  }

  FloatingActionButton getFab() {
    return null;
  }
}
