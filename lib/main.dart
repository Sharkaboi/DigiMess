import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/router/app_router.dart';
import 'package:DigiMess/common/styles/theme/theme_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(DigiMess());
}

class DigiMess extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    EquatableConfig.stringify = true;

    return BlocProvider<DMBloc>(
      create: (_) => DMBloc(DMIdleState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(false, context),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
