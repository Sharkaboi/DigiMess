import 'package:DigiMess/common/bloc/internet_bloc.dart';
import 'package:DigiMess/common/bloc/internet_events.dart';
import 'package:DigiMess/common/bloc/internet_states.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/widgets/no_network_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class InternetCheckScaffold extends StatefulWidget {
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
  final TabBar tabBar;
  final void Function(bool) onDrawerChanged;
  final void Function(bool) onEndDrawerChanged;
  final String restorationId;

  InternetCheckScaffold({
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
    this.backgroundColor = DMColors.lightBlue,
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
    this.tabBar,
  })  : assert(primary != null),
        assert(extendBody != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null),
        super(key: key);

  @override
  _InternetCheckScaffoldState createState() => _InternetCheckScaffoldState();
}

class _InternetCheckScaffoldState extends State<InternetCheckScaffold> {
  InternetBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.key,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        onDrawerChanged: widget.onDrawerChanged,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        restorationId: widget.restorationId,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        drawerScrimColor: widget.drawerScrimColor,
        appBar: widget.isAppBarRequired
            ? AppBar(
                centerTitle: widget.isCenterAppBarTitle,
                brightness: Brightness.dark,
                title: Text(
                  widget.appBarTitleText.capitalizeFirst(),
                  style: widget.appBarTitleTextStyle ?? DMTypo.bold16WhiteTextStyle,
                ),
                leading: widget.drawer != null
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: DMColors.white,
                        ),
                        onPressed: widget.appBarBackCallback ?? () => Navigator.of(context).pop(),
                      ),
                actions: widget.actionMenu,
                bottom: widget.tabBar != null
                    ? PreferredSize(
                        preferredSize: widget.tabBar.preferredSize,
                        child: Container(
                            decoration: BoxDecoration(color: DMColors.primaryBlue, boxShadow: [
                              BoxShadow(
                                  color: DMColors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: Offset(0, 4))
                            ]),
                            child: widget.tabBar))
                    : null,
              )
            : null,
        body: SafeArea(child: BlocBuilder<InternetBloc, InternetStates>(builder: (context, state) {
          _bloc = BlocProvider.of<InternetBloc>(context);
          if (state is InternetIdleState) {
            _bloc.add(InitNetworkStateListener());
            return KeyboardAvoider(child: Container());
          } else if (state is NoNetworkState) {
            return KeyboardAvoider(child: NoNetworkScreen());
          } else {
            // for NetworkConnectedState.
            return KeyboardAvoider(child: widget.body);
          }
        })));
  }
}
