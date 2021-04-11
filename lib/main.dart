import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_theme.dart';
import 'package:DigiMess/common/router/app_router.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DigiMess());
}

class DigiMess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EquatableConfig.stringify = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: DMColors.darkBlue,
        statusBarIconBrightness: Brightness.light));

    return BlocProvider<DMBloc>(
      create: (_) => DMBloc(DMIdleState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: DMTheme.themeData(context: context),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
