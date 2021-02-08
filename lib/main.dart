import 'package:DigiMess/common/router/app_router.dart';
import 'package:DigiMess/common/styles/theme/theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DigiMess());
}

class DigiMess extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(false, context),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
