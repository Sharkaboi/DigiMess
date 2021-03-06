import 'package:DigiMess/common/bloc/internet_bloc.dart';
import 'package:DigiMess/common/bloc/internet_states.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_theme.dart';
import 'package:DigiMess/common/router/app_router.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DigiMess());
}

class DigiMess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EquatableConfig.stringify = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: DMColors.darkBlue, statusBarIconBrightness: Brightness.light));
    return BlocProvider(
      create: (_) => InternetBloc(InternetIdleState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: DMTheme.themeData(context: context),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
