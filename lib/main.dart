import 'package:DigiMess/common/router/app_router.dart';
import 'package:DigiMess/common/theme_data/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(DigiMess());
}

class DigiMess extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: DMColors.primaryBlue,
        accentColor: DMColors.accentBlue,
        cursorColor: DMColors.primaryBlue,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: DMColors.grey),
        ),
        textTheme: GoogleFonts.comfortaaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
