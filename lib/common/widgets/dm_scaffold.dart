import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/no_network_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class DMScaffold extends StatelessWidget {
  final body;
  final floatingActionButton;
  final floatingActionButtonLocation;
  final floatingActionButtonAnimator;
  final persistentFooterButtons;
  final drawer;
  final endDrawer;
  final bottomNavigationBar;
  final bottomSheet;
  final backgroundColor;
  final resizeToAvoidBottomInset;
  final primary;
  final drawerDragStartBehavior;
  final extendBody;
  final extendBodyBehindAppBar;
  final drawerScrimColor;
  final drawerEdgeDragWidth;
  final drawerEnableOpenDragGesture;
  final endDrawerEnableOpenDragGesture;

  final bool isAppBarRequired;
  final bool isCenterAppBarTitle;
  final String appBarTitleText;
  final VoidCallback appBarBackCallback;
  final List<Widget> actionMenu;
  final TextStyle appBarTitleTextStyle;
  DMBloc _dmBloc;

  final void Function(bool) onDrawerChanged;
  final void Function(bool) onEndDrawerChanged;
  final String restorationId;

  DMScaffold({
    Key key,
    @required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.isAppBarRequired = false,
    this.isCenterAppBarTitle = false,
    this.appBarTitleText = "",
    this.appBarBackCallback,
    this.actionMenu = const [],
    this.appBarTitleTextStyle,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    _dmBloc = BlocProvider.of<DMBloc>(context);
    return Scaffold(
        key: key,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        persistentFooterButtons: persistentFooterButtons,
        drawer: drawer,
        endDrawer: endDrawer,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        restorationId: restorationId,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        drawerDragStartBehavior: drawerDragStartBehavior,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        drawerScrimColor: drawerScrimColor,
        appBar: isAppBarRequired
            ? AppBar(
                centerTitle: isCenterAppBarTitle,
                brightness: Brightness.dark,
                title: Text(
                  appBarTitleText,
                  style: appBarTitleTextStyle ?? TextStyle(color: Colors.white),
                ),
                leading: drawer != null
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: appBarBackCallback ??
                            () => Navigator.of(context).pop(),
                      ),
                actions: actionMenu,
              )
            : null,
        body: SafeArea(
            left: true,
            top: true,
            bottom: false,
            right: true,
            child: BlocConsumer<DMBloc, DMStates>(listener: (context, state) {
              if (state is UserLoggedOut) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.AUTH_SCREEN, (route) => false);
              } else if (state is DMErrorState) {
                DMSnackBar.show(context, state.errorMessage);
              }
            }, builder: (context, state) {
              if (state is DMIdleState) {
                _dmBloc.add(InitNetworkStateListener());
                return KeyboardAvoider(child: Container());
              } else if (state is NoNetworkState) {
                return KeyboardAvoider(child: NoNetworkScreen());
              } else if (state is NetworkConnectedState) {
                _dmBloc.add(CheckDMStatus());
                return KeyboardAvoider(child: body);
              } else {
                // for UserLoggedOut, UserLoggedIn, DMErrorState.
                return KeyboardAvoider(child: body);
              }
            })));
  }
}
