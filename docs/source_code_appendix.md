# common\bloc\dm_bloc.dart  
```dart
import 'dart:async';

import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DMBloc extends Bloc<DMEvents, DMStates> {
  StreamSubscription _internetStateStream;
  Connectivity connectivity = Connectivity();

  DMBloc(DMStates initialState) : super(initialState);

  @override
  Stream<DMStates> mapEventToState(DMEvents event) async* {
    try {
      if (event is InitNetworkStateListener) {
        ConnectivityResult result = await connectivity.checkConnectivity();
        add(OnNetworkStateChanged(result));
        _internetStateStream = connectivity.onConnectivityChanged
            .listen((ConnectivityResult result) => add(OnNetworkStateChanged(result)));
      } else if (event is OnNetworkStateChanged) {
        if (event.connectivityResult == ConnectivityResult.none) {
          yield NoNetworkState();
        } else {
          yield NetworkConnectedState();
        }
      } else if (event is LogOutUser) {
        await SharedPrefRepository.logOutUser();
        // await FirebaseAuth.instance.signOut();
        yield UserLoggedOut();
      } else {
        final AppStatus appStatus = await SharedPrefRepository.getAppClientStatus();
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.signInAnonymously();
        }
        if (appStatus.userType == UserType.GUEST ||
            appStatus.username == null ||
            appStatus.userId == null) {
          await SharedPrefRepository.logOutUser();
          await FirebaseAuth.instance.signOut();
          yield UserLoggedOut();
        } else {
          yield UserLoggedIn();
        }
      }
    } catch (e) {
      print(e);
      yield DMErrorState(e.toString());
    }
  }

  @override
  Future<void> close() {
    _internetStateStream.cancel();
    return super.close();
  }
}
  
```  
# common\bloc\dm_events.dart  
```dart
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class DMEvents extends Equatable {
  const DMEvents();
}

class CheckDMStatus extends DMEvents {
  @override
  List<Object> get props => [];
}

class LogOutUser extends DMEvents {
  @override
  List<Object> get props => [];
}

class InitNetworkStateListener extends DMEvents {
  @override
  List<Object> get props => [];
}

class OnNetworkStateChanged extends DMEvents {
  final ConnectivityResult connectivityResult;

  OnNetworkStateChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult];
}
  
```  
# common\bloc\dm_states.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class DMStates extends Equatable {
  const DMStates();
}

class DMIdleState extends DMStates {
  @override
  List<Object> get props => [];
}

class DMErrorState extends DMStates {
  final String errorMessage;

  DMErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UserLoggedOut extends DMStates {
  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DMStates {
  @override
  List<Object> get props => [];
}

class NoNetworkState extends DMStates {
  @override
  List<Object> get props => [];
}

class NetworkConnectedState extends DMStates {
  @override
  List<Object> get props => [];
}
  
```  
# common\bloc\internet_bloc.dart  
```dart
import 'dart:async';

import 'package:DigiMess/common/bloc/internet_events.dart';
import 'package:DigiMess/common/bloc/internet_states.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetBloc extends Bloc<InternetEvents, InternetStates> {
  StreamSubscription _internetStateStream;
  Connectivity connectivity = Connectivity();

  InternetBloc(InternetStates initialState) : super(initialState);

  @override
  Stream<InternetStates> mapEventToState(InternetEvents event) async* {
    if (event is InitNetworkStateListener) {
      ConnectivityResult result = await connectivity.checkConnectivity();
      add(OnNetworkStateChanged(result));
      _internetStateStream = connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) => add(OnNetworkStateChanged(result)));
    } else if (event is OnNetworkStateChanged) {
      if (event.connectivityResult == ConnectivityResult.none) {
        yield NoNetworkState();
      } else {
        yield NetworkConnectedState();
      }
    }
  }

  @override
  Future<void> close() {
    _internetStateStream.cancel();
    return super.close();
  }
}
  
```  
# common\bloc\internet_events.dart  
```dart
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class InternetEvents extends Equatable {
  const InternetEvents();
}

class InitNetworkStateListener extends InternetEvents {
  @override
  List<Object> get props => [];
}

class OnNetworkStateChanged extends InternetEvents {
  final ConnectivityResult connectivityResult;

  OnNetworkStateChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult];
}
  
```  
# common\bloc\internet_states.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class InternetStates extends Equatable {
  const InternetStates();
}

class InternetIdleState extends InternetStates {
  @override
  List<Object> get props => [];
}

class NoNetworkState extends InternetStates {
  @override
  List<Object> get props => [];
}

class NetworkConnectedState extends InternetStates {
  @override
  List<Object> get props => [];
}
  
```  
# common\constants\app_faqs.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class _FAQ extends Equatable {
  const _FAQ._({@required this.question, @required this.answer});

  final String question;
  final String answer;

  @override
  List<Object> get props => [this.question, this.answer];
}

class DMFaqs {
  const DMFaqs._();

  static const studentFAQs = [
    _FAQ._(question: "My payment failed, What should i do now?", answer: "It happens when your payment has not processed. Please wait a few days. If the problem continues,"),
    _FAQ._(question: "How to know the menu for the current year?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option MENU from the list. The menu for the current year will be displayed."),
    _FAQ._(question: "Where do I post my complaints?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option COMPLAINTS from the list. You can either select your complaint from a set of options or you can type it in the space provided. Click SUBMIT button at the bottom when you are done."),
    _FAQ._(question: "Where can I view my monthly mess payment history?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option PAYMENTS from the list. You will be redirected to a page showing all your previous transactions including that of monthly fees and caution deposit."),
    _FAQ._(question: "How to cancel my mess subscription?", answer: " Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option PROFILE from the list. Your profile, showing all your details will be displayed. Scroll down. Click the CLOSE ACCOUNT button provided at the bottom. An alert box asking for your confirmation will emerge. Select YES in order to confirm. Your mess subscription will be cancelled."),

  ];

  static const staffFAQs = [
    _FAQ._(question: "How to set the daily menu?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option MENU from the list. The menu for the current year will be displayed. Select a food item from the menu. Choose from the options under Availability to set that food item as breakfast, lunch and dinner. Select the days in which that food item will be served. The daily menu will be set based on your choices for each food item."),
    _FAQ._(question: "What are the steps to be followed for conducting the annual mess poll?", answer: "Annual mess poll is to be conducted during December every year. Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option ANNUAL POLL from the list. The annual poll page will be opened. When it is time, select the RESET button at the top right corner. The number of votes for each food item will be set to 0. The students can then start voting through their accounts."),
    _FAQ._(question: "Where do I post the notices regarding the mess?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option NOTICES from the list. You will reach the page displaying all the previously issued notices. Click the ADD (+) button at the bottom right corner. A new page titled NEW NOTICE will appear. Type the new notice in the space provided and click the POST button at the bottom right corner when you are done."),
    _FAQ._(question: "My payment failed, What should i do now?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option MESS CUTS from the list. You will be redirected to a page titled LEAVES. A list of leaves registered by all the students up to that point will be displayed. Leaves taken can also be seen in the students section. There you can see leaves taken by each student individually"),
    _FAQ._(question: "My payment failed, What should i do now?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option STUDENTS from the list. A list showing the names of all the enrolled students will be displayed. Select the name of the student whose account you want to disable. A page showing that student's profile will appear. Below the profile, there will be a toggle button corresponding to ACCOUNT STATUS. Click the button. An alert box requesting your confirmation will appear. Select YES if you want to confirm. The selected student's account will be disabled."),
  ];
}
  
```  
# common\constants\dm_details.dart  
```dart
class DMDetails {
  DMDetails._();

  static const String appName = "DigiMess";
  static const String appVersion = "1.0.0";
  static const String description = "Welcome to DigiMess.\nAn app to help organizations manage "
      "their food mess, mainly colleges.";

  static const List<String> contributors = [
    "Rahul R S",
    "S Atul Krishnan",
    "Sangeeth Raj P S",
    "Sarath S",
    "Ashwin Cherukat"
  ];

  static const String githubLink = "https://github.com/Sharkaboi/DigiMess";
  static const String staffPhoneNumber = "9876543210";
  static const String devPhoneNumber = "9876543210";

  static const int dailyMessPrice = 100;
  static const int dailyFinePrice = 10;
  static const int constantMessPrice = 300;
  static const int constantMessCaution = 3000;
}
  
```  
# common\constants\dm_hints.dart  
```dart
class DMHints {
  DMHints._();

  static const student = "Student";
  static const staff = "Staff";
}
  
```  
# common\constants\enums\branch_types.dart  
```dart
enum Branch { IT, CS, ME, EEE, EC, SE, CE }

extension BranchExtensions on Branch {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static Branch fromString(String formattedString) {
    switch (formattedString) {
      case "IT":
        return Branch.IT;
      case "CS":
        return Branch.CS;
      case "ME":
        return Branch.ME;
      case "EEE":
        return Branch.EEE;
      case "EC":
        return Branch.EC;
      case "SE":
        return Branch.SE;
      case "CE":
        return Branch.CE;
      default:
        return null;
    }
  }
}
  
```  
# common\constants\enums\complaint_category.dart  
```dart
enum ComplaintCategory { HYGIENE, TASTE, SERVICE, PORTION, APP, OTHER }

extension ComplaintCategoryExtensions on ComplaintCategory {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static const ComplaintCategoryHints = [
    "Hygiene",
    "Taste of food",
    "Service",
    "Portion size",
    "App related",
    "Others"
  ];

  static String getComplaintCategoryHint(ComplaintCategory complaintType) {
    return ComplaintCategoryHints[ComplaintCategory.values.indexOf(complaintType)];
  }

  static ComplaintCategory fromString(String formattedString) {
    switch (formattedString) {
      case "HYGIENE":
        return ComplaintCategory.HYGIENE;
      case "TASTE":
        return ComplaintCategory.TASTE;
      case "SERVICE":
        return ComplaintCategory.SERVICE;
      case "PORTION":
        return ComplaintCategory.PORTION;
      case "APP":
        return ComplaintCategory.APP;
      case "OTHER":
        return ComplaintCategory.OTHER;
      default:
        return null;
    }
  }
}
  
```  
# common\constants\enums\payment_account_type.dart  
```dart
enum PaymentAccountType { CARD, CASH }

extension PaymentAccountTypeExtensions on PaymentAccountType {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static PaymentAccountType fromString(String formattedString) {
    switch (formattedString) {
      case "CARD":
        return PaymentAccountType.CARD;
      case "CASH":
        return PaymentAccountType.CASH;
      default:
        return null;
    }
  }
}
  
```  
# common\constants\enums\user_types.dart  
```dart
enum UserType { STUDENT, STAFF, GUEST }

extension UserTypeExtensions on UserType {
  String toStringValue() {
    return this.toString().split('.').last;
  }

  static UserType fromString(String formattedString) {
    switch (formattedString) {
      case "STUDENT":
        return UserType.STUDENT;
      case "STAFF":
        return UserType.STAFF;
      default:
        return UserType.GUEST;
    }
  }
}
  
```  
# common\constants\enums\vote_entry.dart  
```dart
import 'package:equatable/equatable.dart';

class VoteEntry extends Equatable {
  final String internalMenuId;
  final MenuItemTiming menuItemTiming;

  VoteEntry(this.internalMenuId, this.menuItemTiming);

  @override
  List<Object> get props => [internalMenuId, menuItemTiming];
}

enum MenuItemTiming { BREAKFAST, LUNCH, DINNER }

extension MenuItemTimingExtension on MenuItemTiming {
  String getFirebaseFieldName() {
    if (this == MenuItemTiming.BREAKFAST) {
      return "forBreakFast";
    } else if (this == MenuItemTiming.LUNCH) {
      return "forLunch";
    } else {
      return "forDinner";
    }
  }
}
  
```  
# common\crypto\password_hasher.dart  
```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHashManager {
  PasswordHashManager._();

  static const _HASH_ALGO = "sha256";

  static String hashPassword(String unHashedPassword) {
    final List<int> utf8FormattedList = utf8.encode(unHashedPassword);
    final Digest hashedPassword = sha256.convert(utf8FormattedList);
    return hashedPassword.toString();
  }

  static bool verifyPassword({String hashedPasswordFromServer, String unHashedPassword}) {
    return hashPassword(unHashedPassword) == hashedPasswordFromServer;
  }
}
  
```  
# common\design\dm_colors.dart  
```dart
import 'dart:ui';

class DMColors {
  DMColors._();

  static const Color primaryBlue = Color.fromRGBO(21, 101, 192, 1);
  static const Color accentBlue = Color.fromRGBO(94, 146, 243, 1);
  static const Color darkBlue = Color.fromRGBO(0, 60, 143, 1);
  static const Color mutedBlue = Color.fromRGBO(103, 126, 170, 1);

  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color grey = Color.fromRGBO(0, 0, 0, 0.6);

  static const Color lightBlue = Color.fromRGBO(237, 243, 252, 1);
  static const Color blueBg = Color.fromRGBO(193, 219, 255, 1);
  static const Color yellow = Color.fromRGBO(234, 238, 50, 1);
  static const Color green = Color.fromRGBO(47, 171, 44, 1);
  static const Color red = Color.fromRGBO(244, 9, 9, 1);
  static const Color textFieldMutedBg = Color.fromRGBO(230, 232, 239, 1);
}
  
```  
# common\design\dm_theme.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMTheme {
  DMTheme._();

  static const FONT_NAME = "Comfortaa";

  static ThemeData themeData({bool isDarkTheme = false, BuildContext context}) {
    final base = isDarkTheme ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
        fontFamily: FONT_NAME,
        primaryColor: DMColors.primaryBlue,
        accentColor: DMColors.accentBlue,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: DMColors.primaryBlue,
            selectionHandleColor: DMColors.primaryBlue,
            selectionColor: DMColors.primaryBlue.withOpacity(0.3)),
        backgroundColor: isDarkTheme ? DMColors.black : DMColors.white,
        scaffoldBackgroundColor: DMColors.lightBlue,
        indicatorColor: DMColors.primaryBlue.withOpacity(0.3),
        buttonColor: DMColors.primaryBlue,
        hintColor: DMColors.grey.withOpacity(0.3),
        highlightColor: DMColors.primaryBlue.withOpacity(0.3),
        hoverColor: DMColors.primaryBlue.withOpacity(0.3),
        focusColor: DMColors.primaryBlue.withOpacity(0.3),
        disabledColor: DMColors.grey,
        textTheme: base.textTheme.copyWith(
          subtitle2: base.textTheme.subtitle2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          overline: base.textTheme.overline.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline6: base.textTheme.headline6.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline5: base.textTheme.headline5.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline4: base.textTheme.headline4.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline3: base.textTheme.headline3.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline2: base.textTheme.headline2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline1: base.textTheme.headline1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          subtitle1: base.textTheme.subtitle1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          caption: base.textTheme.caption.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          bodyText1: base.textTheme.bodyText1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          bodyText2: base.textTheme.bodyText2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          button: TextStyle(fontFamily: FONT_NAME),
        ),
        tabBarTheme: TabBarTheme(
            labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: DMColors.white,
                fontFamily: FONT_NAME),
            unselectedLabelStyle: TextStyle(
                fontSize: 14,
                color: DMColors.accentBlue,
                fontFamily: FONT_NAME)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(DMColors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                overlayColor: MaterialStateProperty.all(
                    DMColors.primaryBlue.withOpacity(0.3)),
                textStyle: MaterialStateProperty.all(TextStyle(
                    color: DMColors.primaryBlue, fontFamily: FONT_NAME)),
                foregroundColor:
                    MaterialStateProperty.all(DMColors.primaryBlue))),
        dividerColor: DMColors.mutedBlue,
        cardColor: isDarkTheme ? DMColors.black : DMColors.white,
        canvasColor: isDarkTheme ? DMColors.black : DMColors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          brightness: Brightness.dark,
          titleTextStyle: DMTypo.bold16WhiteTextStyle,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: DMColors.grey, fontFamily: FONT_NAME),
        ),
        cardTheme: CardTheme(
          color: DMColors.white,
        ),
        popupMenuTheme: PopupMenuThemeData(
            color: DMColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(
                fontSize: 14, color: DMColors.black, fontFamily: FONT_NAME)),
        tooltipTheme: TooltipThemeData(
            textStyle:
                TextStyle(color: DMColors.primaryBlue, fontFamily: FONT_NAME),
            decoration: BoxDecoration(color: DMColors.white)),
        buttonTheme: ButtonThemeData(
            buttonColor: DMColors.primaryBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            textTheme: ButtonTextTheme.primary));
  }
}
  
```  
# common\design\dm_typography.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_theme.dart';
import 'package:flutter/material.dart';

class DMTypo {
  DMTypo._();

  static const TextStyle bold14UnderlinedBlackTextStyle = TextStyle(
    shadows: [
      Shadow(
        color: DMColors.black,
        offset: Offset(0, -5),
      ),
    ],
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.transparent,
    decoration: TextDecoration.underline,
    decorationColor: DMColors.grey,
    decorationThickness: 2,
  );

  static const TextStyle bold36BlackTextStyle =
      TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold30BlackTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold24BlackTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold20BlackTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold18BlackTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold16BlackTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold14BlackTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.black);
  static const TextStyle bold12BlackTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.black);

  static const TextStyle normal30BlackTextStyle = TextStyle(fontSize: 30, color: DMColors.black);
  static const TextStyle normal24BlackTextStyle = TextStyle(fontSize: 24, color: DMColors.black);
  static const TextStyle normal18BlackTextStyle = TextStyle(fontSize: 18, color: DMColors.black);
  static const TextStyle normal16BlackTextStyle = TextStyle(fontSize: 16, color: DMColors.black);
  static const TextStyle normal14BlackTextStyle = TextStyle(fontSize: 14, color: DMColors.black);
  static const TextStyle normal12BlackTextStyle = TextStyle(fontSize: 12, color: DMColors.black);

  static const TextStyle bold30PrimaryBlueTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);
  static const TextStyle bold24PrimaryBlueTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);
  static const TextStyle bold18PrimaryBlueTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);
  static const TextStyle bold16PrimaryBlueTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);
  static const TextStyle bold14PrimaryBlueTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);
  static const TextStyle bold12PrimaryBlueTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.primaryBlue);

  static const TextStyle normal30PrimaryBlueTextStyle =
      TextStyle(fontSize: 30, color: DMColors.primaryBlue);
  static const TextStyle normal24PrimaryBlueTextStyle =
      TextStyle(fontSize: 24, color: DMColors.primaryBlue);
  static const TextStyle normal18PrimaryBlueTextStyle =
      TextStyle(fontSize: 18, color: DMColors.primaryBlue);
  static const TextStyle normal16PrimaryBlueTextStyle =
      TextStyle(fontSize: 16, color: DMColors.primaryBlue);
  static const TextStyle normal14PrimaryBlueTextStyle =
      TextStyle(fontSize: 14, color: DMColors.primaryBlue);
  static const TextStyle normal12PrimaryBlueTextStyle =
      TextStyle(fontSize: 12, color: DMColors.primaryBlue);

  static const TextStyle bold30DarkBlueTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.darkBlue);
  static const TextStyle bold24DarkBlueTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.darkBlue);
  static const TextStyle bold18DarkBlueTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.darkBlue);
  static const TextStyle bold16DarkBlueTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.darkBlue);
  static const TextStyle bold14DarkBlueTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.darkBlue);
  static const TextStyle bold12DarkBlueTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.darkBlue);

  static const TextStyle normal30DarkBlueTextStyle =
      TextStyle(fontSize: 30, color: DMColors.darkBlue);
  static const TextStyle normal24DarkBlueTextStyle =
      TextStyle(fontSize: 24, color: DMColors.darkBlue);
  static const TextStyle normal18DarkBlueTextStyle =
      TextStyle(fontSize: 18, color: DMColors.darkBlue);
  static const TextStyle normal16DarkBlueTextStyle =
      TextStyle(fontSize: 16, color: DMColors.darkBlue);
  static const TextStyle normal14DarkBlueTextStyle =
      TextStyle(fontSize: 14, color: DMColors.darkBlue);
  static const TextStyle normal12DarkBlueTextStyle =
      TextStyle(fontSize: 12, color: DMColors.darkBlue);

  static const TextStyle bold30AccentBlueTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.accentBlue);
  static const TextStyle bold24AccentBlueTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.accentBlue);
  static const TextStyle bold18AccentBlueTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.accentBlue);
  static const TextStyle bold16AccentBlueTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.accentBlue);
  static const TextStyle bold14AccentBlueTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.accentBlue);
  static const TextStyle bold12AccentBlueTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.accentBlue);

  static const TextStyle normal30AccentBlueTextStyle =
      TextStyle(fontSize: 30, color: DMColors.accentBlue);
  static const TextStyle normal24AccentBlueTextStyle =
      TextStyle(fontSize: 24, color: DMColors.accentBlue);
  static const TextStyle normal18AccentBlueTextStyle =
      TextStyle(fontSize: 18, color: DMColors.accentBlue);
  static const TextStyle normal16AccentBlueTextStyle =
      TextStyle(fontSize: 16, color: DMColors.accentBlue);
  static const TextStyle normal14AccentBlueTextStyle =
      TextStyle(fontSize: 14, color: DMColors.accentBlue);
  static const TextStyle normal12AccentBlueTextStyle =
      TextStyle(fontSize: 12, color: DMColors.accentBlue);

  static const TextStyle bold36WhiteTextStyle =
      TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold30WhiteTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold24WhiteTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold18WhiteTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold16WhiteTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold14WhiteTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.white);
  static const TextStyle bold12WhiteTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.white);

  static const TextStyle normal30WhiteTextStyle = TextStyle(fontSize: 30, color: DMColors.white);
  static const TextStyle normal24WhiteTextStyle = TextStyle(fontSize: 24, color: DMColors.white);
  static const TextStyle normal18WhiteTextStyle = TextStyle(fontSize: 18, color: DMColors.white);
  static const TextStyle normal16WhiteTextStyle = TextStyle(fontSize: 16, color: DMColors.white);
  static const TextStyle normal14WhiteTextStyle = TextStyle(fontSize: 14, color: DMColors.white);
  static const TextStyle normal12WhiteTextStyle = TextStyle(fontSize: 12, color: DMColors.white);

  static const TextStyle bold30MutedTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.grey);
  static const TextStyle bold24MutedTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.grey);
  static const TextStyle bold18MutedTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.grey);
  static const TextStyle bold16MutedTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.grey);
  static const TextStyle bold14MutedTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.grey);
  static const TextStyle bold12MutedTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.grey);

  static const TextStyle normal30MutedTextStyle = TextStyle(fontSize: 30, color: DMColors.grey);
  static const TextStyle normal24MutedTextStyle = TextStyle(fontSize: 24, color: DMColors.grey);
  static const TextStyle normal18MutedTextStyle = TextStyle(fontSize: 18, color: DMColors.grey);
  static const TextStyle normal16MutedTextStyle = TextStyle(fontSize: 16, color: DMColors.grey);
  static const TextStyle normal14MutedTextStyle = TextStyle(fontSize: 14, color: DMColors.grey);
  static const TextStyle normal12MutedTextStyle = TextStyle(fontSize: 12, color: DMColors.grey);

  static const TextStyle bold30MutedBlueTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);
  static const TextStyle bold24MutedBlueTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);
  static const TextStyle bold18MutedBlueTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);
  static const TextStyle bold16MutedBlueTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);
  static const TextStyle bold14MutedBlueTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);
  static const TextStyle bold12MutedBlueTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.mutedBlue);

  static const TextStyle normal30MutedBlueTextStyle =
      TextStyle(fontSize: 30, color: DMColors.mutedBlue);
  static const TextStyle normal24MutedBlueTextStyle =
      TextStyle(fontSize: 24, color: DMColors.mutedBlue);
  static const TextStyle normal18MutedBlueTextStyle =
      TextStyle(fontSize: 18, color: DMColors.mutedBlue);
  static const TextStyle normal16MutedBlueTextStyle =
      TextStyle(fontSize: 16, color: DMColors.mutedBlue);
  static const TextStyle normal14MutedBlueTextStyle =
      TextStyle(fontSize: 14, color: DMColors.mutedBlue);
  static const TextStyle normal12MutedBlueTextStyle =
      TextStyle(fontSize: 12, color: DMColors.mutedBlue);

  static const TextStyle bold48BlackTextStyle =
      TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: DMColors.black);

  static const TextStyle bold30GreenTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.green);
  static const TextStyle bold24GreenTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.green);
  static const TextStyle bold18GreenTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.green);
  static const TextStyle bold16GreenTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.green);
  static const TextStyle bold14GreenTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.green);
  static const TextStyle bold12GreenTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.green);

  static const TextStyle normal30GreenTextStyle = TextStyle(fontSize: 30, color: DMColors.green);
  static const TextStyle normal24GreenTextStyle = TextStyle(fontSize: 24, color: DMColors.green);
  static const TextStyle normal18GreenTextStyle = TextStyle(fontSize: 18, color: DMColors.green);
  static const TextStyle normal16GreenTextStyle = TextStyle(fontSize: 16, color: DMColors.green);
  static const TextStyle normal14GreenTextStyle = TextStyle(fontSize: 14, color: DMColors.green);
  static const TextStyle normal12GreenTextStyle = TextStyle(fontSize: 12, color: DMColors.green);

  static const TextStyle bold30RedTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DMColors.red);
  static const TextStyle bold24RedTextStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DMColors.red);
  static const TextStyle bold18RedTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DMColors.red);
  static const TextStyle bold16RedTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DMColors.red);
  static const TextStyle bold14RedTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DMColors.red);
  static const TextStyle bold12RedTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DMColors.red);

  static const TextStyle normal30RedTextStyle = TextStyle(fontSize: 30, color: DMColors.red);
  static const TextStyle normal24RedTextStyle = TextStyle(fontSize: 24, color: DMColors.red);
  static const TextStyle normal18RedTextStyle = TextStyle(fontSize: 18, color: DMColors.red);
  static const TextStyle normal16RedTextStyle = TextStyle(fontSize: 16, color: DMColors.red);
  static const TextStyle normal14RedTextStyle = TextStyle(fontSize: 14, color: DMColors.red);
  static const TextStyle normal12RedTextStyle = TextStyle(fontSize: 12, color: DMColors.red);

  static const TextStyle alefBold36DarkBlueTextStyle = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: DMColors.darkBlue,
      fontFamily: 'Alef',
      fontFamilyFallback: [DMTheme.FONT_NAME]);
}
  
```  
# common\extensions\date_extensions.dart  
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  static bool isBreakfastTime() {
    final DateTime now = DateTime.now();
    return now.hour > 5 && now.hour < 11;
  }

  static bool isLunchTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 11 && now.hour < 13;
  }

  static bool isDinnerTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 13 && now.hour < 21;
  }

  static bool isNightTime() {
    final DateTime now = DateTime.now();
    return now.hour >= 21 || now.hour <= 5;
  }

  static bool isBeforeDueDate() {
    final DateTime now = DateTime.now();
    final DateTime dueDate = DateTime(now.year, now.month, 7);
    return now.isBefore(dueDate);
  }

  String getDayKey() {
    switch (this.weekday) {
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      case 7:
        return "sunday";
      default:
        return "";
    }
  }

  String getTimeAgo({bool numericDates = true}) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 8) {
      final dateFormatter = DateFormat("d MMM, yyyy");
      return "on " + dateFormatter.format(this);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  String getDifferenceInDays(DateTime other) {
    final int days = this.difference(other).inDays.abs();
    return "$days ${days == 1 ? "day" : "days"}";
  }

  bool isSameMonthAs(DateTime other) {
    return this.month == other.month && this.year == other.year;
  }

  bool isLastMonthOf(DateTime other) {
    final cleanedDateTime1 = DateTime(this.year, this.month);
    final cleanedDateTime2 = DateTime(other.year, other.month);
    return cleanedDateTime1.difference(cleanedDateTime2).inDays.abs() <= 31;
  }

  DateTime copyWith(
      {int year,
      int month,
      int day,
      int hour,
      int minute,
      int second,
      int millisecond,
      int microsecond}) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

DateTime getDateTimeOrNull(timestamp) {
  if (timestamp == null) {
    return null;
  } else if (timestamp is Timestamp) {
    return timestamp.toDate();
  }

  return DateTime.tryParse(timestamp);
}
  
```  
# common\extensions\int_extensions.dart  
```dart
import 'package:intl/intl.dart';

extension IntExtension on int {
  String getFormattedCurrency({bool isSymbol = true}) {
    final format = NumberFormat.currency(
        locale: 'en_IN', symbol: isSymbol ? "₹" : "Rs.", decimalDigits: 0);
    return format.format(this ?? 0);
  }
}
  
```  
# common\extensions\list_extensions.dart  
```dart
extension ListExtensions<T> on List<T> {
  T takeFirstOrNull() {
    if (this.isEmpty) {
      return null;
    } else {
      return this.first;
    }
  }

  ListResult<T> splitWhere(bool Function(T element) matchFunction) {
    final listMatch = ListResult<T>();
    for (final element in this) {
      if (matchFunction(element)) {
        listMatch.matched.add(element);
      } else {
        listMatch.unmatched.add(element);
      }
    }
    return listMatch;
  }
}

class ListResult<T> {
  List<T> matched = <T>[];
  List<T> unmatched = <T>[];
}
  
```  
# common\extensions\string_extensions.dart  
```dart
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String capitalize() {
    if (this.trim().isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeFirst() {
    if (this.trim().isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String getFormattedCurrency({bool isSymbol = true}) {
    final format = NumberFormat.currency(
        locale: 'en_IN', symbol: isSymbol ? "₹" : "Rs.", decimalDigits: 0);
    return format.format(int.tryParse(this) ?? double.tryParse(this) ?? 0);
  }

  bool isEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (this == null || !regex.hasMatch(this))
      return false;
    else
      return true;
  }

  bool isPhoneNumber() {
    Pattern mobileNoPattern = r'(^[0-9]{10}$)';
    RegExp regex = new RegExp(mobileNoPattern);
    if (this == null || !regex.hasMatch(this))
      return false;
    else
      return true;
  }
}
  
```  
# common\firebase\firebase_client.dart  
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseFirestore _firestoreClient;

  FirebaseClient._() {
    _firestoreClient = FirebaseFirestore.instance;
  }

  static CollectionReference getUsersCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("users");
  }

  static CollectionReference getPaymentsCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("payments");
  }

  static CollectionReference getMenuCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("menu");
  }

  static CollectionReference getComplaintsCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("complaints");
  }

  static CollectionReference getAbsenteesCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("absentees");
  }

  static CollectionReference getNoticesCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("notices");
  }
}
  
```  
# common\firebase\models\complaint.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Complaint extends Equatable {
  final String complaintId;
  final String complaint;
  final List<String> categories;
  final DocumentReference user;
  final DateTime date;

  Complaint(
      {@required this.complaintId,
      @required this.complaint,
      @required this.user,
      @required this.date,
      @required this.categories});

  factory Complaint.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Complaint(
        complaintId: documentSnapshot.id,
        user: documentData['userId'],
        date: getDateTimeOrNull(documentData['date']),
        categories: List.from(documentData['category']),
        complaint: documentData['complaint']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'date': Timestamp.fromDate(this.date),
      'complaint': this.complaint,
      'category': this.categories
    };
  }

  @override
  List<Object> get props =>
      [this.complaintId, this.complaint, this.user, this.date, this.categories];
}
  
```  
# common\firebase\models\leave_entry.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LeaveEntry extends Equatable {
  final String leaveEntryId;
  final DocumentReference user;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime applyDate;

  LeaveEntry(
      {@required this.leaveEntryId,
      @required this.user,
      @required this.startDate,
      @required this.endDate,
      @required this.applyDate});

  factory LeaveEntry.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return LeaveEntry(
        leaveEntryId: documentSnapshot.id,
        user: documentData['userId'],
        startDate: getDateTimeOrNull(documentData['startDate']),
        endDate: getDateTimeOrNull(documentData['endDate']),
        applyDate: getDateTimeOrNull(documentData['applyDate']));
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'startDate': Timestamp.fromDate(this.startDate),
      'endDate': Timestamp.fromDate(this.endDate),
      'applyDate': Timestamp.fromDate(this.applyDate)
    };
  }

  @override
  List<Object> get props => [
        this.leaveEntryId,
        this.startDate,
        this.user,
        this.endDate,
        this.applyDate
      ];
}
  
```  
# common\firebase\models\menu_item.dart  
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MenuItem extends Equatable {
  final String itemId;
  final bool isVeg;
  final String name;
  final bool isEnabled;
  final String imageUrl;
  final MenuItemIsAvailable itemIsAvailable;
  final DaysAvailable daysAvailable;
  final _AnnualPollVotes annualPollVotes;

  MenuItem(
      {@required this.itemId,
      @required this.name,
      @required this.isVeg,
      @required this.isEnabled,
      @required this.imageUrl,
      @required this.itemIsAvailable,
      @required this.annualPollVotes,
      @required this.daysAvailable});

  @override
  List<Object> get props => [
        this.itemId,
        this.name,
        this.isVeg,
        this.isEnabled,
        this.imageUrl,
        this.itemIsAvailable,
        this.annualPollVotes,
        this.daysAvailable
      ];

  factory MenuItem.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data();
    if (data == null) {
      return null;
    }
    return MenuItem(
        itemId: doc.id,
        name: data['name'],
        isVeg: data['isVeg'],
        isEnabled: data['isEnabled'],
        imageUrl: data['imageUrl'],
        itemIsAvailable: MenuItemIsAvailable.fromMap(data['isAvailable']),
        annualPollVotes: _AnnualPollVotes.fromMap(data['annualPoll']),
        daysAvailable: DaysAvailable.fromMap(data['daysAvailable']));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'isVeg': this.isVeg,
      'isEnabled': this.isEnabled,
      'imageUrl': this.imageUrl,
      'isAvailable': this.itemIsAvailable.toMap(),
      'annualPoll': this.annualPollVotes.toMap(),
      'daysAvailable': this.daysAvailable.toMap(),
    };
  }
}

class MenuItemIsAvailable extends Equatable {
  final bool isBreakfast;
  final bool isLunch;
  final bool isDinner;

  MenuItemIsAvailable(
      {@required this.isBreakfast,
      @required this.isLunch,
      @required this.isDinner});

  factory MenuItemIsAvailable.fromMap(Map<String, dynamic> mapField) {
    if (mapField == null) {
      return MenuItemIsAvailable(
          isBreakfast: false, isLunch: false, isDinner: false);
    }
    return MenuItemIsAvailable(
        isBreakfast: mapField['breakfast'],
        isDinner: mapField['dinner'],
        isLunch: mapField['lunch']);
  }

  Map<String, dynamic> toMap() {
    return {
      'breakfast': this.isBreakfast,
      'dinner': this.isDinner,
      'lunch': this.isLunch
    };
  }

  MenuItemIsAvailable copyWith(
      {bool isBreakfast, bool isLunch, bool isDinner}) {
    return MenuItemIsAvailable(
        isBreakfast: isBreakfast ?? this.isBreakfast,
        isDinner: isDinner ?? this.isDinner,
        isLunch: isLunch ?? this.isLunch);
  }

  @override
  List<Object> get props => [this.isBreakfast, this.isLunch, this.isDinner];
}

class DaysAvailable extends Equatable {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  DaysAvailable({
    @required this.monday,
    @required this.tuesday,
    @required this.wednesday,
    @required this.thursday,
    @required this.friday,
    @required this.saturday,
    @required this.sunday,
  });

  factory DaysAvailable.fromMap(Map<String, dynamic> mapField) {
    if (mapField == null) {
      return DaysAvailable(
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false);
    }
    return DaysAvailable(
        monday: mapField['monday'],
        tuesday: mapField['tuesday'],
        wednesday: mapField['wednesday'],
        thursday: mapField['thursday'],
        friday: mapField['friday'],
        saturday: mapField['saturday'],
        sunday: mapField['sunday']);
  }

  Map<String, dynamic> toMap() {
    return {
      'monday': this.monday,
      'tuesday': this.tuesday,
      'wednesday': this.wednesday,
      'thursday': this.thursday,
      'friday': this.friday,
      'saturday': this.saturday,
      'sunday': this.sunday,
    };
  }

  DaysAvailable copyWith({
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  }) {
    return DaysAvailable(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  @override
  List<Object> get props => [
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
        this.sunday
      ];
}

class _AnnualPollVotes extends Equatable {
  final int forBreakFast;
  final int forLunch;
  final int forDinner;

  _AnnualPollVotes(
      {@required this.forBreakFast,
      @required this.forLunch,
      @required this.forDinner});

  factory _AnnualPollVotes.fromMap(Map<String, dynamic> mapField) {
    if (mapField == null) {
      return _AnnualPollVotes(forBreakFast: 0, forDinner: 0, forLunch: 0);
    }
    return _AnnualPollVotes(
        forBreakFast: mapField['forBreakFast'],
        forLunch: mapField['forLunch'],
        forDinner: mapField['forDinner']);
  }

  Map<String, dynamic> toMap() {
    return {
      'forBreakFast': this.forBreakFast,
      'forLunch': this.forLunch,
      'forDinner': this.forDinner
    };
  }

  @override
  List<Object> get props => [this.forDinner, this.forLunch, this.forBreakFast];
}
  
```  
# common\firebase\models\notice.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Notice extends Equatable {
  final String noticeId;
  final String title;
  final DateTime date;

  Notice({@required this.noticeId, @required this.title, @required this.date});

  factory Notice.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Notice(
        noticeId: documentSnapshot.id,
        title: documentData['title'],
        date: getDateTimeOrNull(documentData['date']));
  }

  Map<String, dynamic> toMap() {
    return {'title': this.title, 'date': Timestamp.fromDate(this.date)};
  }

  @override
  List<Object> get props => [this.noticeId, this.title, this.date];
}
  
```  
# common\firebase\models\payment.dart  
```dart
import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Payment extends Equatable {
  final String paymentId;
  final DocumentReference user;
  final PaymentAccountType paymentAccountType;
  final DateTime paymentDate;
  final int paymentAmount;
  final String description;

  Payment(
      {@required this.paymentId,
      @required this.user,
      @required this.paymentAccountType,
      @required this.paymentDate,
      @required this.paymentAmount,
      @required this.description});

  factory Payment.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Payment(
        paymentId: documentSnapshot.id,
        user: documentData['userId'],
        paymentAccountType: PaymentAccountTypeExtensions.fromString(
            documentData['accountType']),
        paymentDate: getDateTimeOrNull(documentData['date']),
        paymentAmount: documentData['amount'],
        description: documentData['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'accountType': this.paymentAccountType.toStringValue(),
      'date': Timestamp.fromDate(this.paymentDate),
      'amount': this.paymentAmount,
      'description': this.description
    };
  }

  @override
  List<Object> get props => [
        this.paymentId,
        this.user,
        this.paymentAccountType,
        this.paymentDate,
        this.paymentAmount,
        this.description
      ];

  Payment copyWith(
      {String paymentId,
      DocumentReference user,
      PaymentAccountType paymentAccountType,
      DateTime paymentDate,
      int paymentAmount,
      String description}) {
    return Payment(
        paymentId: paymentId ?? this.paymentId,
        user: user ?? this.user,
        paymentAccountType: paymentAccountType ?? this.paymentAccountType,
        paymentDate: paymentDate ?? this.paymentDate,
        paymentAmount: paymentAmount ?? this.paymentAmount,
        description: description ?? this.description);
  }
}
  
```  
# common\firebase\models\user.dart  
```dart
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String userId;
  final String username;
  final String hashedPassword;
  final UserType accountType;
  final bool isEnrolled;
  final int cautionDepositAmount;
  final String name;
  final DateTime yearOfAdmission;
  final DateTime yearOfCompletion;
  final Branch branch;
  final DateTime dob;
  final String phoneNumber;
  final String email;
  final bool isVeg;

  User(
      {@required this.userId,
      @required this.username,
      @required this.hashedPassword,
      @required this.accountType,
      @required this.isEnrolled,
      @required this.cautionDepositAmount,
      @required this.name,
      @required this.yearOfAdmission,
      @required this.yearOfCompletion,
      @required this.branch,
      @required this.dob,
      @required this.phoneNumber,
      @required this.email,
      @required this.isVeg});

  factory User.fromDocument(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return User(
        userId: documentSnapshot.id,
        username: documentData['username'],
        hashedPassword: documentData['hashedPassword'],
        accountType: UserTypeExtensions.fromString(documentData['type']),
        isEnrolled: documentData['isEnrolled'],
        cautionDepositAmount: documentData['cautionDepositAmount'] ?? 0,
        name: documentData['details']['name'],
        yearOfAdmission:
            getDateTimeOrNull(documentData['details']['yearOfAdmission']),
        yearOfCompletion:
            getDateTimeOrNull(documentData['details']['yearOfCompletion']),
        branch: BranchExtensions.fromString(documentData['details']['branch']),
        dob: getDateTimeOrNull(documentData['details']['dob']),
        phoneNumber: documentData['details']['phone'],
        email: documentData['details']['email'],
        isVeg: documentData['details']['isVeg']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'type': this.accountType.toStringValue(),
      'isEnrolled': this.isEnrolled,
      'hashedPassword': this.hashedPassword,
      'cautionDepositAmount': this.cautionDepositAmount,
      'details': {
        'name': this.name,
        'yearOfAdmission': Timestamp.fromDate(this.yearOfAdmission),
        'yearOfCompletion': Timestamp.fromDate(this.yearOfCompletion),
        'branch': this.branch.toStringValue(),
        'dob': Timestamp.fromDate(this.dob),
        'email': this.email,
        'isVeg': this.isVeg,
        'phone': this.phoneNumber
      }
    };
  }

  @override
  List<Object> get props => [
        this.userId,
        this.username,
        this.hashedPassword,
        this.accountType,
        this.isEnrolled,
        this.cautionDepositAmount,
        this.name,
        this.yearOfAdmission,
        this.yearOfCompletion,
        this.branch,
        this.dob,
        this.phoneNumber,
        this.email,
        this.isVeg
      ];
}
  
```  
# common\router\app_router.dart  
```dart
import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/auth/data/auth_repository.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_bloc.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_chooser.dart';
import 'package:DigiMess/modules/auth/login/ui/screens/login_screen.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_bloc.dart';
import 'package:DigiMess/modules/auth/register/ui/screens/register_screen.dart';
import 'package:DigiMess/modules/auth/ui/screens/auth_screen.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:DigiMess/modules/splash/ui/screens/splash_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/screens/main_screen.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/data/staff_edit_repository.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/ui/screens/staff_menu_edit.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/util/staff_menu_edit_arguments.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/data/notices_repository.dart';
import 'package:DigiMess/modules/staff/notices/ui/screens/add_notice_screen.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/data/complaints_repository.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/ui/screens/complaints_history.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_bloc.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/data/staff_leaves_repository.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/screens/leave_history_screen.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/data/payments_repository.dart';
import 'package:DigiMess/modules/staff/students/payment_history/ui/screens/payment_history_screen.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_bloc.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/data/student_details_repository.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/screens/student_details_screen.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/data/annual_poll_repository.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/screens/annual_poll_screen.dart';
import 'package:DigiMess/modules/student/main/ui/screens/main_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/card_details_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/dummy_payments_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/otp_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/payment_fail_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/ui/screens/payment_success_screen.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  AppRouter._();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (context) =>
                    SplashBloc(SplashIdle(), SplashRepository()),
                child: SplashScreen()));
      case Routes.AUTH_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: AuthScreen());
      case Routes.LOGIN_CHOOSER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: LoginChooser());
      case Routes.LOGIN_SCREEN:
        final UserType userType = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => LoginBloc(
                    AuthenticationRepository(FirebaseClient.getUsersCollectionReference(), FirebaseClient.getPaymentsCollectionReference())),
                child: LoginScreen(userType: userType)));
      case Routes.REGISTER_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => RegisterBloc(
                    AuthenticationRepository(FirebaseClient.getUsersCollectionReference(), FirebaseClient.getPaymentsCollectionReference())),
            child: RegisterScreen()));
      case Routes.MAIN_SCREEN_STUDENT:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(create: (_) => DMBloc(DMIdleState()), child: StudentMainScreen()));
      case Routes.DUMMY_PAYMENT_SCREEN:
        final DummyPaymentArguments args = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: DummyPaymentsScreen(
              message: args.message,
              paymentAmount: args.paymentAmount,
              paymentSuccessCallback: args.paymentSuccessCallback,
            ));
      case Routes.PAYMENT_CARD_DETAILS_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: CardDetailsScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_OTP_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: OtpScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_SUCCESS_SCREEN:
        final VoidCallback paymentSuccessCallback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: PaymentSuccessScreen(
              paymentSuccessCallback: paymentSuccessCallback,
            ));
      case Routes.PAYMENT_FAILED_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: PaymentFailScreen());
      case Routes.ANNUAL_POLL_SCREEN:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            settings: settings,
            child: BlocProvider(
                create: (_) => StudentAnnualPollBloc(StudentAnnualPollIdle(),
                    StudentAnnualPollRepository(FirebaseClient.getMenuCollectionReference())),
                child: StudentAnnualPollScreen(onVoteCallback: settings.arguments)));
      case Routes.MAIN_SCREEN_STAFF:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(create: (_) => DMBloc(DMIdleState()), child: StaffMainScreen()));
      case Routes.STUDENT_DETAILS_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StudentDetailsBloc(StudentDetailsIdle(),
                    StudentDetailsRepository(FirebaseClient.getUsersCollectionReference())),
                child: StudentDetailsScreen(user: user)));
      case Routes.STUDENT_PAYMENT_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffPaymentsBloc(StaffPaymentsIdle(),
                    StaffPaymentsRepository(FirebaseClient.getPaymentsCollectionReference())),
                child: StaffPaymentHistoryScreen(user: user)));
      case Routes.STUDENT_COMPLAINT_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffComplaintsBloc(StaffComplaintsIdle(),
                    StaffComplaintsRepository(FirebaseClient.getComplaintsCollectionReference())),
                child: StaffComplaintsHistoryScreen(user: user)));
      case Routes.STUDENT_LEAVES_HISTORY_SCREEN:
        final User user = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffStudentLeavesBloc(StaffLeavesIdle(),
                    StaffStudentLeavesRepository(FirebaseClient.getAbsenteesCollectionReference())),
                child: StaffStudentLeavesHistoryScreen(user: user)));
      case Routes.STAFF_ADD_NOTICE_SCREEN:
        final VoidCallback callback = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffNoticesBloc(NoticesIdle(),
                    StaffNoticesRepository(FirebaseClient.getNoticesCollectionReference())),
                child: StaffAddNoticeScreen(callback: callback)));
      case Routes.STAFF_MENU_EDIT_SCREEN:
        final StaffMenuEditArguments args = settings.arguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: BlocProvider(
                create: (_) => StaffMenuEditBloc(StaffMenuEditIdle(),
                    StaffMenuEditRepository(FirebaseClient.getMenuCollectionReference())),
                child: StaffMenuEditScreen(item: args.item, onSuccess: args.onSuccess)));
      default:
        return null;
    }
  }
}
  
```  
# common\router\routes.dart  
```dart
class Routes {
  Routes._();

  static const String SPLASH_SCREEN = "/";
  static const String AUTH_SCREEN = "/auth";
  static const String LOGIN_CHOOSER_SCREEN = "/login_chooser";
  static const String LOGIN_SCREEN = "/login";
  static const String REGISTER_SCREEN = "/register";
  static const String MAIN_SCREEN_STUDENT = "/student";
  static const String MAIN_SCREEN_STAFF = "/staff";
  static const String DUMMY_PAYMENT_SCREEN = "/payment";
  static const String PAYMENT_CARD_DETAILS_SCREEN = "/card_details";
  static const String PAYMENT_OTP_SCREEN = "/otp";
  static const String PAYMENT_SUCCESS_SCREEN = "/payment_success";
  static const String PAYMENT_FAILED_SCREEN = "/payment_failed";
  static const String ANNUAL_POLL_SCREEN = "/annual_poll";
  static const String STUDENT_DETAILS_SCREEN = "/student_details";
  static const String STUDENT_PAYMENT_HISTORY_SCREEN = "/student_payment_history";
  static const String STUDENT_COMPLAINT_HISTORY_SCREEN = "/student_complaint_history";
  static const String STUDENT_LEAVES_HISTORY_SCREEN = "/student_leaves_history";
  static const String STAFF_ADD_NOTICE_SCREEN = "/staff_add_notice";
  static const String STAFF_MENU_EDIT_SCREEN = "/staff_menu_edit_screen";
}
  
```  
# common\shared_prefs\shared_pref_keys.dart  
```dart
class SharedPrefKeys {
  SharedPrefKeys._();

  static const USER_TYPE = "userType";
  static const USER_ID = "userId";
  static const USERNAME = "username";
  static const LAST_POLL_TAKEN_YEAR = "lastPollYear";
}
  
```  
# common\shared_prefs\shared_pref_repository.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_keys.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepository {
  SharedPrefRepository._();

  static Future<UserType> getUserType() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String userType = sharedPrefs.getString(SharedPrefKeys.USER_TYPE);
    return UserTypeExtensions.fromString(userType);
  }

  static Future<void> setUserType(UserType userType) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.USER_TYPE, userType.toStringValue());
  }

  static Future<String> getTheUserId() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USER_ID);
  }

  static Future<void> setTheUserId(String userId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USER_ID, userId);
  }

  static Future<void> setUsername(String username) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USERNAME, username);
  }

  static Future<String> getUsername() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USERNAME);
  }

  static Future<AppStatus> getAppClientStatus() async {
    final UserType userType = await getUserType();
    final String userId = await getTheUserId();
    final String username = await getUsername();
    return AppStatus(userType: userType, userId: userId, username: username);
  }

  static Future<void> logOutUser() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
  }

  static Future<void> setLastPollYear(DateTime date) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.LAST_POLL_TAKEN_YEAR, date.toIso8601String());
  }

  static Future<DateTime> getLastPollYear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    // set epoch as default
    final DateTime defaultDate = DateTime.fromMillisecondsSinceEpoch(0);
    final String lastVotedDate =
        sharedPrefs.getString(SharedPrefKeys.LAST_POLL_TAKEN_YEAR);
    if (lastVotedDate == null || lastVotedDate.trim().isEmpty)
      return defaultDate;
    else {
      final DateTime dateTime = DateTime.tryParse(lastVotedDate);
      if (dateTime == null)
        return defaultDate;
      else
        return dateTime;
    }
  }
}
  
```  
# common\util\app_status.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppStatus extends Equatable {
  final UserType userType;
  final String userId;
  final bool isEnabledInFirebase;
  final String username;

  AppStatus(
      {@required this.userType,
      @required this.userId,
      @required this.isEnabledInFirebase,
      @required this.username});

  @override
  List<Object> get props =>
      [this.userType, this.userId, this.isEnabledInFirebase, this.username];

  AppStatus copyWith({userType, userId, isEnabledInFirebase, username}) {
    return AppStatus(
        isEnabledInFirebase: isEnabledInFirebase ?? this.isEnabledInFirebase,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        userType: userType ?? this.userType);
  }
}
  
```  
# common\util\error_wrapper.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DMError extends Equatable {
  final String message;
  final throwable;

  DMError({@required this.message, this.throwable});

  @override
  List<Object> get props => [this.message, this.throwable];
}
  
```  
# common\util\payment_status.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentStatus extends Equatable {
  final bool hasPaidFees;
  final DateTime lastPaymentDate;

  PaymentStatus({@required this.hasPaidFees, @required this.lastPaymentDate});

  @override
  List<Object> get props => [this.hasPaidFees, this.lastPaymentDate];
}
  
```  
# common\util\task_state.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DMTaskState extends Equatable {
  final bool isTaskSuccess;
  final dynamic taskResultData;
  final DMError error;

  DMTaskState(
      {@required this.isTaskSuccess,
      @required this.taskResultData,
      @required this.error});

  @override
  List<Object> get props =>
      [this.isTaskSuccess, this.taskResultData, this.error];
}
  
```  
# common\widgets\dm_buttons.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMPillButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const DMPillButton(
      {Key key,
      this.text,
      this.onPressed,
      this.textStyle = DMTypo.bold24WhiteTextStyle,
      this.padding,
      this.isEnabled = true,
      this.onDisabledPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (isEnabled ? onPressed : onDisabledPressed) ?? () {},
      child: Text(text, style: textStyle, textAlign: TextAlign.center),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(isEnabled ? DMColors.darkBlue : DMColors.grey),
          overlayColor: MaterialStateProperty.all(
              isEnabled ? DMColors.accentBlue.withOpacity(0.3) : DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )),
    );
  }
}

class DMPillOutlinedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const DMPillOutlinedButton(
      {Key key,
      this.text,
      this.onPressed,
      this.textStyle = DMTypo.bold24DarkBlueTextStyle,
      this.padding,
      this.isEnabled = true,
      this.onDisabledPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (isEnabled ? onPressed : onDisabledPressed) ?? () {},
      child: Text(text, style: textStyle, textAlign: TextAlign.center),
      style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: isEnabled ? DMColors.darkBlue : DMColors.grey)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(
              isEnabled ? DMColors.accentBlue.withOpacity(0.3) : DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )),
    );
  }
}

class DMRoundedPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final int elevation;

  const DMRoundedPrimaryButton(
      {Key key, this.onPressed, this.text, this.textStyle, this.padding, this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(DMColors.primaryBlue),
          foregroundColor: MaterialStateProperty.all(DMColors.white),
          elevation: MaterialStateProperty.all(elevation ?? 4),
          overlayColor: MaterialStateProperty.all(DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(
              padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child:
          Text(text, style: textStyle ?? DMTypo.bold16WhiteTextStyle, textAlign: TextAlign.center),
    );
  }
}

class DMRoundedWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final int elevation;

  const DMRoundedWhiteButton(
      {Key key, this.onPressed, this.text, this.textStyle, this.padding, this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(DMColors.white),
          foregroundColor: MaterialStateProperty.all(DMColors.black),
          elevation: MaterialStateProperty.all(elevation ?? 4),
          padding: MaterialStateProperty.all(
              padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child:
          Text(text, style: textStyle ?? DMTypo.bold16BlackTextStyle, textAlign: TextAlign.center),
    );
  }
}
  
```  
# common\widgets\dm_date_picker.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';

class DMDatePicker {
  DMDatePicker._();

  static Future<DateTime> showPicker(BuildContext context,
      {DateTime initialDate, DateTime firstDate, DateTime lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.fromMicrosecondsSinceEpoch(0),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 60)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: DMColors.primaryBlue,
              onPrimary: DMColors.white,
              surface: DMColors.primaryBlue,
              onSurface: DMColors.black,
            ),
            dialogBackgroundColor: DMColors.white,
          ),
          child: child,
        );
      },
    );
  }
}
  
```  
# common\widgets\dm_dialogs.dart  
```dart
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DMAlertDialog {
  DMAlertDialog._();

  static Future<bool> show(BuildContext context, String title, {String description}) async {
    return await showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20).copyWith(bottom: 0),
                          child: Text(title,
                              style: DMTypo.bold16BlackTextStyle, textAlign: TextAlign.center),
                        ),
                        description != null
                            ? Container(
                                margin: EdgeInsets.all(40).copyWith(bottom: 0),
                                child: Text(description,
                                    style: DMTypo.bold16MutedTextStyle,
                                    textAlign: TextAlign.center),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Divider(color: DMColors.primaryBlue, thickness: 1, height: 1),
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                                      ),
                                      onTap: () => Navigator.pop(context, true),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("Yes",
                                                  style: DMTypo.bold16PrimaryBlueTextStyle))))),
                              Container(width: 1, color: DMColors.primaryBlue, height: 60),
                              Expanded(
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.only(bottomRight: Radius.circular(10)),
                                      ),
                                      onTap: () => Navigator.pop(context, false),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text("No",
                                                  style: DMTypo.bold16PrimaryBlueTextStyle)))))
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            }) ??
        false;
  }
}

class DMAboutDialog {
  DMAboutDialog._();

  static _launchURL() async {
    const url = DMDetails.githubLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  static show(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: DMTypo.bold24BlackTextStyle),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(DMDetails.description, style: DMTypo.bold18BlackTextStyle),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showLicensePage(
                                context: context,
                                applicationName: DMDetails.appName,
                                applicationVersion: DMDetails.appVersion);
                          },
                          child: Text("Licenses", style: DMTypo.bold18PrimaryBlueTextStyle),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text("Ok", style: DMTypo.bold18PrimaryBlueTextStyle)),
                      ),
                      InkWell(
                        onTap: () => _launchURL(),
                        child: Text("View github", style: DMTypo.bold18PrimaryBlueTextStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
  
```  
# common\widgets\dm_filter_menu.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMFilterMenu extends StatefulWidget {
  final Icon icon;
  final List<MapEntry<int, String>> listOfValuesAndItems;
  final int selectedValue;
  final Function(int) onChanged;

  const DMFilterMenu(
      {Key key,
      this.icon,
      this.listOfValuesAndItems,
      this.selectedValue,
      this.onChanged})
      : assert(icon != null),
        assert(listOfValuesAndItems != null),
        assert(selectedValue != null),
        assert(onChanged != null),
        super(key: key);

  @override
  _DMFilterMenuState createState() => _DMFilterMenuState();
}

class _DMFilterMenuState extends State<DMFilterMenu> {
  GlobalKey _key = LabeledGlobalKey("filterButton");
  OverlayEntry _overlayEntry;
  Size buttonSize;
  Offset buttonPosition;
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: IconButton(
          icon: widget.icon, color: DMColors.white, onPressed: showDropDown),
    );
  }

  void showDropDown() {
    if (isMenuOpen) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  Widget getMenu() {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            List<Widget>.generate(widget.listOfValuesAndItems.length, (index) {
          return InkWell(
            onTap: () {
              closeMenu();
              widget.onChanged(widget.listOfValuesAndItems[index].key);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 15),
                      child: widget.listOfValuesAndItems[index].key ==
                              widget.selectedValue
                          ? Icon(
                              Icons.circle,
                              color: DMColors.primaryBlue,
                              size: 20,
                            )
                          : Icon(
                              Icons.panorama_fish_eye,
                              color: DMColors.grey,
                              size: 20,
                            )),
                  Expanded(
                    child: Text(widget.listOfValuesAndItems[index].value,
                        style: widget.listOfValuesAndItems[index].key ==
                                widget.selectedValue
                            ? DMTypo.bold14PrimaryBlueTextStyle
                            : DMTypo.bold14BlackTextStyle),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: closeMenu,
              child: Stack(
                children: [
                  Positioned(
                    top: buttonPosition.dy + buttonSize.height + 10,
                    left: buttonPosition.dx + buttonSize.width - 200,
                    child:
                        Material(color: Colors.transparent, child: getMenu()),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }
}
  
```  
# common\widgets\dm_scaffold.dart  
```dart
import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/bloc/dm_states.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/no_network_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class DMScaffold extends StatefulWidget {
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
  _DMScaffoldState createState() => _DMScaffoldState();
}

class _DMScaffoldState extends State<DMScaffold> {
  DMBloc _dmBloc;

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
        body: SafeArea(
            child: BlocConsumer<DMBloc, DMStates>(listener: (context, state) {
          if (state is NetworkConnectedState) {
            _dmBloc.add(CheckDMStatus());
          } else if (state is DMErrorState) {
            DMSnackBar.show(context, state.errorMessage);
          }
        }, builder: (context, state) {
          _dmBloc = BlocProvider.of<DMBloc>(context);
          if (state is UserLoggedOut) {
            Future.microtask(() => Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.AUTH_SCREEN, (route) => false));
            return KeyboardAvoider(child: Container());
          } else if (state is DMIdleState) {
            _dmBloc.add(InitNetworkStateListener());
            return KeyboardAvoider(child: Container());
          } else if (state is NoNetworkState) {
            return KeyboardAvoider(child: NoNetworkScreen());
          } else if (state is NetworkConnectedState) {
            return KeyboardAvoider(child: Container());
          } else {
            // for UserLoggedOut, UserLoggedIn, DMErrorState.
            return KeyboardAvoider(child: widget.body);
          }
        })));
  }
}
  
```  
# common\widgets\dm_snackbar.dart  
```dart
import 'package:flutter/material.dart';

class DMSnackBar {
  DMSnackBar._();

  static void show(BuildContext context, String message,
      {SnackBarAction action}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
    return;
  }
}
  
```  
# common\widgets\help_widget.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpWidget extends StatefulWidget {
  final String question;
  final String answer;

  const HelpWidget({Key key, this.question, this.answer}) : super(key: key);

  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(widget.question, style: DMTypo.bold16BlackTextStyle)),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: SvgPicture.asset(
                    isVisible ? "assets/icons/dropdownblue.svg" : "assets/icons/dropdown.svg",
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              widget.answer,
              style: DMTypo.bold14MutedTextStyle,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20),
            child: Divider(color: DMColors.accentBlue)),
      ],
    );
  }
}
  
```  
# common\widgets\internet_check_scaffold.dart  
```dart
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
  
```  
# common\widgets\nav_item.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavItem extends StatelessWidget {
  final String text;
  final String iconAsset;
  final bool isItemSelected;
  final VoidCallback onClick;

  const NavItem(
      {Key key, this.text, this.iconAsset, this.isItemSelected, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onClick ?? () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 15),
                child: SvgPicture.asset(iconAsset,
                    width: 24,
                    color: isItemSelected ? DMColors.darkBlue : DMColors.black),
              ),
              Text(text,
                  style: isItemSelected
                      ? DMTypo.bold14DarkBlueTextStyle
                      : DMTypo.bold14BlackTextStyle)
            ],
          ),
        ),
      ),
    );
  }
}
  
```  
# common\widgets\no_network_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoNetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset("assets/icons/no_internet_icon.svg")),
        Text("Uh-oh!", style: DMTypo.bold30BlackTextStyle),
        Container(
          margin: EdgeInsets.all(10),
          child: Text("Please check your internet connection",
              style: DMTypo.bold16BlackTextStyle),
        ),
      ],
    ));
  }
}
  
```  
# main.dart  
```dart
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
  
```  
# modules\auth\data\auth_repository.dart  
```dart
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/crypto/password_hasher.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/util/userDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository {
  final CollectionReference _userCredentialClient;
  final CollectionReference _paymentCredentialClient;

  AuthenticationRepository(this._userCredentialClient, this._paymentCredentialClient);

  Future<DMTaskState> login(String username, String password, UserType userType) async {
    try {
      return await _userCredentialClient
          .where('type', isEqualTo: userType.toStringValue())
          .where('username', isEqualTo: username.trim())
          .limit(1)
          .get()
          .then((value) async {
        final userData = value.docs;
        final List<User> userList = userData.map((e) => User.fromDocument(e)).toList();
        print(userList);
        if (userList == null || userList.isEmpty) {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "User with $username does not exist"));
        } else if (PasswordHashManager.verifyPassword(hashedPasswordFromServer: userList.first.hashedPassword, unHashedPassword: password)) {
          if (userList.first.isEnrolled) {
            await SharedPrefRepository.setUserType(userList.first.accountType);
            await SharedPrefRepository.setUsername(username.trim());
            await SharedPrefRepository.setTheUserId(userList.first.userId);
            return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
          } else {
            return DMTaskState(
                isTaskSuccess: false,
                taskResultData: null,
                error: DMError(message: "Your account has been disabled by the admin ☹...Please contact mess coordinator"));
          }
        } else {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "Incorrect password for $username"));
        }
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> register(UserDetails userCredentials) async {
    try {
      final String hashedPassword = PasswordHashManager.hashPassword(userCredentials.unhashedPassword);
      return await _userCredentialClient
          .add(User(
                  username: userCredentials.username,
                  hashedPassword: hashedPassword,
                  accountType: userCredentials.accountType,
                  isEnrolled: userCredentials.isEnrolled,
                  cautionDepositAmount: userCredentials.cautionDepositAmount,
                  name: userCredentials.name,
                  yearOfAdmission: userCredentials.yearOfAdmission,
                  yearOfCompletion: userCredentials.yearOfCompletion,
                  branch: userCredentials.branch,
                  dob: userCredentials.dob,
                  phoneNumber: userCredentials.phoneNumber,
                  email: userCredentials.email,
                  isVeg: userCredentials.isVeg)
              .toMap())
          .then((userRef) async {
        final Payment paymentWithUserRef = Payment(
            description: "Caution Deposit",
            user: userRef,
            paymentDate: DateTime.now(),
            paymentId: "",
            paymentAccountType: PaymentAccountType.CARD,
            paymentAmount: DMDetails.constantMessCaution);
        return await _paymentCredentialClient.add(paymentWithUserRef.toMap()).then((value) async {
          await SharedPrefRepository.setUserType(UserType.STUDENT);
          await SharedPrefRepository.setUsername(userCredentials.username.trim());
          await SharedPrefRepository.setTheUserId(userRef.id);
          return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
        }).onError((error, stackTrace) {
          print(stackTrace.toString());
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
        });
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> usernameAvailableCheck(username) async {
    try {
      return await _userCredentialClient
          .where('type', isEqualTo: UserType.STUDENT.toStringValue())
          .where('username', isEqualTo: username.trim())
          .get()
          .then((value) async {
        final userData = value.docs;
        if (userData == null || userData.isEmpty) {
          return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
        } else {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "User with $username already exist"));
        }
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\auth\data\util\userDetails.dart  
```dart
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserDetails extends Equatable {
  final String username;
  final String unhashedPassword;
  final UserType accountType;
  final bool isEnrolled;
  final int cautionDepositAmount;
  final String name;
  final DateTime yearOfAdmission;
  final DateTime yearOfCompletion;
  final Branch branch;
  final DateTime dob;
  final String phoneNumber;
  final String email;
  final bool isVeg;

  UserDetails(
      {
      @required this.username,
      @required this.unhashedPassword,
      @required this.accountType,
      @required this.isEnrolled,
      @required this.cautionDepositAmount,
      @required this.name,
      @required this.yearOfAdmission,
      @required this.yearOfCompletion,
      @required this.branch,
      @required this.dob,
      @required this.phoneNumber,
      @required this.email,
      @required this.isVeg});

  @override
  List<Object> get props => [
        this.username,
        this.unhashedPassword,
        this.accountType,
        this.isEnrolled,
        this.cautionDepositAmount,
        this.name,
        this.yearOfAdmission,
        this.yearOfCompletion,
        this.branch,
        this.dob,
        this.phoneNumber,
        this.email,
        this.isVeg
      ];
}
  
```  
# modules\auth\login\bloc\login_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/auth_repository.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_events.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final AuthenticationRepository _authRepository;

  LoginBloc(this._authRepository)
      : super(LoginIdle());

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async*{
    yield LoginLoading();
    if (event is LoginButtonClick) {
      final DMTaskState result = await _authRepository.login(event.username, event.password, event.userType);
      if (result.isTaskSuccess) {
        yield LoginSuccess();
      } else {
        yield LoginError(result.error);
      }
    }
  }
}
  
```  
# modules\auth\login\bloc\login_events.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvents extends Equatable {
  const LoginEvents();
}

class LoginButtonClick extends LoginEvents {
  final String username;
  final String password;
  final UserType userType;
  LoginButtonClick({this.userType, this.username, this.password});

  @override
  List<Object> get props => [username, password, userType];
}
  
```  
# modules\auth\login\bloc\login_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
}

class LoginSuccess extends LoginStates {
  @override
  List<Object> get props => [];

}
class LoginLoading extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginIdle extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginStates {
  final DMError error;

  LoginError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\auth\login\ui\screens\login_chooser.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';

class LoginChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              child: Text('SIGN IN AS', style: DMTypo.bold24BlackTextStyle),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60,
              child: Hero(
                tag: 'signIn-Student',
                child: DMPillButton(
                  text: "Student",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN,
                        arguments: UserType.STUDENT);
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60,
              margin: EdgeInsets.all(20),
              child: Hero(
                tag: 'signUp-Staff',
                child: DMPillButton(
                  text: "Staff",
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.LOGIN_SCREEN,
                        arguments: UserType.STAFF);
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
  
```  
# modules\auth\login\ui\screens\login_screen.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_bloc.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_events.dart';
import 'package:DigiMess/modules/auth/login/bloc/login_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  final UserType userType;

  const LoginScreen({this.userType});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  LoginBloc _bloc;
  String _password;
  bool _obscureText = true;
  bool _isLoading = false;

  TextEditingController _passController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<LoginBloc, LoginStates>(listener: (context, state) async {
          final isLoad = state is LoginLoading;
          if (isLoad) {
            setState(() {
              _isLoading = isLoad;
            });
          } else {
            await Future.delayed(Duration(milliseconds: 200), () {
              setState(() {
                _isLoading = isLoad;
              });
            });
          }

          if (state is LoginError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is LoginSuccess) {
            if (widget.userType == UserType.STUDENT) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.MAIN_SCREEN_STUDENT, (route) => false);
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.MAIN_SCREEN_STAFF, (route) => false);
            }
          }
        }, builder: (context, state) {
          _bloc = BlocProvider.of<LoginBloc>(context);
          return _loginForm();
        }),
      ),
    ));
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10).copyWith(top: 0),
            child: Text('SIGN IN', style: DMTypo.bold24BlackTextStyle)),
        Form(
          key: _formKey,
          child: Column(children: [
            _usernameField(),
            _passwordField(),
            _signInButton(),
            _signUpFromSignIn(),
          ]),
        )
      ],
    );
  }

  Widget _usernameField() {
    return Container(
      margin: const EdgeInsets.all(20).copyWith(bottom: 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _usernameController,
        decoration: InputDecoration(
          hintText: 'Username',
          fillColor: DMColors.textFieldMutedBg,
          filled: true,
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 20, right: 10),
            child: SvgPicture.asset("assets/icons/username_icon.svg"),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 54),
          hintStyle: DMTypo.bold18MutedBlueTextStyle,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: DMColors.mutedBlue)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: DMColors.mutedBlue)),
        ),
        maxLines: 1,
        validator: (value) {
          if (value.length < 8) {
            return 'Invalid username';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _passController,
          decoration: InputDecoration(
            hintText: 'Password',
            fillColor: DMColors.textFieldMutedBg,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: DMColors.mutedBlue)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: DMColors.mutedBlue)),
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 20, right: 10),
              child: SvgPicture.asset("assets/icons/password_icon.svg"),
            ),
            prefixIconConstraints: BoxConstraints(maxWidth: 54),
            hintStyle: DMTypo.bold18MutedBlueTextStyle,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: _togglePasswordStatus,
              color: DMColors.mutedBlue,
            ),
          ),
          maxLines: 1,
          validator: (value) {
            if (value.length < 8) {
              return 'A password is min 8 characters';
            } else {
              return null;
            }
          },
          obscureText: _obscureText),
    );
  }

  Widget _signInButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Hero(
        tag: 'signUp-Staff',
        child: DMPillButton(
          text: "Sign In",
          onPressed: () {
            if (_formKey.currentState.validate()) {
              final username = _usernameController.text;
              final password = _passController.text;
              _bloc.add(LoginButtonClick(
                  username: username, password: password, userType: widget.userType));
            }
          },
        ),
      ),
    );
  }

  Widget _signUpFromSignIn() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            "Don't have an account?",
            style: DMTypo.bold24BlackTextStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Click here to",
                  style: DMTypo.bold18BlackTextStyle,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.REGISTER_SCREEN);
                  },
                  child: Text(
                    " sign up",
                    style: DMTypo.bold18AccentBlueTextStyle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
  
```  
# modules\auth\register\bloc\register_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/auth_repository.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_events.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterStates> {
  final AuthenticationRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterIdle());

  @override
  Stream<RegisterStates> mapEventToState(RegisterEvents event) async* {
    yield RegisterLoading();
    if (event is AvailableUserCheck) {
      final DMTaskState result = await _authRepository.usernameAvailableCheck(event.username);
      if (result.isTaskSuccess) {
        yield UserNameAvailableSuccess();
      } else {
        yield RegisterError(result.error);
      }
    } else if (event is RegisterUser) {
      final DMTaskState result = await _authRepository.register(event.userCredentials);
      if (result.isTaskSuccess) {
        yield RegisterSuccess();
      } else {
        yield RegisterError(result.error);
      }
    }
  }
}
  
```  
# modules\auth\register\bloc\register_events.dart  
```dart
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/modules/auth/data/util/userDetails.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvents extends Equatable {
  const RegisterEvents();
}

class RegisterUser extends RegisterEvents {
  final UserDetails userCredentials;

  RegisterUser(this.userCredentials);


  @override
  List<Object> get props => [userCredentials];
}

class AvailableUserCheck extends RegisterEvents{
  final String username;
  AvailableUserCheck(this.username);

  @override
  List<Object> get props => [username];
}  
```  
# modules\auth\register\bloc\register_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterStates extends Equatable {
  const RegisterStates();
}

class UserNameAvailableSuccess extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterLoading extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterIdle extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterError extends RegisterStates {
  final DMError error;

  RegisterError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\auth\register\ui\screens\register_screen.dart  
```dart
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/auth/data/util/userDetails.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_bloc.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_events.dart';
import 'package:DigiMess/modules/auth/register/bloc/register_states.dart';
import 'package:DigiMess/modules/auth/register/ui/widgets/date_picker_form_field.dart';
import 'package:DigiMess/modules/auth/register/ui/widgets/sign_up_text_form_field.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  RegisterBloc _bloc;
  TextStyle textTypo;
  bool _isLoading = false;
  Branch _studentBranch;
  Branch _studentBranchSelected;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _admissionController = TextEditingController();
  DateTime _dateOfBirth;
  DateTime _yearOfAdmission;
  DateTime _yearOfCompletion;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  bool isVeg;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<RegisterBloc, RegisterStates>(listener: (context, state) async {
          setState(() {
            _isLoading = state is RegisterLoading;
          });
          if (state is RegisterError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is RegisterSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(Routes.MAIN_SCREEN_STUDENT, (route) => false);
          } else if (state is UserNameAvailableSuccess) {
            Navigator.pushNamed(context, Routes.DUMMY_PAYMENT_SCREEN,
                arguments: DummyPaymentArguments("Caution deposit", DMDetails.constantMessCaution, () async {
                  _bloc.add(RegisterUser(UserDetails(
                      name: _nameController.text,
                      username: _admissionController.text,
                      dob: _dateOfBirth,
                      yearOfAdmission: _yearOfAdmission,
                      yearOfCompletion: _yearOfAdmission,
                      phoneNumber: _phoneNumberController.text,
                      email: _emailController.text,
                      unhashedPassword: _passController.text,
                      accountType: UserType.STUDENT,
                      branch: _studentBranch,
                      cautionDepositAmount: DMDetails.constantMessCaution,
                      isVeg: isVeg,
                      isEnrolled: true)));
                }));
          }
        }, builder: (context, state) {
          _bloc = BlocProvider.of<RegisterBloc>(context);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 50), child: Text('SIGN UP', style: DMTypo.bold24BlackTextStyle)),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      SignUpTextFormField(controller: _nameController, labelText: 'Name'),
                      SignUpTextFormField(
                        controller: _admissionController,
                        labelText: 'Admission Number',
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        validator: (value) {
                          if (value.isEmpty || value.length != 8)
                            return 'Enter a valid admission number';
                          else
                            return null;
                        },
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
                          child: DropdownButtonFormField(
                              value: _studentBranch,
                              items: Branch.values.map((e) {
                                return DropdownMenuItem(
                                  child: Text(
                                    e.toStringValue(),
                                    style: _studentBranch == e ? DMTypo.bold16PrimaryBlueTextStyle : DMTypo.bold16BlackTextStyle,
                                  ),
                                  value: e,
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                  labelText: "Branch",
                                  errorStyle: DMTypo.bold12RedTextStyle,
                                  enabled: false,
                                  labelStyle: DMTypo.bold14BlackTextStyle,
                                  alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: DMColors.primaryBlue)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: DMColors.primaryBlue)),
                                  errorBorder:
                                      OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: DMColors.red)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: DMColors.primaryBlue))),
                              validator: (_studentBranch) {
                                if (_studentBranch == null) {
                                  return "Choose your branch";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _studentBranch = value;
                                });
                                // hasValue = true;
                                // textColor = DMColors.lightBlue;
                              })),
                      DatePickerFormField(
                          labelText: 'Date of Birth',
                          hint: "Choose date",
                          showError: showError,
                          validator: (date) {
                            if (date != null && date.difference(DateTime.now()).inDays.abs() > 365 * 17) {
                              return null;
                            } else {
                              return "Must be 17 or older to enter";
                            }
                          },
                          onChanged: (date) {
                            setState(() {
                              _dateOfBirth = date;
                            });
                          },
                          initialDateTime: _dateOfBirth),
                      DatePickerFormField(
                          labelText: 'Date of Admission',
                          hint: "Choose date",
                          showError: showError,
                          validator: (date) {
                            if (date != null && date.isBefore(DateTime.now())) {
                              return null;
                            } else {
                              return "Please register after admission";
                            }
                          },
                          onChanged: (date) {
                            setState(() {
                              _yearOfAdmission = date;
                            });
                          },
                          initialDateTime: _yearOfAdmission),
                      DatePickerFormField(
                          labelText: 'Date of Completion',
                          hint: "Choose date",
                          showError: showError,
                          validator: (date) {
                            if (date != null && date.isAfter(DateTime.now())) {
                              return null;
                            } else {
                              return "Can't register after passing out";
                            }
                          },
                          onChanged: (date) {
                            setState(() {
                              _yearOfCompletion = date;
                            });
                          },
                          initialDateTime: _yearOfCompletion),
                      SignUpTextFormField(
                        controller: _phoneNumberController,
                        labelText: 'Mobile Number',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (!value.isPhoneNumber())
                            return 'Enter a valid mobile number';
                          else
                            return null;
                        },
                      ),
                      SignUpTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (!value.isEmail())
                            return 'Enter a valid email address';
                          else
                            return null;
                        },
                      ),
                      SignUpTextFormField(
                          controller: _passController,
                          labelText: 'Password',
                          validator: (value) {
                            if (value.length < 8) {
                              return "Password must be atleast 8 characters long";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true),
                      SignUpTextFormField(
                        controller: _confirmPassController,
                        labelText: 'Confirm Password',
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please re-enter new password";
                          } else if (value != _passController.text) {
                            return "Password must be same as above";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choice',
                              style: DMTypo.bold16BlackTextStyle,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    isVeg = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    isVeg == true
                                        ? Icon(Icons.circle, color: DMColors.primaryBlue)
                                        : Icon(Icons.panorama_fish_eye, color: DMColors.grey),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: Text('Veg', style: isVeg == true ? DMTypo.bold16PrimaryBlueTextStyle : DMTypo.bold16MutedTextStyle))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    isVeg = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    isVeg == false
                                        ? Icon(Icons.circle, color: DMColors.primaryBlue)
                                        : Icon(Icons.panorama_fish_eye, color: DMColors.grey),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child:
                                            Text('Non Veg', style: isVeg == false ? DMTypo.bold16PrimaryBlueTextStyle : DMTypo.bold16MutedTextStyle))
                                  ],
                                ),
                              ),
                            ),
                            (isVeg == null && showError)
                                ? Container(margin: EdgeInsets.only(top: 10), child: Text("Choose a food category", style: DMTypo.bold14RedTextStyle))
                                : Container()
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 60,
                        margin: const EdgeInsets.all(20).copyWith(top: 40),
                        child: Hero(
                          tag: 'signUp-Staff',
                          child: DMPillButton(
                            text: "Sign up",
                            onPressed: () {
                              setState(() {
                                showError = true;
                              });
                              if (_formKey.currentState.validate() && _dateOfBirth != null && _yearOfCompletion != null && _yearOfAdmission != null) {
                                _bloc.add(AvailableUserCheck(_admissionController.text));
                              }
                            },
                          ),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    ));
  }
}
  
```  
# modules\auth\register\ui\widgets\date_picker_form_field.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onChanged;
  final String labelText;
  final String hint;
  final String Function(DateTime) validator;
  final bool showError;

  const DatePickerFormField(
      {Key key,
      this.initialDateTime,
      this.onChanged,
      this.labelText = "",
      this.hint = "",
      this.validator,
      this.showError = false})
      : super(key: key);

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime currentDate;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final date = await DMDatePicker.showPicker(context,
              lastDate: DateTime.now().add(Duration(days: 365 * 6)));
          currentDate = date;
          _controller.text = getFormattedDateString(date);
          if (date != null) {
            setState(() {
              widget.onChanged(date);
            });
          } else {
            setState(() {
              widget.onChanged(null);
            });
          }
        },
        child: Container(
          width: double.infinity,
          child: TextFormField(
              autofocus: false,
              focusNode: null,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  errorStyle: DMTypo.bold12RedTextStyle,
                  enabled: false,
                  labelStyle: DMTypo.bold14BlackTextStyle,
                  alignLabelWithHint: true,
                  hintStyle: DMTypo.bold16BlackTextStyle,
                  suffixIcon: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset("assets/icons/calendar.svg",
                        color: DMColors.primaryBlue, height: 15, width: 15),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue))),
              validator: (_) {
                return widget.validator(currentDate);
              },
              readOnly: true,
              controller: _controller,
              style: widget.initialDateTime == null
                  ? DMTypo.bold16BlackTextStyle
                  : DMTypo.bold16PrimaryBlueTextStyle),
        ),
      ),
    );
  }

  String getFormattedDateString(DateTime date) {
    if (date == null) {
      return null;
    } else {
      final format = DateFormat("d/M/y");
      return format.format(date);
    }
  }
}
  
```  
# modules\auth\register\ui\widgets\sign_up_text_form_field.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String) validator;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final int maxLength;

  const SignUpTextFormField(
      {Key key,
      this.controller,
      this.labelText = "",
      this.obscureText,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.maxLength})
      : assert(controller != null),
        super(key: key);

  @override
  _SignUpTextFormFieldState createState() => _SignUpTextFormFieldState();
}

class _SignUpTextFormFieldState extends State<SignUpTextFormField> {
  bool isValid = false;
  bool isTextObscure;

  @override
  void initState() {
    super.initState();
    isTextObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          final validator = widget.validator ??
              (text) {
                if (text.isEmpty) {
                  return "Enter " + widget.labelText.toLowerCase();
                } else {
                  return null;
                }
              };
          if (hasFocus || validator(widget.controller.text) != null) {
            isValid = false;
          } else {
            isValid = true;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: isValid ? DMTypo.bold16PrimaryBlueTextStyle : DMTypo.bold16BlackTextStyle,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            labelText: widget.labelText,
            isDense: false,
            errorStyle: DMTypo.bold12RedTextStyle,
            counterText: "",
            labelStyle: DMTypo.bold14BlackTextStyle,
            alignLabelWithHint: true,
            hintStyle: DMTypo.bold16BlackTextStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.primaryBlue)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.red)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.primaryBlue)),
            border: UnderlineInputBorder(borderSide: BorderSide(color: DMColors.primaryBlue)),
            suffixIcon: widget.obscureText == null
                ? null
                : IconButton(
                    icon: Icon(
                      isTextObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isTextObscure = !isTextObscure;
                      });
                    },
                    color: DMColors.mutedBlue),
          ),
          maxLines: 1,
          maxLength: widget.maxLength,
          controller: widget.controller,
          validator: widget.validator ??
              (text) {
                if (text.isEmpty) {
                  return "Enter " + widget.labelText.toLowerCase();
                } else {
                  return null;
                }
              },
          onChanged: widget.onChanged ?? (_) {},
          obscureText: isTextObscure ?? false,
        ),
      ),
    );
  }
}
  
```  
# modules\auth\ui\screens\auth_screen.dart  
```dart
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child:
                        SvgPicture.asset('assets/logo/ic_launcher_round.svg'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(DMDetails.appName.toUpperCase(),
                        style: DMTypo.alefBold36DarkBlueTextStyle),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: Hero(
                      tag: 'signIn-Student',
                      child: DMPillButton(
                        text: "Sign in",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.LOGIN_CHOOSER_SCREEN);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    margin: const EdgeInsets.only(top: 20),
                    child: Hero(
                      tag: 'signUp-Staff',
                      child: DMPillButton(
                        text: "Sign up",
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.REGISTER_SCREEN);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
  
```  
# modules\splash\bloc\splash_bloc.dart  
```dart
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/splash/bloc/splash_events.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:DigiMess/modules/splash/data/splash_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository _splashRepository;

  SplashBloc(SplashState initialState, this._splashRepository)
      : super(initialState);

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    yield SplashLoading();
    if (event is InitApp) {
      final DMTaskState result = await _splashRepository.initApp();
      if (result.isTaskSuccess) {
        yield SplashSuccess(result.taskResultData);
      } else {
        yield SplashError(result.error);
      }
    } else if (event is LogOutUserSplash) {
      await SharedPrefRepository.logOutUser();
      yield UserLoggedOutSplash();
    } else {
      yield SplashError(DMError(message: "Invalid event passed!"));
    }
  }
}
  
```  
# modules\splash\bloc\splash_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class InitApp extends SplashEvent {
  @override
  List<Object> get props => [];
}
class LogOutUserSplash extends SplashEvent {
  @override
  List<Object> get props => [];
}
  
```  
# modules\splash\bloc\splash_states.dart  
```dart
import 'package:DigiMess/common/util/app_status.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class UserLoggedOutSplash extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashSuccess extends SplashState {
  final AppStatus appStatus;

  SplashSuccess(this.appStatus);

  @override
  List<Object> get props => [appStatus];
}

class SplashError extends SplashState {
  final DMError error;

  SplashError(this.error);

  @override
  List<Object> get props => [error];
}

class SplashIdle extends SplashState {
  @override
  List<Object> get props => [];
}
  
```  
# modules\splash\data\splash_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';

class SplashRepository {
  Future<DMTaskState> initApp() async {
    try {
      await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      final AppStatus appStatus =
          await SharedPrefRepository.getAppClientStatus();
      final CollectionReference _usersClient =
          FirebaseClient.getUsersCollectionReference();
      if (appStatus.userId == null) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: appStatus, error: null);
      }
      return await _usersClient.doc(appStatus.userId ?? "").get().then((value) {
        final User user = User.fromDocument(value);
        print(user);
        final AppStatus status =
            appStatus.copyWith(isEnabledInFirebase: user.isEnrolled ?? false);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: status, error: null);
      }).onError((error, stackTrace) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString(), throwable: e));
    }
  }
}
  
```  
# modules\splash\ui\screens\splash_screen.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/splash/bloc/splash_bloc.dart';
import 'package:DigiMess/modules/splash/bloc/splash_events.dart';
import 'package:DigiMess/modules/splash/bloc/splash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is SplashSuccess) {
            if (state.appStatus.userType == UserType.GUEST ||
                state.appStatus.username == null ||
                state.appStatus.userId == null ||
                !state.appStatus.isEnabledInFirebase) {
              BlocProvider.of<SplashBloc>(context).add(LogOutUserSplash());
            } else {
              switch (state.appStatus.userType) {
                case UserType.STUDENT:
                  Navigator.popAndPushNamed(
                      context, Routes.MAIN_SCREEN_STUDENT);
                  break;
                case UserType.STAFF:
                  Navigator.popAndPushNamed(context, Routes.MAIN_SCREEN_STAFF);
                  break;
                default:
                  break;
              }
            }
          } else if (state is UserLoggedOutSplash) {
            Navigator.popAndPushNamed(context, Routes.AUTH_SCREEN);
          }
        },
        builder: (context, state) {
          BlocProvider.of<SplashBloc>(context).add(InitApp());
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: DMColors.darkBlue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    child: SvgPicture.asset("assets/logo/ic_foreground.svg",
                        width: 64, height: 64),
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Setting things up....",
                        style: DMTypo.bold18WhiteTextStyle,
                      )),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
  
```  
# modules\staff\annual_poll\bloc\annual_poll_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/staff/annual_poll/data/annual_poll_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffAnnualPollBloc extends Bloc<StaffAnnualPollEvents, StaffAnnualPollStates> {
  final StaffAnnualPollRepository _annualPollRepository;

  StaffAnnualPollBloc(StaffAnnualPollStates initialState, this._annualPollRepository)
      : super(initialState);

  @override
  Stream<StaffAnnualPollStates> mapEventToState(StaffAnnualPollEvents event) async* {
    yield AnnualPollLoading();
    if (event is GetAllVotes) {
      final DMTaskState result = await _annualPollRepository.getMenuItems();
      if (result.isTaskSuccess) {
        yield AnnualPollFetchSuccess(result.taskResultData);
      } else {
        yield AnnualPollError(result.error);
      }
    } else if (event is ResetAnnualPoll) {
      final DMTaskState result = await _annualPollRepository.resetAnnualPoll();
      if (result.isTaskSuccess) {
        yield AnnualPollResetSuccess();
      } else {
        yield AnnualPollError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\annual_poll\bloc\annual_poll_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffAnnualPollEvents extends Equatable {
  const StaffAnnualPollEvents();
}

class GetAllVotes extends StaffAnnualPollEvents {
  @override
  List<Object> get props => [];
}

class ResetAnnualPoll extends StaffAnnualPollEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\annual_poll\bloc\annual_poll_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffAnnualPollStates extends Equatable {
  const StaffAnnualPollStates();
}

class AnnualPollIdle extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollLoading extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollFetchSuccess extends StaffAnnualPollStates {
  final List<MenuItem> listOfItems;

  AnnualPollFetchSuccess(this.listOfItems);

  @override
  List<Object> get props => [listOfItems];
}

class AnnualPollResetSuccess extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollError extends StaffAnnualPollStates {
  final DMError error;

  AnnualPollError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\annual_poll\data\annual_poll_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAnnualPollRepository {
  final CollectionReference _menuClient;

  StaffAnnualPollRepository(this._menuClient);

  Future<DMTaskState> getMenuItems() async {
    try {
      return await _menuClient.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(isTaskSuccess: true, taskResultData: menuList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> resetAnnualPoll() async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      return await _menuClient.get().then((value) async {
        value.docs.forEach((element) {
          batch.update(element.reference, {
            "annualPoll.forBreakFast": 0,
            "annualPoll.forLunch": 0,
            "annualPoll.forDinner": 0,
          });
        });
        batch.commit();
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\annual_poll\ui\screens\annual_poll.dart  
```dart
import 'dart:math';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/util/meal_timing.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/widgets/annual_poll_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffAnnualPollScreen extends StatefulWidget {
  @override
  _StaffAnnualPollScreenState createState() => _StaffAnnualPollScreenState();
}

class _StaffAnnualPollScreenState extends State<StaffAnnualPollScreen> {
  bool _isLoading = false;
  List<MenuItem> listOfItems = [];
  StaffAnnualPollBloc _bloc;
  MealTiming currentSelectedTab = MealTiming.BREAKFAST;
  int breakfastMaxVotes = 0;
  int lunchMaxVotes = 0;
  int dinnerMaxVotes = 0;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffAnnualPollBloc, StaffAnnualPollStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AnnualPollLoading;
          });

          if (state is AnnualPollError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is AnnualPollFetchSuccess) {
            setState(() {
              listOfItems = state.listOfItems;
              breakfastMaxVotes =
                  listOfItems.map((e) => e.annualPollVotes.forBreakFast).reduce(max);
              lunchMaxVotes = listOfItems.map((e) => e.annualPollVotes.forLunch).reduce(max);
              dinnerMaxVotes = listOfItems.map((e) => e.annualPollVotes.forDinner).reduce(max);
            });
          } else if (state is AnnualPollResetSuccess) {
            _bloc.add(GetAllVotes());
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffAnnualPollBloc>(context);
          if (state is AnnualPollIdle) {
            _bloc.add(GetAllVotes());
            return Container();
          } else if (state is AnnualPollLoading) {
            return Container();
          } else {
            return Container(child: getAnnualPollScreen());
          }
        },
      ),
    );
  }

  Widget getAnnualPollScreen() {
    if (listOfItems == null || listOfItems.isEmpty) {
      return Center(
        child: Text("No menu items added.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Annual poll status", style: DMTypo.bold16BlackTextStyle),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(getAnnualPollStatus(), style: DMTypo.normal14BlackTextStyle))
                    ],
                  ),
                ),
                DMPillOutlinedButton(
                  text: "Reset",
                  textStyle: DMTypo.bold14DarkBlueTextStyle,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  onPressed: () async {
                    final bool choice = await DMAlertDialog.show(context, "Reset annual poll?");
                    if (choice) {
                      _bloc.add(ResetAnnualPoll());
                    }
                  },
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Ratings", style: DMTypo.bold16BlackTextStyle)),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("The students voted for these foods.",
                  style: DMTypo.normal14BlackTextStyle)),
          getMealTimingTabs(),
          Expanded(
              child: GestureDetector(
            onHorizontalDragEnd: _onSwipe,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
                itemCount: listOfItems.length,
                itemBuilder: (context, index) {
                  return AnnualPollItem(
                      name: listOfItems[index].name,
                      votes: getVotes(listOfItems[index]),
                      mealTiming: currentSelectedTab,
                      maxVotesOfTiming: getMaxVoteOfCurrentTab());
                }),
          ))
        ],
      );
    }
  }

  String getAnnualPollStatus() {
    final DateTime now = DateTime.now();
    if (now.month == 12) {
      return "Open";
    } else {
      return "Closed";
    }
  }

  _setSelectedTab(MealTiming mealTiming) {
    setState(() {
      currentSelectedTab = mealTiming;
    });
  }

  getMaxVoteOfCurrentTab() {
    if (currentSelectedTab == MealTiming.BREAKFAST) {
      return breakfastMaxVotes;
    } else if (currentSelectedTab == MealTiming.LUNCH) {
      return lunchMaxVotes;
    } else {
      return dinnerMaxVotes;
    }
  }

  int getVotes(MenuItem menuItem) {
    if (currentSelectedTab == MealTiming.BREAKFAST) {
      return menuItem.annualPollVotes.forBreakFast;
    } else if (currentSelectedTab == MealTiming.LUNCH) {
      return menuItem.annualPollVotes.forLunch;
    } else {
      return menuItem.annualPollVotes.forDinner;
    }
  }

  Widget getMealTimingTabs() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
            children: List.generate(MealTiming.values.length, (index) {
          final currentTiming = MealTiming.values[index];
          final isCurrent = currentSelectedTab == currentTiming;
          return Expanded(
              child: InkWell(
            onTap: () => _setSelectedTab(currentTiming),
            child: Container(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(currentTiming.toStringValue().capitalizeFirst(),
                      style:
                          isCurrent ? DMTypo.bold14BlackTextStyle : DMTypo.normal14BlackTextStyle),
                ),
                Divider(
                    color: isCurrent ? DMColors.primaryBlue : Colors.transparent,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20)
              ],
            )),
          ));
        })));
  }

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity > 0) {
      // Right Swipe (+x axis movement)
      if (currentSelectedTab == MealTiming.DINNER) {
        setState(() {
          currentSelectedTab = MealTiming.LUNCH;
        });
      } else if (currentSelectedTab == MealTiming.LUNCH) {
        setState(() {
          currentSelectedTab = MealTiming.BREAKFAST;
        });
      }
    } else if (details.primaryVelocity < 0) {
      //Left Swipe (-x axis movement)
      if (currentSelectedTab == MealTiming.BREAKFAST) {
        setState(() {
          currentSelectedTab = MealTiming.LUNCH;
        });
      } else if (currentSelectedTab == MealTiming.LUNCH) {
        setState(() {
          currentSelectedTab = MealTiming.DINNER;
        });
      }
    }
  }
}
  
```  
# modules\staff\annual_poll\ui\util\meal_timing.dart  
```dart
enum MealTiming { BREAKFAST, LUNCH, DINNER }

extension MealTimingExtensions on MealTiming {
  String toStringValue() {
    return this
        .toString()
        .split('.')
        .last;
  }
}  
```  
# modules\staff\annual_poll\ui\widgets\annual_poll_item.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/util/meal_timing.dart';
import 'package:flutter/material.dart';

class AnnualPollItem extends StatelessWidget {
  final String name;
  final int votes;
  final MealTiming mealTiming;
  final int maxVotesOfTiming;

  const AnnualPollItem({Key key, this.name, this.votes, this.mealTiming, this.maxVotesOfTiming})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(name, style: DMTypo.bold14BlackTextStyle),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text("• $votes ${votes == 1 ? "vote" : "votes"}",
                            style: DMTypo.bold14PrimaryBlueTextStyle)))
              ],
            ),
            getVoteCountBar(constraints)
          ],
        ),
      );
    });
  }

  Widget getVoteCountBar(BoxConstraints constraints) {
    final ratio = maxVotesOfTiming == 0 ? 0 : votes / maxVotesOfTiming;
    final double widthBias = ratio < 0.01 ? 0.01 : ratio;
    return Container(
      height: 5,
      margin: EdgeInsets.only(top: 10),
      width: constraints.maxWidth * widthBias,
      decoration: BoxDecoration(color: DMColors.green, borderRadius: BorderRadius.circular(50)),
    );
  }
}
  
```  
# modules\staff\complaints\bloc\complaints_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffComplaintsBloc extends Bloc<StaffComplaintsEvents, StaffComplaintsStates> {
  final StaffComplaintsRepository _complaintsRepository;

  StaffComplaintsBloc(
      StaffComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StaffComplaintsStates> mapEventToState(StaffComplaintsEvents event) async* {
    yield ComplaintsLoading();
    if (event is GetAllComplaints) {
      final DMTaskState result = await _complaintsRepository.getAllComplaints();
      if (result.isTaskSuccess) {
        yield ComplaintsSuccess(result.taskResultData);
      } else {
        yield ComplaintsError(result.error);
      }
    }
  }
}  
```  
# modules\staff\complaints\bloc\complaints_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsEvents extends Equatable {
  const StaffComplaintsEvents();
}

class GetAllComplaints extends StaffComplaintsEvents {
  @override
  List<Object> get props => [];
}  
```  
# modules\staff\complaints\bloc\complaints_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsStates extends Equatable {
  const StaffComplaintsStates();
}

class ComplaintsIdle extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsLoading extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsSuccess extends StaffComplaintsStates {
  final List<ComplaintWrapper> listOfComplaints;

  ComplaintsSuccess(this.listOfComplaints);

  @override
  List<Object> get props => [listOfComplaints];
}

class ComplaintsError extends StaffComplaintsStates {
  final DMError error;

  ComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\complaints\data\complaints_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffComplaintsRepository {
  final CollectionReference _complaintsClient;

  StaffComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> getAllComplaints() async {
    try {
      return await _complaintsClient.orderBy('date', descending: true).get().then((value) async {
        final List<ComplaintWrapper> listOfComplaintsWithUser = [];
        final data = value.docs;
        final List<Complaint> complaintsList = data.map((e) => Complaint.fromDocument(e)).toList();
        print(complaintsList);
        await Future.forEach(complaintsList, (element) async {
          await element.user.get().then((value) =>
              listOfComplaintsWithUser.add(ComplaintWrapper(element, User.fromDocument(value))));
        });
        return DMTaskState(
            isTaskSuccess: true, taskResultData: listOfComplaintsWithUser, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\complaints\data\util\complaint_wrapper.dart  
```dart
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:equatable/equatable.dart';

class ComplaintWrapper extends Equatable {
  final Complaint complaint;
  final User user;

  ComplaintWrapper(this.complaint, this.user);

  @override
  List<Object> get props => [complaint, user];
}
  
```  
# modules\staff\complaints\ui\screens\complaints_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:DigiMess/modules/staff/complaints/ui/widgets/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffComplaintsScreen extends StatefulWidget {
  @override
  _StaffComplaintsScreenState createState() => _StaffComplaintsScreenState();
}

class _StaffComplaintsScreenState extends State<StaffComplaintsScreen> {
  bool _isLoading = false;
  List<ComplaintWrapper> listOfComplaints = [];
  StaffComplaintsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffComplaintsBloc, StaffComplaintsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is ComplaintsLoading;
          });

          if (state is ComplaintsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is ComplaintsSuccess) {
            setState(() {
              listOfComplaints = state.listOfComplaints;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffComplaintsBloc>(context);
          if (state is ComplaintsIdle) {
            _bloc.add(GetAllComplaints());
            return Container();
          } else if (state is ComplaintsLoading) {
            return Container();
          } else {
            return Container(child: getListOrEmptyHint());
          }
        },
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfComplaints == null || listOfComplaints.isEmpty) {
      return Center(
        child: Text("No Complaints received yet.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: listOfComplaints.length,
          itemBuilder: (context, index) {
            return ComplaintsCard(complaintWrapper: listOfComplaints[index]);
          });
    }
  }
}
  
```  
# modules\staff\complaints\ui\widgets\complaints_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsCard extends StatelessWidget {
  final ComplaintWrapper complaintWrapper;

  const ComplaintsCard({Key key, this.complaintWrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String complaintCategory =
        complaintWrapper.complaint.categories.map((e) => e.capitalizeFirst()).join(", ");
    final String complaintUser =
        "${complaintWrapper.user.username} - ${complaintWrapper.user.name}";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: DMColors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaintUser, style: DMTypo.bold14UnderlinedBlackTextStyle),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Categories",
                style: DMTypo.bold14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                complaintCategory,
                style: DMTypo.normal14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Others",
                style: DMTypo.bold14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                complaintWrapper.complaint.complaint,
                style: DMTypo.normal14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Posted on ",
                      style: DMTypo.bold14BlackTextStyle,
                    ),
                  ),
                  Text(
                    getDate(),
                    style: DMTypo.normal12BlackTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDate() {
    if (complaintWrapper.complaint.date != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(complaintWrapper.complaint.date);
    } else {
      return "N/A";
    }
  }
}
  
```  
# modules\staff\help\ui\screen\help_screen.dart  
```dart
import 'package:DigiMess/common/constants/app_faqs.dart';
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/help_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffHelpScreen extends StatelessWidget {
  _makingPhoneCall() async {
    const url = 'tel://${DMDetails.devPhoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
                child: Text("Developer contact", style: DMTypo.bold20BlackTextStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30).copyWith(bottom: 0),
              child: InkWell(
                onTap: () => _makingPhoneCall(),
                child: SvgPicture.asset("assets/icons/callbutton.svg",
                    height: 25, color: DMColors.primaryBlue),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30).copyWith(bottom: 0),
          child: Text("FAQs", style: DMTypo.bold18DarkBlueTextStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 0),
            itemCount: DMFaqs.staffFAQs.length,
            itemBuilder: (_, index) {
              return HelpWidget(
                question: DMFaqs.staffFAQs[index].question,
                answer: DMFaqs.staffFAQs[index].answer,
              );
            },
          ),
        )
      ],
    );
  }
}
  
```  
# modules\staff\home\bloc\home_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_events.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffHomeBloc extends Bloc<StaffHomeEvents, StaffHomeStates> {
  final StaffHomeRepository _homeRepository;

  StaffHomeBloc(StaffHomeStates initialState, this._homeRepository) : super(initialState);

  @override
  Stream<StaffHomeStates> mapEventToState(StaffHomeEvents event) async* {
    yield StaffHomeLoading();
    if (event is FetchStaffHomeDetails) {
      final DMTaskState menuResult = await _homeRepository.getTodaysMenu();
      if (menuResult.isTaskSuccess) {
        final DMTaskState noticeResult = await _homeRepository.getLatestNotice();
        if (noticeResult.isTaskSuccess) {
          final DMTaskState enrolledCountResult = await _homeRepository.getEnrolledCount();
          if (enrolledCountResult.isTaskSuccess) {
            final DMTaskState presentCountResult =
                await _homeRepository.getPresentCount(enrolledCountResult.taskResultData);
            if (presentCountResult.isTaskSuccess) {
              yield StaffHomeFetchSuccess(
                  studentEnrolledCount: enrolledCountResult.taskResultData,
                  latestNotice: noticeResult.taskResultData,
                  listOfTodaysMeals: menuResult.taskResultData,
                  studentPresentCount: presentCountResult.taskResultData);
            } else {
              yield StaffHomeError(presentCountResult.error);
            }
          } else {
            yield StaffHomeError(enrolledCountResult.error);
          }
        } else {
          yield StaffHomeError(noticeResult.error);
        }
      } else {
        yield StaffHomeError(menuResult.error);
      }
    }
  }
}
  
```  
# modules\staff\home\bloc\home_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffHomeEvents extends Equatable {
  const StaffHomeEvents();
}

class FetchStaffHomeDetails extends StaffHomeEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\home\bloc\home_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StaffHomeStates extends Equatable {
  const StaffHomeStates();
}

class StaffHomeLoading extends StaffHomeStates {
  @override
  List<Object> get props => [];
}

class StaffHomeIdle extends StaffHomeStates {
  @override
  List<Object> get props => [];
}

class StaffHomeFetchSuccess extends StaffHomeStates {
  final List<MenuItem> listOfTodaysMeals;
  final List<Notice> latestNotice;
  final StudentEnrolledCount studentEnrolledCount;
  final StudentPresentCount studentPresentCount;

  StaffHomeFetchSuccess(
      {@required this.listOfTodaysMeals,
      @required this.latestNotice,
      @required this.studentEnrolledCount,
      @required this.studentPresentCount});

  @override
  List<Object> get props => [
        this.listOfTodaysMeals,
        this.latestNotice,
        this.studentPresentCount,
        this.studentEnrolledCount
      ];
}

class StaffHomeError extends StaffHomeStates {
  final DMError errors;

  StaffHomeError(this.errors);

  @override
  List<Object> get props => [this.errors];
}
  
```  
# modules\staff\home\data\home_repository.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffHomeRepository {
  final CollectionReference _menuClient;
  final CollectionReference _noticesClient;
  final CollectionReference _usersClient;
  final CollectionReference _absenteesClient;

  StaffHomeRepository(
      this._menuClient, this._noticesClient, this._absenteesClient, this._usersClient);

  Future<DMTaskState> getTodaysMenu() async {
    try {
      final today = DateTime.now();
      final String dayKey = today.getDayKey();
      return await _menuClient
          .where("isEnabled", isEqualTo: true)
          .where("daysAvailable.$dayKey", isEqualTo: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<MenuItem> todaysFood =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(todaysFood);
        return DMTaskState(isTaskSuccess: true, taskResultData: todaysFood, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getLatestNotice() async {
    try {
      return await _noticesClient.orderBy('date', descending: true).limit(1).get().then((value) {
        final latestNotice = value.docs.map((e) => Notice.fromDocument(e)).toList();
        print(latestNotice);
        return DMTaskState(isTaskSuccess: true, taskResultData: latestNotice, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getEnrolledCount() async {
    try {
      return await _usersClient
          .where("type", isEqualTo: UserType.STUDENT.toStringValue())
          .where("isEnrolled", isEqualTo: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<User> enrolledStudents = data.map((e) => User.fromDocument(e)).toList();
        print(enrolledStudents);
        final int totalCount = enrolledStudents.length;
        final int vegCount = enrolledStudents.where((element) => element.isVeg).length;
        final int nonVegCount = totalCount - vegCount;
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: StudentEnrolledCount(
                studentsEnrolled: totalCount,
                studentsEnrolledNonVeg: nonVegCount,
                studentsEnrolledVeg: vegCount),
            error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getPresentCount(StudentEnrolledCount enrolledCount) async {
    try {
      final now = DateTime.now();
      final today = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
      return await _absenteesClient
          .where("startDate", isLessThanOrEqualTo: today)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesToday = data
            .map((e) => LeaveEntry.fromDocument(e))
            .where((element) => element.endDate.compareTo(today.toDate()) >= 0)
            .toList();
        print(leavesToday);
        final int totalCount = enrolledCount.studentsEnrolled - leavesToday.length;
        int vegCount = enrolledCount.studentsEnrolledVeg;
        int nonVegCount = enrolledCount.studentsEnrolledNonVeg;
        leavesToday.forEach((element) {
          element.user.get().then((value) {
            final user = User.fromDocument(value);
            if (user != null) {
              user.isVeg ? --vegCount : --nonVegCount;
            }
          });
        });
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: StudentPresentCount(
                studentsPresent: totalCount,
                studentsPresentNonVeg: nonVegCount,
                studentsPresentVeg: vegCount),
            error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\home\data\models\home_students_present.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StudentPresentCount extends Equatable {
  final int studentsPresent;
  final int studentsPresentVeg;
  final int studentsPresentNonVeg;

  StudentPresentCount(
      {@required this.studentsPresent,
      @required this.studentsPresentVeg,
      @required this.studentsPresentNonVeg});

  @override
  List<Object> get props =>
      [this.studentsPresent, this.studentsPresentVeg, this.studentsPresentNonVeg];
}
  
```  
# modules\staff\home\data\models\home_student_count.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StudentEnrolledCount extends Equatable {
  final int studentsEnrolled;
  final int studentsEnrolledVeg;
  final int studentsEnrolledNonVeg;

  StudentEnrolledCount(
      {@required this.studentsEnrolled,
      @required this.studentsEnrolledVeg,
      @required this.studentsEnrolledNonVeg});

  @override
  List<Object> get props =>
      [this.studentsEnrolled, this.studentsEnrolledVeg, this.studentsEnrolledNonVeg];
}
  
```  
# modules\staff\home\ui\screens\home_screen.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_events.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/home_bg_scroll_view.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/student_enrolled_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/student_present_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/todays_food_card.dart';
import 'package:DigiMess/modules/staff/home/ui/widgets/todays_food_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffHomeScreen extends StatefulWidget {
  final VoidCallback noticesCallback;

  const StaffHomeScreen({Key key, this.noticesCallback}) : super(key: key);

  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  bool _isLoading = false;
  StaffHomeBloc _homeBloc;
  StudentEnrolledCount studentEnrolledCount;
  StudentPresentCount studentPresentCount;
  List<MenuItem> listOfTodaysMeals;
  Notice latestNotice;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StaffHomeBloc, StaffHomeStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffHomeLoading;
          });
          if (state is StaffHomeError) {
            DMSnackBar.show(context, state.errors.message);
          } else if (state is StaffHomeFetchSuccess) {
            setState(() {
              listOfTodaysMeals = state.listOfTodaysMeals;
              latestNotice = state.latestNotice.takeFirstOrNull();
              studentEnrolledCount = state.studentEnrolledCount;
              studentPresentCount = state.studentPresentCount;
            });
          }
        },
        builder: (context, state) {
          _homeBloc = BlocProvider.of<StaffHomeBloc>(context);
          if (state is StaffHomeIdle) {
            _homeBloc.add(FetchStaffHomeDetails());
            return Container();
          } else if (state is StaffHomeFetchSuccess) {
            return HomeScrollView(
                child: Column(
              children: [
                TodaysFoodCard(listOfTodaysMeals: listOfTodaysMeals),
                Visibility(
                    visible: !DateExtensions.isNightTime(),
                    child: TodaysFoodPageView(listOfTodaysMeals: listOfTodaysMeals)),
                Visibility(
                    visible: studentEnrolledCount != null,
                    child: StudentEnrolledCard(studentEnrolledCount: studentEnrolledCount)),
                Visibility(
                    visible: studentPresentCount != null,
                    child: StudentPresentCard(studentPresentCount: studentPresentCount)),
                Visibility(
                  visible: latestNotice != null,
                  child: NoticeCard(
                      latestNotice: latestNotice, noticesCallback: widget.noticesCallback),
                ),
              ],
            ));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
  
```  
# modules\staff\home\ui\widgets\home_bg_scroll_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScrollView extends StatelessWidget {
  final Widget child;

  const HomeScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Container(
        color: DMColors.lightBlue,
        child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    child: SvgPicture.asset("assets/icons/home_bg.svg",
                        fit: BoxFit.cover),
                  ),
                  child,
                ],
              ),
            )),
      );
    });
  }
}
  
```  
# modules\staff\home\ui\widgets\notice_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final Notice latestNotice;
  final VoidCallback noticesCallback;

  const NoticeCard({Key key, this.latestNotice, this.noticesCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DMColors.white,
          border: Border.all(color: DMColors.primaryBlue, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Icon(Icons.circle, color: DMColors.yellow, size: 10)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(latestNotice.title, style: DMTypo.bold14BlackTextStyle)),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(latestNotice.date.getTimeAgo(),
                            style: DMTypo.bold12MutedTextStyle)),
                  ],
                ),
              ),
            ],
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: noticesCallback,
              child: Row(
                children: [
                  Text("View more", style: DMTypo.bold12PrimaryBlueTextStyle),
                  Icon(Icons.double_arrow, color: DMColors.primaryBlue, size: 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
  
```  
# modules\staff\home\ui\widgets\student_enrolled_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:flutter/material.dart';

class StudentEnrolledCard extends StatelessWidget {
  final StudentEnrolledCount studentEnrolledCount;

  const StudentEnrolledCard({Key key, this.studentEnrolledCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(color: DMColors.blueBg, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: DMColors.primaryBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Center(
              child: Column(
                children: [
                  Text(studentEnrolledCount.studentsEnrolled.toString(),
                      style: DMTypo.bold36WhiteTextStyle),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Students enrolled", style: DMTypo.bold14WhiteTextStyle))
                ],
              ),
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(studentEnrolledCount.studentsEnrolledNonVeg.toString(),
                            style: DMTypo.bold24DarkBlueTextStyle),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("non-veg", style: DMTypo.bold14DarkBlueTextStyle))
                      ]),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(studentEnrolledCount.studentsEnrolledVeg.toString(),
                              style: DMTypo.bold24PrimaryBlueTextStyle),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("veg", style: DMTypo.bold14PrimaryBlueTextStyle))
                        ]),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
  
```  
# modules\staff\home\ui\widgets\student_present_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:flutter/material.dart';

class StudentPresentCard extends StatelessWidget {
  final StudentPresentCount studentPresentCount;

  const StudentPresentCard({Key key, this.studentPresentCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(color: DMColors.blueBg, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: DMColors.primaryBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Center(
              child: Column(
                children: [
                  Text(studentPresentCount.studentsPresent.toString(),
                      style: DMTypo.bold36WhiteTextStyle),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Students present", style: DMTypo.bold14WhiteTextStyle))
                ],
              ),
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(studentPresentCount.studentsPresentNonVeg.toString(),
                            style: DMTypo.bold24DarkBlueTextStyle),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("non-veg", style: DMTypo.bold14DarkBlueTextStyle))
                      ]),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(studentPresentCount.studentsPresentVeg.toString(),
                              style: DMTypo.bold24PrimaryBlueTextStyle),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("veg", style: DMTypo.bold14PrimaryBlueTextStyle))
                        ]),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
  
```  
# modules\staff\home\ui\widgets\todays_food_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TodaysFoodCard extends StatelessWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodCard({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.all(20), child: getMenuIconOrClosedIcon()),
          Expanded(
            child: Container(margin: EdgeInsets.all(20), child: getTodayMessOrClosedHint()),
          ),
        ],
      ),
    );
  }

  Widget getTodayMessOrClosedHint() {
    if (DateExtensions.isNightTime()) {
      return Text("Mess closed", style: DMTypo.bold24BlackTextStyle);
    } else {
      return Column(
        children: [
          Text("Today's Food", style: DMTypo.bold24BlackTextStyle),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(getTimeInterval(), style: DMTypo.bold12MutedTextStyle),
          ),
          getFoodItemsOfCurrentTime()
        ],
      );
    }
  }

  String getTimeInterval() {
    if (DateExtensions.isBreakfastTime()) {
      return "9:00 AM - 11:00 AM";
    } else if (DateExtensions.isLunchTime()) {
      return "12:00 PM - 1:00 PM";
    } else if (DateExtensions.isDinnerTime()) {
      return "8:00 PM - 9:00 PM";
    } else {
      return "";
    }
  }

  Widget getFoodItemsOfCurrentTime() {
    String mealsString;
    if (DateExtensions.isBreakfastTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isLunchTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isDinnerTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    }

    return Text(mealsString ?? "Food not marked by mess staff", style: DMTypo.bold12BlackTextStyle);
  }

  getMenuIconOrClosedIcon() {
    if (DateExtensions.isNightTime()) {
      return SvgPicture.asset("assets/icons/moon_icon.svg");
    } else {
      return SvgPicture.asset("assets/icons/food_icon.svg");
    }
  }
}
  
```  
# modules\staff\home\ui\widgets\todays_food_item.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TodaysFoodItem extends StatelessWidget {
  final String title;
  final MenuItem nonVegItem;
  final MenuItem vegItem;

  const TodaysFoodItem({Key key, this.title, this.nonVegItem, this.vegItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(title, style: DMTypo.bold18BlackTextStyle),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getImagesOrEmptyHint(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getImagesOrEmptyHint() {
    if (vegItem == null && nonVegItem == null) {
      return [
        Text("Food not marked by mess staff",
            style: DMTypo.bold12BlackTextStyle)
      ];
    } else if (vegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        )
      ];
    } else if (nonVegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    } else {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        ),
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    }
  }
}

class FoodImageItem extends StatelessWidget {
  final bool isVeg;
  final String foodName;
  final String imageUrl;

  const FoodImageItem({Key key, this.isVeg, this.foodName, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      foodName,
                      style: DMTypo.bold12BlackTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SvgPicture.asset(
                    isVeg
                        ? "assets/icons/veg_icon.svg"
                        : "assets/icons/non_veg_icon.svg",
                    height: 10,
                    width: 10,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
  
```  
# modules\staff\home\ui\widgets\todays_food_page_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class TodaysFoodPageView extends StatefulWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodPageView({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  _TodaysFoodPageViewState createState() => _TodaysFoodPageViewState();
}

class _TodaysFoodPageViewState extends State<TodaysFoodPageView> {
  double currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: double.infinity,
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: PageController(initialPage: currentIndex.toInt()),
              onPageChanged: onPageChanged,
              children: getPages(),
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: currentIndex,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(30.0, 9.0),
              activeColor: DMColors.primaryBlue,
              color: DMColors.accentBlue,
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentIndex = value.toDouble();
    });
  }

  List<TodaysFoodItem> getPages() {
    final List<MenuItem> breakfastFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isBreakfast).toList();
    final List<MenuItem> lunchFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isLunch).toList();
    final List<MenuItem> dinnerFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isDinner).toList();
    return [
      TodaysFoodItem(
          title: "Breakfast",
          vegItem: breakfastFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: breakfastFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Lunch",
          vegItem: lunchFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: lunchFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Dinner",
          vegItem: dinnerFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: dinnerFood.firstWhere((element) => !element.isVeg, orElse: () => null))
    ];
  }
}
  
```  
# modules\staff\leaves\bloc\leaves_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/staff/leaves/data/leaves_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffLeavesBloc extends Bloc<StaffLeavesEvents, StaffLeavesStates> {
  final StaffLeavesRepository _leavesRepository;

  StaffLeavesBloc(StaffLeavesStates initialState, this._leavesRepository) : super(initialState);

  @override
  Stream<StaffLeavesStates> mapEventToState(StaffLeavesEvents event) async* {
    yield StaffLeavesLoading();
    if (event is GetAllLeaves) {
      final DMTaskState result = await _leavesRepository.getAllLeaves();
      if (result.isTaskSuccess) {
        yield StaffLeavesSuccess(result.taskResultData);
      } else {
        yield StaffLeavesError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\leaves\bloc\leaves_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffLeavesEvents extends Equatable {
  const StaffLeavesEvents();
}

class GetAllLeaves extends StaffLeavesEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\leaves\bloc\leaves_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffLeavesStates extends Equatable {
  const StaffLeavesStates();
}

class StaffLeavesIdle extends StaffLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesLoading extends StaffLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesSuccess extends StaffLeavesStates {
  final List<LeavesWrapper> listOfLeaves;

  StaffLeavesSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StaffLeavesError extends StaffLeavesStates {
  final DMError error;

  StaffLeavesError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\leaves\data\leaves_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLeavesRepository {
  final CollectionReference _leavesRepository;

  StaffLeavesRepository(this._leavesRepository);

  Future<DMTaskState> getAllLeaves() async {
    try {
      return await _leavesRepository
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) async {
        final data = value.docs;
        final List<LeaveEntry> leavesList = data.map((e) => LeaveEntry.fromDocument(e)).toList();
        final List<LeavesWrapper> listOfLeavesWithUser = [];
        await Future.forEach(leavesList, (element) async {
          await element.user.get().then((value) =>
              listOfLeavesWithUser.add(LeavesWrapper(element, User.fromDocument(value))));
        });
        print(listOfLeavesWithUser);
        return DMTaskState(isTaskSuccess: true, taskResultData: listOfLeavesWithUser, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\leaves\data\util\leaves_wrapper.dart  
```dart
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:equatable/equatable.dart';

class LeavesWrapper extends Equatable {
  final LeaveEntry leaveEntry;
  final User user;

  LeavesWrapper(this.leaveEntry, this.user);

  @override
  List<Object> get props => [leaveEntry, user];
}
  
```  
# modules\staff\leaves\ui\screens\leaves_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:DigiMess/modules/staff/leaves/ui/widgets/leaves_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffLeavesHistoryScreen extends StatefulWidget {
  @override
  _StaffLeavesHistoryScreenState createState() => _StaffLeavesHistoryScreenState();
}

class _StaffLeavesHistoryScreenState extends State<StaffLeavesHistoryScreen> {
  bool _isLoading = false;
  List<LeavesWrapper> listOfLeaves = [];
  StaffLeavesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffLeavesBloc, StaffLeavesStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffLeavesLoading;
          });

          if (state is StaffLeavesError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StaffLeavesSuccess) {
            setState(() {
              listOfLeaves = state.listOfLeaves;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffLeavesBloc>(context);
          if (state is StaffLeavesIdle) {
            _bloc.add(GetAllLeaves());
            return Container();
          } else if (state is StaffLeavesLoading) {
            return Container();
          } else {
            return Container(child: getListOrEmptyHint());
          }
        },
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfLeaves == null || listOfLeaves.isEmpty) {
      return Center(
        child: Text("No leaves taken so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              child: Text("All leaves", style: DMTypo.bold18BlackTextStyle)),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: listOfLeaves.length,
                itemBuilder: (context, index) {
                  return LeaveCard(leave: listOfLeaves[index]);
                }),
          )
        ],
      );
    }
  }
}
  
```  
# modules\staff\leaves\ui\widgets\leaves_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final LeavesWrapper leave;

  const LeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final bool isOnGoingLeave = (leave.leaveEntry.startDate.compareTo(now) <= 0 &&
        leave.leaveEntry.endDate.copyWith(day: leave.leaveEntry.endDate.day + 1).compareTo(now) >=
            0);
    return Container(
      margin: EdgeInsets.all(20).copyWith(top: 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              isOnGoingLeave
                  ? Icon(Icons.access_time, color: DMColors.black, size: 15)
                  : SvgPicture.asset("assets/icons/check.svg",
                      color: DMColors.green, height: 15, width: 15),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(getTitle(isOnGoingLeave), style: DMTypo.bold14BlackTextStyle))),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getDayCount(), style: DMTypo.bold14PrimaryBlueTextStyle))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  child: Text(getDateInterval(), style: DMTypo.bold12MutedTextStyle),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getDayCount() {
    return leave.leaveEntry.startDate.getDifferenceInDays(leave.leaveEntry.endDate);
  }

  String getDateInterval() {
    final DateFormat format = DateFormat("d MMM yyyy");
    return "${format.format(leave.leaveEntry.startDate)} - ${format.format(leave.leaveEntry.endDate)}";
  }

  String getTitle(isOnGoingLeave) {
    return "${leave.user.username} - ${leave.user.name}";
  }
}
  
```  
# modules\staff\main\ui\screens\main_screen.dart  
```dart
import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/staff/annual_poll/data/annual_poll_repository.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/screens/annual_poll.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/complaints_repository.dart';
import 'package:DigiMess/modules/staff/complaints/ui/screens/complaints_screen.dart';
import 'package:DigiMess/modules/staff/help/ui/screen/help_screen.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/home_repository.dart';
import 'package:DigiMess/modules/staff/home/ui/screens/home_screen.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/staff/leaves/data/leaves_repository.dart';
import 'package:DigiMess/modules/staff/leaves/ui/screens/leaves_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/widgets/staff_nav_drawer.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/data/staff_menu_repository.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/screens/staff_menu_screen.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/data/notices_repository.dart';
import 'package:DigiMess/modules/staff/notices/ui/screens/notices_screen.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_bloc.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/all_students_repository.dart';
import 'package:DigiMess/modules/staff/students/all_students/ui/screens/students_screen.dart';
import 'package:flutter/material.dart';
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
      body: WillPopScope(onWillPop: _willPop, child: getCurrentScreen()),
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
      return BlocProvider(
          create: (_) => AllStudentsBloc(AllStudentsIdle(),
              AllStudentsRepository(FirebaseClient.getUsersCollectionReference())),
          child: AllStudentsScreen());
    } else if (currentScreen == StaffNavDestinations.MENU) {
      return BlocProvider(
          create: (_) => StaffMenuBloc(
              StaffMenuIdle(), StaffMenuRepository(FirebaseClient.getMenuCollectionReference())),
          child: StaffMenuScreen());
    } else if (currentScreen == StaffNavDestinations.NOTICES) {
      return BlocProvider(
          create: (_) => StaffNoticesBloc(NoticesIdle(),
              StaffNoticesRepository(FirebaseClient.getNoticesCollectionReference())),
          child: StaffNoticesScreen());
    } else if (currentScreen == StaffNavDestinations.LEAVES) {
      return BlocProvider(
          create: (_) => StaffLeavesBloc(StaffLeavesIdle(),
              StaffLeavesRepository(FirebaseClient.getAbsenteesCollectionReference())),
          child: StaffLeavesHistoryScreen());
    } else if (currentScreen == StaffNavDestinations.ANNUAL_POLL) {
      return BlocProvider(
          create: (_) => StaffAnnualPollBloc(AnnualPollIdle(),
              StaffAnnualPollRepository(FirebaseClient.getMenuCollectionReference())),
          child: StaffAnnualPollScreen());
    } else if (currentScreen == StaffNavDestinations.COMPLAINTS) {
      return BlocProvider(
          create: (_) => StaffComplaintsBloc(ComplaintsIdle(),
              StaffComplaintsRepository(FirebaseClient.getComplaintsCollectionReference())),
          child: StaffComplaintsScreen());
    } else if (currentScreen == StaffNavDestinations.HELP) {
      return StaffHelpScreen();
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
    } else if (destination == StaffNavDestinations.ABOUT) {
      openAboutDialog();
    } else {
      setState(() {
        currentScreen = destination;
      });
    }
  }

  String getTitleFromCurrentScreen() {
    return currentScreen.toStringValue().replaceAll('_', ' ');
  }

  void showLogOutAlertDialog() async {
    final bool choice = await DMAlertDialog.show(context, "Logout of Digimess?");
    if (choice) {
      BlocProvider.of<DMBloc>(context).add(LogOutUser());
    }
  }

  void openAboutDialog() async {
    await DMAboutDialog.show(context);
  }

  Future<bool> _willPop() async {
    if (currentScreen != StaffNavDestinations.HOME) {
      setState(() {
        currentScreen = StaffNavDestinations.HOME;
      });
      return false;
    } else {
      return true;
    }
  }
}
  
```  
# modules\staff\main\ui\widgets\staff_nav_drawer.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/widgets/nav_item.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StaffNavDrawer extends StatelessWidget {
  final Function(StaffNavDestinations) itemOnClickCallBack;
  final StaffNavDestinations currentScreen;

  const StaffNavDrawer({Key key, this.itemOnClickCallBack, this.currentScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: DMColors.primaryBlue,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/logo/ic_foreground.svg",
                        height: 30),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.clear),
                        color: DMColors.white,
                        iconSize: 24,
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: DMColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavItem(
                          text: "Home",
                          iconAsset: "assets/icons/home.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.HOME,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.HOME),
                        ),
                        NavItem(
                          text: "Students",
                          iconAsset: "assets/icons/students.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.STUDENTS,
                          onClick: () => itemOnClickCallBack(
                              StaffNavDestinations.STUDENTS),
                        ),
                        NavItem(
                          text: "Menu",
                          iconAsset: "assets/icons/menu.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.MENU,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.MENU),
                        ),
                        NavItem(
                          text: "Notices",
                          iconAsset: "assets/icons/notices.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.NOTICES,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.NOTICES),
                        ),
                        NavItem(
                          text: "Mess cuts",
                          iconAsset: "assets/icons/leaves.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.LEAVES,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.LEAVES),
                        ),
                        NavItem(
                          text: "Annual Poll",
                          iconAsset: "assets/icons/poll.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.ANNUAL_POLL,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.ANNUAL_POLL),
                        ),
                        NavItem(
                          text: "Complaints",
                          iconAsset: "assets/icons/complaints.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.COMPLAINTS,
                          onClick: () => itemOnClickCallBack(
                              StaffNavDestinations.COMPLAINTS),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Divider(
                            color: DMColors.mutedBlue,
                          ),
                        ),
                        NavItem(
                          text: "Help",
                          iconAsset: "assets/icons/help.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.HELP,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.HELP),
                        ),
                        NavItem(
                          text: "About",
                          iconAsset: "assets/icons/about.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.ABOUT,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.ABOUT),
                        ),
                        NavItem(
                          text: "Logout",
                          iconAsset: "assets/icons/log_out.svg",
                          isItemSelected:
                              currentScreen == StaffNavDestinations.LOGOUT,
                          onClick: () =>
                              itemOnClickCallBack(StaffNavDestinations.LOGOUT),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\staff\main\util\staff_nav_destinations.dart  
```dart
enum StaffNavDestinations {
  HOME,
  STUDENTS,
  MENU,
  NOTICES,
  LEAVES,
  ANNUAL_POLL,
  COMPLAINTS,
  HELP,
  ABOUT,
  LOGOUT
}

extension StaffNavDestinationExtensions on StaffNavDestinations {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
  
```  
# modules\staff\menu\menu_edit\bloc\staff_menu_edit_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/data/staff_edit_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffMenuEditBloc extends Bloc<StaffMenuEditEvents, StaffMenuEditStates> {
  final StaffMenuEditRepository _menuRepository;

  StaffMenuEditBloc(StaffMenuEditStates initialState, this._menuRepository) : super(initialState);

  @override
  Stream<StaffMenuEditStates> mapEventToState(StaffMenuEditEvents event) async* {
    yield StaffMenuEditLoading();
    if (event is ChangeEnabledStatus) {
      final DMTaskState result =
          await _menuRepository.changeEnabledStatus(event.isEnabled, event.id);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    } else if (event is AvailableDay) {
      final DMTaskState result = await _menuRepository.setAvailableDay(event.id, event.days);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    } else if (event is AvailableTime) {
      final DMTaskState result = await _menuRepository.setAvailableTime(event.id, event.time);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\menu\menu_edit\bloc\staff_menu_edit_events.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEditEvents extends Equatable {
  const StaffMenuEditEvents();
}

class ChangeEnabledStatus extends StaffMenuEditEvents {
  final bool isEnabled;
  final String id;

  ChangeEnabledStatus(this.isEnabled, this.id);

  @override
  List<Object> get props => [isEnabled, id];
}

class AvailableDay extends StaffMenuEditEvents {
  final DaysAvailable days;
  final String id;

  AvailableDay(this.days, this.id);

  @override
  List<Object> get props => [days, id];
}

class AvailableTime extends StaffMenuEditEvents {
  final MenuItemIsAvailable time;
  final String id;

  AvailableTime(this.time, this.id);

  @override
  List<Object> get props => [time, id];
}
  
```  
# modules\staff\menu\menu_edit\bloc\staff_menu_edit_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEditStates extends Equatable {
  const StaffMenuEditStates();
}

class StaffMenuEditIdle extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditLoading extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditSuccess extends StaffMenuEditStates {
  @override
  List<Object> get props => [];
}

class StaffMenuEditError extends StaffMenuEditStates {
  final DMError error;

  StaffMenuEditError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\menu\menu_edit\data\staff_edit_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMenuEditRepository {
  final CollectionReference _menuClient;

  StaffMenuEditRepository(this._menuClient);

  Future<DMTaskState> changeEnabledStatus(bool isEnabled, String id) async {
    try {
      return await _menuClient.doc(id).update({'isEnabled': isEnabled}).then((value) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> setAvailableDay(String id, DaysAvailable days) async {
    try {
      return await _menuClient.doc(id).update({'daysAvailable': days.toMap()}).then((value) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> setAvailableTime(String id, MenuItemIsAvailable time) async {
    try {
      return await _menuClient.doc(id).update({'isAvailable': time.toMap()}).then((value) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\menu\menu_edit\ui\screens\staff_menu_edit.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/ui/widgets/dm_color_pill_button.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/ui/widgets/meal_time_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffMenuEditScreen extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onSuccess;

  const StaffMenuEditScreen({Key key, this.item, this.onSuccess}) : super(key: key);

  @override
  _StaffMenuEditScreenState createState() => _StaffMenuEditScreenState();
}

class _StaffMenuEditScreenState extends State<StaffMenuEditScreen> {
  bool _isLoading = false;
  StaffMenuEditBloc _bloc;
  bool isEnabled;

  DaysAvailable days;
  MenuItemIsAvailable time;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.item.isEnabled;
    days = widget.item.daysAvailable;
    time = widget.item.itemIsAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      isAppBarRequired: false,
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          dismissible: false,
          child: BlocConsumer<StaffMenuEditBloc, StaffMenuEditStates>(
            listener: (context, state) async {
              setState(() {
                _isLoading = state is StaffMenuEditLoading;
              });
              if (state is StaffMenuEditError) {
                DMSnackBar.show(context, state.error.message);
              } else if (state is StaffMenuEditSuccess) {
                await Fluttertoast.showToast(msg: "Item Modified");
                widget.onSuccess();
              }
            },
            builder: (context, state) {
              _bloc = BlocProvider.of<StaffMenuEditBloc>(context);
              return getStaffMenuEditScreen();
            },
          )),
    );
  }

  Widget getStaffMenuEditScreen() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.item.imageUrl), fit: BoxFit.cover)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: DMColors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(bottom: 0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(widget.item.isVeg
                        ? "assets/icons/veg_icon.svg"
                        : "assets/icons/non_veg_icon.svg"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.item.name.toUpperCase(),
                      style: DMTypo.bold14UnderlinedBlackTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Menu status : ${isEnabled ? "Added" : "Not Added"}",
                      style: DMTypo.normal14BlackTextStyle,
                    ),
                  ),
                  DMColorPillButton(
                      padding: isEnabled
                          ? EdgeInsets.symmetric(horizontal: 30)
                          : EdgeInsets.symmetric(horizontal: 40),
                      text: isEnabled ? "Remove" : "Add",
                      textStyle: DMTypo.bold12WhiteTextStyle,
                      color: isEnabled ? DMColors.red : DMColors.green,
                      onPressed: () async {
                        final bool choice = await DMAlertDialog.show(context,
                            "${isEnabled ? "Remove" : "Add"} this item ${isEnabled ? "from" : "to"} the menu ?");
                        if (choice) {
                          isEnabled = !isEnabled;
                          _bloc.add(ChangeEnabledStatus(!isEnabled, widget.item.itemId));
                        }
                      })
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Availability",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                  CheckboxRowWidget(
                      hint: "Breakfast",
                      value: time.isBreakfast,
                      onClick: () {
                        final value = !time.isBreakfast;
                        time = time.copyWith(isBreakfast: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Lunch",
                      value: time.isLunch,
                      onClick: () {
                        final value = !time.isLunch;
                        time = time.copyWith(isLunch: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Dinner",
                      value: time.isDinner,
                      onClick: () {
                        final value = !time.isDinner;
                        time = time.copyWith(isDinner: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "Days",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                  CheckboxRowWidget(
                      hint: "Sunday",
                      value: days.sunday,
                      onClick: () {
                        final value = !days.sunday;
                        days = days.copyWith(sunday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Monday",
                      value: days.monday,
                      onClick: () {
                        final value = !days.monday;
                        days = days.copyWith(monday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Tuesday",
                      value: days.tuesday,
                      onClick: () {
                        final value = !days.tuesday;
                        days = days.copyWith(tuesday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Wednesday",
                      value: days.wednesday,
                      onClick: () {
                        final value = !days.wednesday;
                        days = days.copyWith(wednesday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Thursday",
                      value: days.thursday,
                      onClick: () {
                        final value = !days.thursday;
                        days = days.copyWith(thursday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Friday",
                      value: days.friday,
                      onClick: () {
                        final value = !days.friday;
                        days = days.copyWith(friday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Saturday",
                      value: days.saturday,
                      onClick: () {
                        final value = !days.saturday;
                        days = days.copyWith(saturday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  
```  
# modules\staff\menu\menu_edit\ui\util\meal_timing.dart  
```dart
enum MealTiming { BREAKFAST, LUNCH, DINNER }

extension MealTimingExtensions on MealTiming {
  String toStringValue() {
    return this
        .toString()
        .split('.')
        .last;
  }
}  
```  
# modules\staff\menu\menu_edit\ui\widgets\dm_color_pill_button.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMColorPillButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;
  final Color color;

  const DMColorPillButton(
      {Key key,
      this.text,
      this.onPressed,
      this.textStyle = DMTypo.bold16WhiteTextStyle,
      this.padding,
      this.isEnabled = true,
      this.color,
      this.onDisabledPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (isEnabled ? onPressed : onDisabledPressed) ?? () {},
      child: Text(text, style: textStyle, textAlign: TextAlign.center),
      style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          backgroundColor: MaterialStateProperty.all(color),
          overlayColor: MaterialStateProperty.all(isEnabled
              ? DMColors.accentBlue.withOpacity(0.3)
              : DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )),
    );
  }
}
  
```  
# modules\staff\menu\menu_edit\ui\widgets\meals_day_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AvailableTime extends StatefulWidget {
  const AvailableTime({Key key}) : super(key: key);

  @override
  _AvailableTimeState createState() => _AvailableTimeState();
}

class _AvailableTimeState extends State<AvailableTime> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Container(
        width: double.infinity,
        child: Column(
          children: [
            AvailableDays(availableDays: "Sunday",),
            AvailableDays(availableDays: "Monday",),
            AvailableDays(availableDays: "Tuesday",),
            AvailableDays(availableDays: "Wednesday",),
            AvailableDays(availableDays: "Thursday",),
            AvailableDays(availableDays: "Friday",),
            AvailableDays(availableDays: "Saturday",),
          ],
        ),
      );
    });
    }
  }




class AvailableDays extends StatefulWidget {
  final String availableDays;
  const AvailableDays({Key key, this.availableDays}) : super(key: key);

  @override
  _AvailableDaysState createState() => _AvailableDaysState();
}

class _AvailableDaysState extends State<AvailableDays> {
  bool checkState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget.availableDays,style: TextStyle(fontSize: 12),),
          value: checkState,
          selected: checkState,
          onChanged: (bool value) {
            setState(() {
              checkState = value;
            });
          },
           //  <-- leading Checkbox
        )
    );
   }
  }


  
```  
# modules\staff\menu\menu_edit\ui\widgets\meal_time_checkbox.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckboxRowWidget extends StatelessWidget {
  final String hint;
  final bool value;
  final VoidCallback onClick;

  const CheckboxRowWidget({Key key, this.hint, this.value, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 20),
      child: InkWell(
        onTap: onClick,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                  value ? "assets/icons/checkbox_check.svg" : "assets/icons/checkbox_uncheck.svg"),
            ),
            Text(
              hint,
              style: value ? DMTypo.bold14PrimaryBlueTextStyle : DMTypo.normal14BlackTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
  
```  
# modules\staff\menu\menu_screen\bloc\staff_menu_screen_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/data/staff_menu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffMenuBloc extends Bloc<StaffMenuEvents, StaffMenuStates> {
  final StaffMenuRepository _menuRepository;

  StaffMenuBloc(StaffMenuStates initialState, this._menuRepository)
      : super(initialState);

  @override
  Stream<StaffMenuStates> mapEventToState(StaffMenuEvents event) async* {
    yield StaffMenuLoading();
    if (event is FilterMenuItems) {
      final DMTaskState result = await _menuRepository.getMenuItems(menuFilterType: event.menuFilterType);
      if (result.isTaskSuccess) {
        yield StaffMenuSuccess(result.taskResultData);
      } else {
        yield StaffMenuError(result.error);
      }
    }
  }
}  
```  
# modules\staff\menu\menu_screen\bloc\staff_menu_screen_events.dart  
```dart
import 'package:DigiMess/modules/staff/menu/menu_screen/data/util/staff_menu_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEvents extends Equatable {
  const StaffMenuEvents();
}

class FilterMenuItems extends StaffMenuEvents {
  final MenuFilterType menuFilterType;

  FilterMenuItems({this.menuFilterType = MenuFilterType.BOTH});

  @override
  List<Object> get props => [this.menuFilterType];
}  
```  
# modules\staff\menu\menu_screen\bloc\staff_menu_screen_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuStates extends Equatable {
  const StaffMenuStates();
}

class StaffMenuLoading extends StaffMenuStates {
  @override
  List<Object> get props => [];
}

class StaffMenuIdle extends StaffMenuStates {
  @override
  List<Object> get props => [];
}

class StaffMenuError extends StaffMenuStates {
  final DMError error;

  StaffMenuError(this.error);

  @override
  List<Object> get props => [error];
}

class StaffMenuSuccess extends StaffMenuStates {
  final List<MenuItem> menuItems;

  StaffMenuSuccess(this.menuItems);

  @override
  List<Object> get props => [menuItems];
}
  
```  
# modules\staff\menu\menu_screen\data\staff_menu_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/data/util/staff_menu_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMenuRepository {
  final CollectionReference _menuClient;

  StaffMenuRepository(this._menuClient);

  Future<DMTaskState> getMenuItems(
      {MenuFilterType menuFilterType = MenuFilterType.BOTH}) async {
    try {
      Query query;
      if (menuFilterType == MenuFilterType.BOTH) {
        query = _menuClient;
      } else {
        query = _menuClient
            .where("isVeg", isEqualTo: menuFilterType == MenuFilterType.VEG);
      }
      return await query.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
        data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: menuList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}  
```  
# modules\staff\menu\menu_screen\data\util\staff_menu_filter_type.dart  
```dart
enum MenuFilterType { VEG, NONVEG, BOTH}

extension FilterExtension on MenuFilterType{
  String toStringValue() {
    return this.toString().split('.').last;
  }
}  
```  
# modules\staff\menu\menu_screen\ui\screens\staff_menu_screen.dart  
```dart
import 'dart:async';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/data/util/staff_menu_filter_type.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/widgets/staff_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffMenuScreen extends StatefulWidget {
  @override
  _StaffMenuScreenState createState() => _StaffMenuScreenState();
}

class _StaffMenuScreenState extends State<StaffMenuScreen> {
  List<MenuItem> currentList = [];
  List<MenuItem> fullList = [];
  bool _isLoading = false;
  StaffMenuBloc _bloc;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController(text: "");
  MenuFilterType currentFilter = MenuFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffMenuBloc, StaffMenuStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffMenuLoading;
          });
          if (state is StaffMenuSuccess) {
            setState(() {
              fullList = state.menuItems;
              currentList = fullList;
            });
          } else if (state is StaffMenuError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffMenuBloc>(context);
          if (state is StaffMenuIdle) {
            _bloc.add(FilterMenuItems());
            return Container();
          } else if (state is StaffMenuLoading) {
            return Container();
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: DMColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DMColors.blueBg,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Search food item",
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintStyle: DMTypo.bold16MutedTextStyle,
                                prefixIcon: Container(
                                    child: Icon(Icons.search,
                                        color: DMColors.primaryBlue,
                                        size: 20))),
                            maxLines: 1,
                            style: DMTypo.bold16BlackTextStyle,
                            keyboardType: TextInputType.text,
                            controller: _searchController,
                            onChanged: onSearch,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          child: DMFilterMenu(
                            icon: Icon(Icons.filter_list,
                                color: DMColors.primaryBlue, size: 20),
                            selectedValue: selectedFilterIndex,
                            listOfValuesAndItems: [
                              MapEntry(0, "show veg only"),
                              MapEntry(1, "show non-veg only"),
                              MapEntry(2, "show all"),
                            ],
                            onChanged: filterBySelected,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: getListViewOrEmptyHint(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void onSearch(String value) {
    searchQuery = value;
    if (searchDebounceTimer != null) {
      searchDebounceTimer.cancel();
    }
    searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
      final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      setState(() {
        if (searchQuery.trim().isEmpty) {
          _searchController.text = "";
          currentList = fullList;
        } else {
          currentList = fullList
              .where((element) => element.name
                  .trim()
                  .toLowerCase()
                  .contains(searchQuery.trim().toLowerCase()))
              .toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    _searchController.text = "";
    if (value == 0) {
      currentFilter = MenuFilterType.VEG;
    } else if (value == 1) {
      currentFilter = MenuFilterType.NONVEG;
    } else {
      currentFilter = MenuFilterType.BOTH;
    }
    _bloc.add(FilterMenuItems(menuFilterType: currentFilter));
  }

  Widget getListViewOrEmptyHint() {
    if (currentList.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No items for the selected search and filter found.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (_, int index) {
            return StaffMenuCard(
              item: currentList[index],
              onSuccess: onSuccess,
            );
          },
        ),
      );
    }
  }

  void onSuccess() {
    _bloc.add(FilterMenuItems(menuFilterType: currentFilter));
  }
}
  
```  
# modules\staff\menu\menu_screen\ui\util\staff_menu_edit_arguments.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';

class StaffMenuEditArguments {
  final MenuItem item;
  final VoidCallback onSuccess;

  StaffMenuEditArguments(this.item, this.onSuccess);
}
  
```  
# modules\staff\menu\menu_screen\ui\widgets\staff_menu_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/util/staff_menu_edit_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StaffMenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onSuccess;

  const StaffMenuCard({Key key, this.item, this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.STAFF_MENU_EDIT_SCREEN,
            arguments: StaffMenuEditArguments(item, onSuccess));
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
            color: DMColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 4))
            ]),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 65,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(item.imageUrl), fit: BoxFit.cover)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(item.name,
                            style: DMTypo.bold12BlackTextStyle)),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: SvgPicture.asset(item.isVeg
                            ? "assets/icons/veg_icon.svg"
                            : "assets/icons/non_veg_icon.svg")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\staff\notices\bloc\notices_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/data/notices_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffNoticesBloc extends Bloc<StaffNoticesEvents, StaffNoticesStates> {
  final StaffNoticesRepository _noticesRepository;

  StaffNoticesBloc(StaffNoticesStates initialState, this._noticesRepository) : super(initialState);

  @override
  Stream<StaffNoticesStates> mapEventToState(StaffNoticesEvents event) async* {
    yield NoticesLoading();
    if (event is GetAllNotices) {
      final DMTaskState result = await _noticesRepository.getAllNotices();
      if (result.isTaskSuccess) {
        yield NoticesFetchSuccess(result.taskResultData);
      } else {
        yield NoticesError(result.error);
      }
    } else if (event is PlaceNotice) {
      final DMTaskState result = await _noticesRepository.placeNotice(event.title);
      if (result.isTaskSuccess) {
        yield PlaceNoticesSuccess();
      } else {
        yield NoticesError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\notices\bloc\notices_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffNoticesEvents extends Equatable {
  const StaffNoticesEvents();
}

class GetAllNotices extends StaffNoticesEvents {
  @override
  List<Object> get props => [];
}

class PlaceNotice extends StaffNoticesEvents {
  final String title;

  PlaceNotice(this.title);

  @override
  List<Object> get props => [title];
}
  
```  
# modules\staff\notices\bloc\notices_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffNoticesStates extends Equatable {
  const StaffNoticesStates();
}

class NoticesIdle extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class NoticesLoading extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class PlaceNoticesSuccess extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class NoticesFetchSuccess extends StaffNoticesStates {
  final List<Notice> listOfNotices;

  NoticesFetchSuccess(this.listOfNotices);

  @override
  List<Object> get props => [listOfNotices];
}

class NoticesError extends StaffNoticesStates {
  final DMError error;

  NoticesError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\notices\data\notices_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffNoticesRepository {
  final CollectionReference _noticesClient;

  StaffNoticesRepository(this._noticesClient);

  Future<DMTaskState> getAllNotices() async {
    try {
      return await _noticesClient.orderBy('date', descending: true).get().then((value) async {
        final data = value.docs;
        final List<Notice> noticesList = data.map((e) => Notice.fromDocument(e)).toList();
        print(noticesList);
        return DMTaskState(isTaskSuccess: true, taskResultData: noticesList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> placeNotice(String title) async {
    try {
      return await _noticesClient
          .add(Notice(title: title, date: DateTime.now(), noticeId: "").toMap())
          .then((value) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\notices\ui\screens\add_notice_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffAddNoticeScreen extends StatefulWidget {
  final VoidCallback callback;

  const StaffAddNoticeScreen({Key key, this.callback}) : super(key: key);

  @override
  _StaffAddNoticeScreenState createState() => _StaffAddNoticeScreenState();
}

class _StaffAddNoticeScreenState extends State<StaffAddNoticeScreen> {
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  StaffNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
        appBarTitleText: "New notice",
        isAppBarRequired: true,
        body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocConsumer<StaffNoticesBloc, StaffNoticesStates>(listener: (context, state) {
            setState(() {
              _isLoading = state is NoticesLoading;
            });
            if (state is NoticesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is PlaceNoticesSuccess) {
              DMSnackBar.show(context, "Notice placed");
              widget.callback();
              Navigator.pop(context);
            }
          }, builder: (context, state) {
            _bloc = BlocProvider.of<StaffNoticesBloc>(context);
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Text(
                      "Add new notice",
                      style: DMTypo.bold16BlackTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 8,
                      controller: _controller,
                      maxLength: 350,
                      decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          isDense: true,
                          counterText: "",
                          fillColor: DMColors.white,
                          hintText: "Type here...",
                          hintStyle: DMTypo.bold16MutedTextStyle),
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        DMPillButton(
                            text: "Post",
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            textStyle: DMTypo.bold18WhiteTextStyle,
                            onPressed: () async {
                              final String notice = _controller.text;
                              if (notice.trim().isEmpty) {
                                DMSnackBar.show(context, "Enter your notice");
                              } else {
                                final choice = await DMAlertDialog.show(
                                    context, "Do you want to post this notice?");
                                if (choice) {
                                  _bloc.add(PlaceNotice(notice));
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
  
```  
# modules\staff\notices\ui\screens\notices_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/staff/notices/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/staff/notices/ui/widgets/notice_wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffNoticesScreen extends StatefulWidget {
  const StaffNoticesScreen({Key key}) : super(key: key);

  @override
  _StaffNoticesScreenState createState() => _StaffNoticesScreenState();
}

class _StaffNoticesScreenState extends State<StaffNoticesScreen> {
  bool _isLoading = false;
  List<Notice> listOfNotices = [];
  StaffNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StaffNoticesWrapper(
      onNoticePlaced: onNoticePlaced,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffNoticesBloc, StaffNoticesStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is NoticesLoading;
            });

            if (state is NoticesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is NoticesFetchSuccess) {
              setState(() {
                listOfNotices = state.listOfNotices;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffNoticesBloc>(context);
            if (state is NoticesIdle) {
              _bloc.add(GetAllNotices());
              return Container();
            } else if (state is NoticesLoading) {
              return Container();
            } else {
              return Container(child: getListOrEmptyHint());
            }
          },
        ),
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfNotices == null || listOfNotices.isEmpty) {
      return Center(
        child: Text("No notices raised yet.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: listOfNotices.length,
          itemBuilder: (context, index) {
            return NoticeCard(notice: listOfNotices[index]);
          });
    }
  }

  void onNoticePlaced() {
    if (_bloc != null) {
      _bloc.add(GetAllNotices());
    }
  }
}
  
```  
# modules\staff\notices\ui\widgets\notice_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;

  const NoticeCard({Key key, this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20).copyWith(top: 0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: Text(notice.title ?? "Notice", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(getDate(), style: DMTypo.bold12MutedTextStyle))
        ],
      ),
    );
  }

  String getDate() {
    if (notice == null || notice.date == null) {
      return "Date unavailable";
    } else {
      final DateFormat format = DateFormat("d MMM yyyy");
      return format.format(notice.date);
    }
  }
}
  
```  
# modules\staff\notices\ui\widgets\notice_wrapper_widget.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:flutter/material.dart';

class StaffNoticesWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onNoticePlaced;

  const StaffNoticesWrapper({Key key, this.child, this.onNoticePlaced}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.STAFF_ADD_NOTICE_SCREEN,
                    arguments: onNoticePlaced);
              },
              backgroundColor: DMColors.darkBlue,
              child: Icon(Icons.add, color: DMColors.white)))
    ]);
  }
}
  
```  
# modules\staff\students\all_students\bloc\all_students_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_events.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/all_students_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllStudentsBloc extends Bloc<AllStudentsEvents, AllStudentsStates> {
  final AllStudentsRepository _allStudentsRepository;

  AllStudentsBloc(AllStudentsStates initialState, this._allStudentsRepository)
      : super(initialState);

  @override
  Stream<AllStudentsStates> mapEventToState(AllStudentsEvents event) async* {
    yield AllStudentsLoading();
    if (event is GetAllStudents) {
      final DMTaskState result =
          await _allStudentsRepository.getAllStudents(studentFilterType: event.studentFilterType);
      if (result.isTaskSuccess) {
        yield AllStudentsSuccess(result.taskResultData);
      } else {
        yield AllStudentsError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\students\all_students\bloc\all_students_events.dart  
```dart
import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class AllStudentsEvents extends Equatable {
  const AllStudentsEvents();
}

class GetAllStudents extends AllStudentsEvents {
  final StudentFilterType studentFilterType;

  GetAllStudents({this.studentFilterType = StudentFilterType.BOTH});

  @override
  List<Object> get props => [studentFilterType];
}
  
```  
# modules\staff\students\all_students\bloc\all_students_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class AllStudentsStates extends Equatable {
  const AllStudentsStates();
}

class AllStudentsIdle extends AllStudentsStates {
  @override
  List<Object> get props => [];
}

class AllStudentsLoading extends AllStudentsStates {
  @override
  List<Object> get props => [];
}

class AllStudentsSuccess extends AllStudentsStates {
  final List<User> listOfUsers;

  AllStudentsSuccess(this.listOfUsers);

  @override
  List<Object> get props => [listOfUsers];
}

class AllStudentsError extends AllStudentsStates {
  final DMError error;

  AllStudentsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\students\all_students\data\all_students_repository.dart  
```dart
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllStudentsRepository {
  final CollectionReference _usersClient;

  AllStudentsRepository(this._usersClient);

  Future<DMTaskState> getAllStudents(
      {StudentFilterType studentFilterType = StudentFilterType.BOTH}) async {
    try {
      Query query;
      if (studentFilterType == StudentFilterType.BOTH) {
        query = _usersClient.where('type', isEqualTo: UserType.STUDENT.toStringValue());
      } else {
        query = _usersClient
            .where('type', isEqualTo: UserType.STUDENT.toStringValue())
            .where("details.isVeg", isEqualTo: studentFilterType == StudentFilterType.VEG);
      }
      return await query.get().then((value) {
        final data = value.docs;
        final List<User> studentsList = data.map((e) => User.fromDocument(e)).toList();
        print(studentsList);
        return DMTaskState(isTaskSuccess: true, taskResultData: studentsList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\students\all_students\data\util\student_filter_type.dart  
```dart
enum StudentFilterType { VEG, NONVEG, BOTH }

extension FilterExtension on StudentFilterType {
  String toStringValue() {
    return this.toString().split('.').last;
  }
}
  
```  
# modules\staff\students\all_students\ui\screens\students_screen.dart  
```dart
import 'dart:async';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_bloc.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_events.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:DigiMess/modules/staff/students/all_students/ui/widgets/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AllStudentsScreen extends StatefulWidget {
  @override
  _AllStudentsScreenState createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  List<User> currentList = [];
  List<User> fullList = [];
  bool _isLoading = false;
  AllStudentsBloc _bloc;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController(text: "");
  StudentFilterType currentFilter = StudentFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<AllStudentsBloc, AllStudentsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AllStudentsLoading;
          });
          if (state is AllStudentsSuccess) {
            setState(() {
              fullList = state.listOfUsers;
              currentList = fullList;
            });
          } else if (state is AllStudentsError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<AllStudentsBloc>(context);
          if (state is AllStudentsIdle) {
            _bloc.add(GetAllStudents());
            return Container();
          } else if (state is AllStudentsLoading) {
            return Container();
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: DMColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DMColors.blueBg,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Search student",
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintStyle: DMTypo.bold16MutedTextStyle,
                                prefixIcon: Container(
                                    child:
                                        Icon(Icons.search, color: DMColors.primaryBlue, size: 20))),
                            maxLines: 1,
                            style: DMTypo.bold16BlackTextStyle,
                            keyboardType: TextInputType.text,
                            controller: _searchController,
                            onChanged: onSearch,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          child: DMFilterMenu(
                            icon: Icon(Icons.filter_list, color: DMColors.primaryBlue, size: 20),
                            selectedValue: selectedFilterIndex,
                            listOfValuesAndItems: [
                              MapEntry(0, "show veg only"),
                              MapEntry(1, "show non-veg only"),
                              MapEntry(2, "show all"),
                            ],
                            onChanged: filterBySelected,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: getListViewOrEmptyHint(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void onSearch(String value) {
    searchQuery = value;
    if (searchDebounceTimer != null) {
      searchDebounceTimer.cancel();
    }
    searchDebounceTimer = Timer(Duration(milliseconds: 800), () {
      final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      setState(() {
        if (searchQuery.trim().isEmpty) {
          _searchController.text = "";
          currentList = fullList;
        } else {
          currentList = fullList.where((element) {
            return element.name.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.username.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.email.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.phoneNumber
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.trim().toLowerCase());
          }).toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    _searchController.text = "";
    if (value == 0) {
      currentFilter = StudentFilterType.VEG;
    } else if (value == 1) {
      currentFilter = StudentFilterType.NONVEG;
    } else {
      currentFilter = StudentFilterType.BOTH;
    }
    _bloc.add(GetAllStudents(studentFilterType: currentFilter));
  }

  Widget getListViewOrEmptyHint() {
    if (currentList.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No student for the selected search and filter found.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (_, int index) {
            return StudentCard(
                item: currentList[index],
                onItemClickCallback: (user) {
                  Navigator.pushNamed(context, Routes.STUDENT_DETAILS_SCREEN, arguments: user);
                });
          },
        ),
      );
    }
  }
}
  
```  
# modules\staff\students\all_students\ui\widgets\student_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final User item;
  final Function(User) onItemClickCallback;

  const StudentCard({Key key, this.item, this.onItemClickCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: DMColors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () => onItemClickCallback(item),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:
                            Text(getStudentNameAndUsername(), style: DMTypo.bold14BlackTextStyle))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: DMColors.lightBlue, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      Text("More", style: DMTypo.bold12BlackTextStyle),
                      Icon(Icons.arrow_forward_ios, color: DMColors.darkBlue, size: 10)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getStudentNameAndUsername() {
    if (item == null || item.name == null || item.username == null) {
      return "N/A";
    } else {
      return "${item.username} - ${item.name}";
    }
  }
}
  
```  
# modules\staff\students\complaint_history\bloc\complaints_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffComplaintsBloc extends Bloc<StaffComplaintsEvents, StaffComplaintsStates> {
  final StaffComplaintsRepository _complaintsRepository;

  StaffComplaintsBloc(StaffComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StaffComplaintsStates> mapEventToState(StaffComplaintsEvents event) async* {
    yield StaffComplaintsLoading();
    if (event is GetAllComplaints) {
      final DMTaskState result = await _complaintsRepository.getAllComplaints(event.userId);
      if (result.isTaskSuccess) {
        yield StaffComplaintsSuccess(result.taskResultData);
      } else {
        yield StaffComplaintsError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\students\complaint_history\bloc\complaints_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsEvents extends Equatable {
  const StaffComplaintsEvents();
}

class GetAllComplaints extends StaffComplaintsEvents {
  final String userId;

  GetAllComplaints(this.userId);

  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\students\complaint_history\bloc\complaints_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsStates extends Equatable {
  const StaffComplaintsStates();
}

class StaffComplaintsIdle extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class StaffComplaintsLoading extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class StaffComplaintsSuccess extends StaffComplaintsStates {
  final List<Complaint> listOfComplaints;

  StaffComplaintsSuccess(this.listOfComplaints);

  @override
  List<Object> get props => [listOfComplaints];
}

class StaffComplaintsError extends StaffComplaintsStates {
  final DMError error;

  StaffComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\students\complaint_history\data\complaints_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffComplaintsRepository {
  final CollectionReference _complaintsClient;

  StaffComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> getAllComplaints(String userId) async {
    try {
      final DocumentReference user = FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _complaintsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Complaint> complaintList = data.map((e) => Complaint.fromDocument(e)).toList();
        print(complaintList);
        return DMTaskState(isTaskSuccess: true, taskResultData: complaintList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\students\complaint_history\ui\screens\complaints_history.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_events.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/students/complaint_history/ui/widgets/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffComplaintsHistoryScreen extends StatefulWidget {
  final User user;

  const StaffComplaintsHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffComplaintsHistoryScreenState createState() => _StaffComplaintsHistoryScreenState();
}

class _StaffComplaintsHistoryScreenState extends State<StaffComplaintsHistoryScreen> {
  bool _isLoading = false;
  List<Complaint> listOfComplaints = [];
  StaffComplaintsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Complaints",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffComplaintsBloc, StaffComplaintsStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffComplaintsLoading;
            });

            if (state is StaffComplaintsError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffComplaintsSuccess) {
              setState(() {
                listOfComplaints = state.listOfComplaints;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffComplaintsBloc>(context);
            if (state is StaffComplaintsIdle) {
              _bloc.add(GetAllComplaints(widget.user.userId));
              return Container();
            } else if (state is StaffComplaintsLoading) {
              return Container();
            } else {
              return Container(child: getListOrEmptyHint());
            }
          },
        ),
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfComplaints == null || listOfComplaints.isEmpty) {
      return Center(
        child: Text("No complaints done so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: listOfComplaints.length,
          itemBuilder: (context, index) {
            return ComplaintsCard(complaint: listOfComplaints[index]);
          });
    }
  }
}
  
```  
# modules\staff\students\complaint_history\ui\widgets\complaints_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintsCard({Key key, this.complaint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Categories", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(getCategories(), style: DMTypo.normal14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Others", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(getTitle(), style: DMTypo.normal14BlackTextStyle)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text("Posted on", style: DMTypo.bold14BlackTextStyle),
              ),
              Text(getDate(), style: DMTypo.normal12BlackTextStyle),
            ],
          )
        ],
      ),
    );
  }

  String getDate() {
    if (complaint.date != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(complaint.date);
    } else {
      return "N/A";
    }
  }

  String getTitle() {
    if (complaint.complaint != null) {
      return complaint.complaint.capitalizeFirst();
    } else {
      return "N/A";
    }
  }

  String getCategories() {
    if (complaint.categories != null && complaint.categories.isNotEmpty) {
      return complaint.categories.map((e) => e.capitalizeFirst()).join(", ");
    } else {
      return "N/A";
    }
  }
}
  
```  
# modules\staff\students\leaves_history\bloc\staff_leaves_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leave_events.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/data/staff_leaves_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffStudentLeavesBloc extends Bloc<StaffStudentLeavesEvents, StaffStudentLeavesStates> {
  final StaffStudentLeavesRepository _leavesRepository;

  StaffStudentLeavesBloc(StaffStudentLeavesStates initialState, this._leavesRepository)
      : super(initialState);

  @override
  Stream<StaffStudentLeavesStates> mapEventToState(StaffStudentLeavesEvents event) async* {
    yield StaffLeavesLoading();
    if (event is GetAllLeaves) {
      final DMTaskState result = await _leavesRepository.getAllLeaves(event.userId);
      if (result.isTaskSuccess) {
        yield StaffLeavesSuccess(result.taskResultData);
      } else {
        yield StaffLeavesError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\students\leaves_history\bloc\staff_leaves_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffStudentLeavesStates extends Equatable {
  const StaffStudentLeavesStates();
}

class StaffLeavesIdle extends StaffStudentLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesLoading extends StaffStudentLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesSuccess extends StaffStudentLeavesStates {
  final List<LeaveEntry> listOfLeaves;

  StaffLeavesSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StaffLeavesError extends StaffStudentLeavesStates {
  final DMError error;

  StaffLeavesError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\students\leaves_history\bloc\staff_leave_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffStudentLeavesEvents extends Equatable {
  const StaffStudentLeavesEvents();
}

class GetAllLeaves extends StaffStudentLeavesEvents {
  final String userId;

  GetAllLeaves(this.userId);

  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\students\leaves_history\data\staff_leaves_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffStudentLeavesRepository {
  final CollectionReference _leavesRepository;

  StaffStudentLeavesRepository(this._leavesRepository);

  Future<DMTaskState> getAllLeaves(String userId) async {
    try {
      final DocumentReference user = FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _leavesRepository
          .where('userId', isEqualTo: user)
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList = data.map((e) => LeaveEntry.fromDocument(e)).toList();
        print(leavesList);
        return DMTaskState(isTaskSuccess: true, taskResultData: leavesList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\students\leaves_history\ui\screens\leave_history_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leave_events.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_bloc.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/bloc/staff_leaves_states.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/widgets/leave_card.dart';
import 'package:DigiMess/modules/staff/students/leaves_history/ui/widgets/ongoing_leave_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffStudentLeavesHistoryScreen extends StatefulWidget {
  final User user;

  const StaffStudentLeavesHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffStudentLeavesHistoryScreenState createState() => _StaffStudentLeavesHistoryScreenState();
}

class _StaffStudentLeavesHistoryScreenState extends State<StaffStudentLeavesHistoryScreen> {
  bool _isLoading = false;
  List<LeaveEntry> listOfLeaves = [];
  bool _isLeaveOngoing = false;
  StaffStudentLeavesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Leaves taken",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffStudentLeavesBloc, StaffStudentLeavesStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffLeavesLoading;
            });

            if (state is StaffLeavesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffLeavesSuccess) {
              setState(() {
                listOfLeaves = state.listOfLeaves;
                final DateTime now = DateTime.now();
                _isLeaveOngoing = listOfLeaves.isNotEmpty &&
                    ((listOfLeaves.first.startDate.compareTo(now) <= 0 &&
                            listOfLeaves.first.endDate
                                    .copyWith(day: listOfLeaves.first.endDate.day + 1)
                                    .compareTo(now) >=
                                0) ||
                        listOfLeaves.first.startDate.isAfter(now));
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffStudentLeavesBloc>(context);
            if (state is StaffLeavesIdle) {
              _bloc.add(GetAllLeaves(widget.user.userId));
              return Container();
            } else if (state is StaffLeavesLoading) {
              return Container();
            } else {
              return Container(child: getListOrEmptyHint());
            }
          },
        ),
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfLeaves == null || listOfLeaves.isEmpty) {
      return Center(
        child: Text("No leaves taken so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isLeaveOngoing,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Ongoing leave", style: DMTypo.bold16BlackTextStyle)),
                  OngoingLeaveCard(leave: listOfLeaves.first)
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              child: Text("Previous leaves", style: DMTypo.bold16BlackTextStyle)),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                itemCount: listOfLeaves.length - (_isLeaveOngoing ? 1 : 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return LeaveCard(leave: listOfLeaves[index + (_isLeaveOngoing ? 1 : 0)]);
                }),
          )
        ],
      );
    }
  }
}
  
```  
# modules\staff\students\leaves_history\ui\widgets\leave_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final LeaveEntry leave;

  const LeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(getDuration(), style: DMTypo.bold36BlackTextStyle),
          Text(getDayHint(), style: DMTypo.bold18BlackTextStyle),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(child: Text("From", style: DMTypo.bold14BlackTextStyle)),
                  Expanded(
                    child: Text(getStartDate(), style: DMTypo.bold12MutedTextStyle),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(child: Text("To", style: DMTypo.bold14BlackTextStyle)),
                  Expanded(child: Text(getEndDate(), style: DMTypo.bold12MutedTextStyle))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getDuration() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs().toString();
    }
  }

  String getStartDate() {
    if (leave.startDate != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(leave.startDate);
    } else {
      return "N/A";
    }
  }

  String getEndDate() {
    if (leave.endDate != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(leave.endDate);
    } else {
      return "N/A";
    }
  }

  String getDayHint() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs() == 1 ? "day" : "days";
    }
  }
}
  
```  
# modules\staff\students\leaves_history\ui\widgets\ongoing_leave_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OngoingLeaveCard extends StatelessWidget {
  final LeaveEntry leave;

  const OngoingLeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            children: [
              Text("From", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getStartDate(), style: DMTypo.normal14BlackTextStyle))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Text("To", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getEndDate(), style: DMTypo.normal14BlackTextStyle))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Text("Duration", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getDuration(), style: DMTypo.normal14BlackTextStyle))
            ],
          ))
        ],
      ),
    );
  }

  String getStartDate() {
    if (leave.startDate != null) {
      final DateFormat format = DateFormat("MMMM d");
      return format.format(leave.startDate);
    } else {
      return "N/A";
    }
  }

  String getEndDate() {
    if (leave.endDate != null) {
      final DateFormat format = DateFormat("MMMM d");
      return format.format(leave.endDate);
    } else {
      return "N/A";
    }
  }

  String getDuration() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs().toString();
    }
  }
}
  
```  
# modules\staff\students\payment_history\bloc\payments_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/data/payments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPaymentsBloc extends Bloc<StaffPaymentsEvents, StaffPaymentsStates> {
  final StaffPaymentsRepository _paymentsRepository;

  StaffPaymentsBloc(StaffPaymentsStates initialState, this._paymentsRepository)
      : super(initialState);

  @override
  Stream<StaffPaymentsStates> mapEventToState(StaffPaymentsEvents event) async* {
    yield StaffPaymentsLoading();
    if (event is GetAllPayments) {
      final DMTaskState result = await _paymentsRepository.getAllPayments(event.userId);
      if (result.isTaskSuccess) {
        yield StaffPaymentsSuccess(result.taskResultData);
      } else {
        yield StaffPaymentsError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\students\payment_history\bloc\payments_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StaffPaymentsEvents extends Equatable {
  const StaffPaymentsEvents();
}

class GetAllPayments extends StaffPaymentsEvents {
  final String userId;

  GetAllPayments(this.userId);

  @override
  List<Object> get props => [];
}
  
```  
# modules\staff\students\payment_history\bloc\payments_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffPaymentsStates extends Equatable {
  const StaffPaymentsStates();
}

class StaffPaymentsIdle extends StaffPaymentsStates {
  @override
  List<Object> get props => [];
}

class StaffPaymentsLoading extends StaffPaymentsStates {
  @override
  List<Object> get props => [];
}

class StaffPaymentsSuccess extends StaffPaymentsStates {
  final List<Payment> listOfPayments;

  StaffPaymentsSuccess(this.listOfPayments);

  @override
  List<Object> get props => [listOfPayments];
}

class StaffPaymentsError extends StaffPaymentsStates {
  final DMError error;

  StaffPaymentsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\students\payment_history\data\payments_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffPaymentsRepository {
  final CollectionReference _paymentsClient;

  StaffPaymentsRepository(this._paymentsClient);

  Future<DMTaskState> getAllPayments(String userId) async {
    try {
      final DocumentReference user = FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _paymentsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Payment> paymentsList = data.map((e) => Payment.fromDocument(e)).toList();
        print(paymentsList);
        return DMTaskState(isTaskSuccess: true, taskResultData: paymentsList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\students\payment_history\ui\screens\payment_history_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/staff/students/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/staff/students/payment_history/ui/widgets/payments_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffPaymentHistoryScreen extends StatefulWidget {
  final User user;

  const StaffPaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _StaffPaymentHistoryScreenState createState() => _StaffPaymentHistoryScreenState();
}

class _StaffPaymentHistoryScreenState extends State<StaffPaymentHistoryScreen> {
  bool _isLoading = false;
  List<Payment> listOfPayments = [];
  StaffPaymentsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Payment history",
      isAppBarRequired: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: BlocConsumer<StaffPaymentsBloc, StaffPaymentsStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StaffPaymentsLoading;
            });

            if (state is StaffPaymentsError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StaffPaymentsSuccess) {
              setState(() {
                listOfPayments = state.listOfPayments;
              });
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StaffPaymentsBloc>(context);
            if (state is StaffPaymentsIdle) {
              _bloc.add(GetAllPayments(widget.user.userId));
              return Container();
            } else if (state is StaffPaymentsLoading) {
              return Container();
            } else {
              return Container(child: getListOrEmptyHint());
            }
          },
        ),
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfPayments == null || listOfPayments.isEmpty) {
      return Center(
        child: Text("No payments done so far.", style: DMTypo.bold14MutedTextStyle),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: listOfPayments.length,
          itemBuilder: (context, index) {
            return PaymentsCard(payment: listOfPayments[index]);
          });
    }
  }
}
  
```  
# modules\staff\students\payment_history\ui\widgets\payments_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentsCard extends StatelessWidget {
  final Payment payment;

  const PaymentsCard({Key key, this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.circle,
                        color: DMColors.green,
                        size: 15,
                      ),
                    ),
                    Text("Paid on", style: DMTypo.bold14BlackTextStyle),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Text(getDate(), style: DMTypo.bold12MutedTextStyle)),
                Container(
                    margin: EdgeInsets.only(top: 30, left: 25),
                    child: Text(payment.description, style: DMTypo.bold12BlackTextStyle))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(getCurrency(), style: DMTypo.bold18GreenTextStyle))
        ],
      ),
    );
  }

  String getDate() {
    if (payment != null && payment.paymentDate != null) {
      return DateFormat("MMM d yyyy").format(payment.paymentDate);
    } else {
      return "Invalid date";
    }
  }

  String getCurrency() {
    if (payment != null && payment.paymentAmount != null) {
      return payment.paymentAmount.getFormattedCurrency();
    } else {
      return "Invalid amount";
    }
  }
}
  
```  
# modules\staff\students\student_details\bloc\student_details_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_events.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/data/student_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsBloc extends Bloc<StudentDetailsEvents, StudentDetailsStates> {
  final StudentDetailsRepository _studentDetailsRepository;

  StudentDetailsBloc(StudentDetailsStates initialState, this._studentDetailsRepository)
      : super(initialState);

  @override
  Stream<StudentDetailsStates> mapEventToState(StudentDetailsEvents event) async* {
    yield StudentDetailsLoading();
    if (event is DisableStudent) {
      final DMTaskState result =
          await _studentDetailsRepository.toggleUserStatus(event.userId, event.isDisabled);
      if (result.isTaskSuccess) {
        yield StudentDetailsDisableSuccess();
      } else {
        yield StudentDetailsError(result.error);
      }
    }
  }
}
  
```  
# modules\staff\students\student_details\bloc\student_details_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StudentDetailsEvents extends Equatable {
  const StudentDetailsEvents();
}

class DisableStudent extends StudentDetailsEvents {
  final String userId;

  final bool isDisabled;

  DisableStudent(this.userId, this.isDisabled);

  @override
  List<Object> get props => [userId];
}
  
```  
# modules\staff\students\student_details\bloc\student_details_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentDetailsStates extends Equatable {
  const StudentDetailsStates();
}

class StudentDetailsIdle extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsLoading extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsDisableSuccess extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsError extends StudentDetailsStates {
  final DMError error;

  StudentDetailsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\staff\students\student_details\data\student_details_repository.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailsRepository {
  final CollectionReference _usersClient;

  StudentDetailsRepository(this._usersClient);

  Future<DMTaskState> toggleUserStatus(String userId, bool isDisabled) async {
    try {
      return await _usersClient.doc(userId).update({'isEnrolled': isDisabled}).then((_) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\staff\students\student_details\ui\screens\student_details_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_bloc.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_events.dart';
import 'package:DigiMess/modules/staff/students/student_details/bloc/student_details_states.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/widgets/student_details_bg.dart';
import 'package:DigiMess/modules/staff/students/student_details/ui/widgets/student_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentDetailsScreen extends StatefulWidget {
  final User user;

  const StudentDetailsScreen({Key key, this.user}) : super(key: key);

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  bool _isLoading = false;
  bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.user.isEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      appBarTitleText: "Student details",
      isAppBarRequired: true,
      body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocListener<StudentDetailsBloc, StudentDetailsStates>(
              listener: (context, state) {
                setState(() {
                  _isLoading = state is StudentDetailsLoading;
                });

                if (state is StudentDetailsError) {
                  DMSnackBar.show(context, state.error.message);
                } else if (state is StudentDetailsDisableSuccess) {
                  setState(() {
                    _isEnabled = !_isEnabled;
                  });
                }
              },
              child: StudentDetailsScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StudentDetailsCard(userDetails: widget.user),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(color: DMColors.white, boxShadow: [
                          BoxShadow(
                              color: DMColors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, -4))
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.STUDENT_PAYMENT_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                child: Text("Show payment history",
                                    style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.STUDENT_COMPLAINT_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text("Complaints registered",
                                    style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.STUDENT_LEAVES_HISTORY_SCREEN,
                                    arguments: widget.user);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text("Leaves taken", style: DMTypo.bold16BlackTextStyle),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 30),
                                          child: Text("Account status",
                                              style: DMTypo.bold16BlackTextStyle)),
                                      Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(_isEnabled ? "Enabled" : "Disabled",
                                              style: DMTypo.normal14MutedTextStyle))
                                    ])),
                                Switch(
                                    value: _isEnabled,
                                    activeColor: DMColors.primaryBlue,
                                    onChanged: (value) async {
                                      final bool choice = await DMAlertDialog.show(context,
                                          "Do you want to ${_isEnabled ? "disable" : "enable"} this account?");
                                      if (choice) {
                                        BlocProvider.of<StudentDetailsBloc>(context)
                                            .add(DisableStudent(widget.user.userId, value));
                                      }
                                    })
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
  
```  
# modules\staff\students\student_details\ui\widgets\student_details_bg.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentDetailsScrollView extends StatelessWidget {
  final Widget child;

  const StudentDetailsScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: DMColors.lightBlue,
          child: SingleChildScrollView(
              child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  child: SvgPicture.asset("assets/icons/home_bg.svg", fit: BoxFit.cover),
                ),
                child,
              ],
            ),
          )),
        );
      },
    );
  }
}
  
```  
# modules\staff\students\student_details\ui\widgets\student_details_card.dart  
```dart
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class StudentDetailsCard extends StatelessWidget {
  final User userDetails;

  const StudentDetailsCard({Key key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
            ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 120),
                    child: Text(userDetails.name,
                        style: DMTypo.bold18BlackTextStyle, textAlign: TextAlign.center)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50).copyWith(top: 10),
                  child: Divider(
                    height: 1,
                    color: DMColors.primaryBlue
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Admission number", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.username,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Email ID", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.email,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Date of Birth", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getDob(),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Batch", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getBatch(),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Phone number", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.phoneNumber,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Food preference", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 5),
                    child: Text((userDetails.isVeg ? "Veg" : "Non-veg"),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
            ], color: DMColors.white, shape: BoxShape.circle),
            child: SvgPicture.asset("assets/icons/profile_circle.svg", height: 150, width: 150),
          )
        ],
      ),
    );
  }

  String getDob() {
    if (userDetails == null || userDetails.dob == null) {
      return "DOB unavailable";
    } else {
      final DateFormat format = DateFormat("d/MM/yyyy");
      return format.format(userDetails.dob);
    }
  }

  String getBatch() {
    if (userDetails == null ||
        userDetails.yearOfAdmission == null ||
        userDetails.yearOfCompletion == null ||
        userDetails.branch == null) {
      return "Batch unavailable";
    } else {
      return "${userDetails.branch.toStringValue()} ${userDetails.yearOfAdmission.year}-${userDetails.yearOfCompletion.year}";
    }
  }
}
  
```  
# modules\student\annual_poll\bloc\annual_poll_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/data/annual_poll_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAnnualPollBloc
    extends Bloc<StudentAnnualPollEvents, StudentAnnualPollStates> {
  final StudentAnnualPollRepository _annualPollRepository;

  StudentAnnualPollBloc(
      StudentAnnualPollStates initialState, this._annualPollRepository)
      : super(initialState);

  @override
  Stream<StudentAnnualPollStates> mapEventToState(
      StudentAnnualPollEvents event) async* {
    yield StudentAnnualPollLoading();
    if (event is GetAllMenuItems) {
      final DMTaskState result = await _annualPollRepository.getAllMenuItems();
      if (result.isTaskSuccess) {
        yield StudentAnnualPollFetchSuccess(result.taskResultData);
      } else {
        yield StudentAnnualPollError(result.error);
      }
    } else if (event is PlaceVote) {
      final DMTaskState result =
          await _annualPollRepository.placeVotes(event.listOfVotes);
      if (result.isTaskSuccess) {
        yield StudentVoteSuccess();
      } else {
        yield StudentAnnualPollError(result.error);
      }
    }
  }
}
  
```  
# modules\student\annual_poll\bloc\annual_poll_events.dart  
```dart
import 'package:DigiMess/common/constants/enums/vote_entry.dart';
import 'package:equatable/equatable.dart';

abstract class StudentAnnualPollEvents extends Equatable {
  const StudentAnnualPollEvents();
}

class GetAllMenuItems extends StudentAnnualPollEvents {
  @override
  List<Object> get props => [];
}

class PlaceVote extends StudentAnnualPollEvents {
  final List<VoteEntry> listOfVotes;

  PlaceVote(this.listOfVotes);

  @override
  List<Object> get props => [listOfVotes];
}
  
```  
# modules\student\annual_poll\bloc\annual_poll_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentAnnualPollStates extends Equatable {
  const StudentAnnualPollStates();
}

class StudentAnnualPollIdle extends StudentAnnualPollStates {
  @override
  List<Object> get props => [];
}

class StudentAnnualPollLoading extends StudentAnnualPollStates {
  @override
  List<Object> get props => [];
}

class StudentAnnualPollFetchSuccess extends StudentAnnualPollStates {
  final List<MenuItem> listOfItems;

  StudentAnnualPollFetchSuccess(this.listOfItems);

  @override
  List<Object> get props => [listOfItems];
}

class StudentVoteSuccess extends StudentAnnualPollStates {
  StudentVoteSuccess();

  @override
  List<Object> get props => [];
}

class StudentAnnualPollError extends StudentAnnualPollStates {
  final DMError error;

  StudentAnnualPollError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\student\annual_poll\data\annual_poll_repository.dart  
```dart
import 'package:DigiMess/common/constants/enums/vote_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAnnualPollRepository {
  final CollectionReference _menuClient;

  StudentAnnualPollRepository(this._menuClient);

  Future<DMTaskState> getAllMenuItems() async {
    try {
      return await _menuClient.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: menuList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> placeVotes(List<VoteEntry> listOfVotes) async {
    try {
      listOfVotes.forEach((vote) {
        final String voteFieldName = vote.menuItemTiming.getFirebaseFieldName();
        return _menuClient.doc(vote.internalMenuId).update({
          "annualPoll.$voteFieldName": FieldValue.increment(1)
        }).onError((error, stackTrace) {
          print(stackTrace.toString());
          return DMTaskState(
              isTaskSuccess: false,
              taskResultData: null,
              error: DMError(message: error.toString()));
        });
      });
      SharedPrefRepository.setLastPollYear(DateTime.now());
      return DMTaskState(
          isTaskSuccess: true, taskResultData: null, error: null);
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\annual_poll\ui\screens\annual_poll_screen.dart  
```dart
import 'package:DigiMess/common/constants/enums/vote_entry.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/poll_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentAnnualPollScreen extends StatefulWidget {
  final VoidCallback onVoteCallback;

  const StudentAnnualPollScreen({Key key, this.onVoteCallback}) : super(key: key);

  @override
  _StudentAnnualPollScreenState createState() => _StudentAnnualPollScreenState();
}

class _StudentAnnualPollScreenState extends State<StudentAnnualPollScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  StudentAnnualPollBloc _bloc;
  List<MenuItem> _listOfFoodItems = [];
  TabController _tabController;
  Set<VoteEntry> listOfSelectedVotes = Set();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
        isAppBarRequired: true,
        appBarTitleText: "Poll",
        tabBar: TabBar(
          indicatorColor: DMColors.white,
          tabs: [
            Tab(text: "Breakfast"),
            Tab(text: "Lunch"),
            Tab(text: "Dinner"),
          ],
          controller: _tabController,
        ),
        body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocConsumer<StudentAnnualPollBloc, StudentAnnualPollStates>(
            listener: (context, state) {
              setState(() {
                _isLoading = state is StudentAnnualPollLoading;
              });

              if (state is StudentAnnualPollError) {
                DMSnackBar.show(context, state.error.message);
              } else if (state is StudentAnnualPollFetchSuccess) {
                setState(() {
                  _listOfFoodItems = state.listOfItems;
                });
              } else if (state is StudentVoteSuccess) {
                widget.onVoteCallback();
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              print(state);
              _bloc = BlocProvider.of<StudentAnnualPollBloc>(context);
              if (state is StudentAnnualPollIdle) {
                _bloc.add(GetAllMenuItems());
                return Container();
              } else if (state is StudentAnnualPollLoading) {
                return Container();
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(VoteEntry(
                                  _listOfFoodItems[index].itemId, MenuItemTiming.BREAKFAST));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.BREAKFAST);
                                },
                                isChosen: isChosen,
                              );
                            }),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(
                                  VoteEntry(_listOfFoodItems[index].itemId, MenuItemTiming.LUNCH));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.LUNCH);
                                },
                                isChosen: isChosen,
                              );
                            }),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(
                                  VoteEntry(_listOfFoodItems[index].itemId, MenuItemTiming.DINNER));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.DINNER);
                                },
                                isChosen: isChosen,
                              );
                            }),
                      ]),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: DMColors.white, boxShadow: [
                        BoxShadow(
                            color: DMColors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, -4))
                      ]),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: DMPillButton(
                            text: "Confirm vote",
                            isEnabled: listOfSelectedVotes.length == 21,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            onPressed: () {
                              print(listOfSelectedVotes);
                              _bloc.add(PlaceVote(listOfSelectedVotes.toList()));
                            },
                            onDisabledPressed: () async {
                              print(listOfSelectedVotes);
                              await Fluttertoast.showToast(msg: "Choose 7 items for each meal");
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ));
  }

  void onItemClick(String itemId, bool isChosen, MenuItemTiming menuItemTiming) {
    setState(() {
      if (isChosen) {
        listOfSelectedVotes.remove(VoteEntry(itemId, menuItemTiming));
      } else {
        final int voteCount = listOfSelectedVotes
            .where((element) => element.menuItemTiming == menuItemTiming)
            .toList()
            .length;
        if (voteCount < 7) {
          listOfSelectedVotes.add(VoteEntry(itemId, menuItemTiming));
        }
      }
    });
  }
}
  
```  
# modules\student\annual_poll\ui\widgets\annual_poll_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';

class StudentAnnualPollCard extends StatefulWidget {
  @override
  _StudentAnnualPollCardState createState() => _StudentAnnualPollCardState();
}

class _StudentAnnualPollCardState extends State<StudentAnnualPollCard> {
  bool showPollCard = false;

  @override
  void initState() {
    super.initState();
    getLastVotedDate();
  }

  void getLastVotedDate() async {
    final DateTime lastVotedYear = await SharedPrefRepository.getLastPollYear();
    final DateTime now = DateTime.now();
    setState(() {
      showPollCard = now.month == 12 && now.difference(lastVotedYear).inDays.abs() > 31;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showPollCard,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 0),
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
        ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Annual Poll", style: DMTypo.bold18BlackTextStyle),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("Vote for next year’s menu", style: DMTypo.bold12MutedTextStyle),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: DMPillButton(
                    text: "Vote here",
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    onPressed: () async {
                      Navigator.pushNamed(context, Routes.ANNUAL_POLL_SCREEN,
                          arguments: onVoteCallback);
                    },
                    textStyle: DMTypo.bold18WhiteTextStyle),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onVoteCallback() {
    setState(() {
      showPollCard = false;
    });
  }
}
  
```  
# modules\student\annual_poll\ui\widgets\poll_item.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PollItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isChosen;
  final Function(String) onClick;

  const PollItemCard({Key key, this.item, this.isChosen, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClick(item.itemId),
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 65,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(item.imageUrl),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: SvgPicture.asset(item.isVeg
                              ? "assets/icons/veg_icon.svg"
                              : "assets/icons/non_veg_icon.svg")),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(item.name,
                                style: DMTypo.bold12BlackTextStyle)),
                      )
                    ],
                  ),
                ),
                isChosen
                    ? Container(
                        child: Icon(
                        Icons.check_circle,
                        color: DMColors.green,
                        size: 24,
                      ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\complaints\bloc\complaints_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/student/complaints/data/complaints_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentComplaintsBloc
    extends Bloc<StudentComplaintsEvents, StudentComplaintsStates> {
  final StudentComplaintsRepository _complaintsRepository;

  StudentComplaintsBloc(
      StudentComplaintsStates initialState, this._complaintsRepository)
      : super(initialState);

  @override
  Stream<StudentComplaintsStates> mapEventToState(
      StudentComplaintsEvents event) async* {
    yield StudentComplaintsLoading();
    if (event is PlaceComplaint) {
      final DMTaskState result = await _complaintsRepository.placeComplaint(
          event.categories, event.complaint);
      if (result.isTaskSuccess) {
        yield StudentComplaintsSuccess();
      } else {
        yield StudentComplaintsError(result.error);
      }
    }
  }
}
  
```  
# modules\student\complaints\bloc\complaints_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StudentComplaintsEvents extends Equatable {
  const StudentComplaintsEvents();
}

class PlaceComplaint extends StudentComplaintsEvents {
  final List<String> categories;
  final String complaint;

  PlaceComplaint(this.categories, this.complaint);

  @override
  List<Object> get props => [this.categories, this.complaint];
}
  
```  
# modules\student\complaints\bloc\complaints_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentComplaintsStates extends Equatable {
  const StudentComplaintsStates();
}

class StudentComplaintsIdle extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}

class StudentComplaintsLoading extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}

class StudentComplaintsError extends StudentComplaintsStates {
  final DMError error;

  StudentComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentComplaintsSuccess extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}
  
```  
# modules\student\complaints\data\complaints_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentComplaintsRepository {
  final CollectionReference _complaintsClient;

  StudentComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> placeComplaint(
      List<String> categories, String complaint) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _complaintsClient
          .add(Complaint(
                  complaint: complaint,
                  categories: categories,
                  date: DateTime.now(),
                  user: user,
                  complaintId: '')
              .toMap())
          .then((value) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\complaints\ui\screens\complaints_screen.dart  
```dart
import 'package:DigiMess/common/constants/enums/complaint_category.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/student/complaints/ui/widgets/filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentComplaintsScreen extends StatefulWidget {
  @override
  _StudentComplaintsScreenState createState() =>
      _StudentComplaintsScreenState();
}

class _StudentComplaintsScreenState extends State<StudentComplaintsScreen> {
  TextEditingController _controller = TextEditingController();
  Set<String> selectedCategories = Set<String>();
  bool _isLoading = false;
  StudentComplaintsBloc _bloc;

  @override
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentComplaintsBloc, StudentComplaintsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentComplaintsLoading;
          });
          if (state is StudentComplaintsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentComplaintsSuccess) {
            DMSnackBar.show(context, "Complaint Placed");
            selectedCategories.clear();
            _controller.text = "";
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentComplaintsBloc>(context);
          if (state is StudentComplaintsLoading) {
            return Container();
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Center(
                      child: Text(
                        "Frequent Complaints",
                        style: DMTypo.bold16BlackTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Divider(
                      thickness: 1,
                      color: DMColors.primaryBlue,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(ComplaintCategory.values.length,
                          (index) {
                        return FilterChips(
                          chipName: ComplaintCategoryExtensions
                              .ComplaintCategoryHints[index],
                          isSelected: selectedCategories.contains(
                              ComplaintCategory.values[index].toStringValue()),
                          onTap: () {
                            setState(() {
                              final String category = ComplaintCategory
                                  .values[index]
                                  .toStringValue();
                              if (selectedCategories.contains(category)) {
                                selectedCategories.remove(category);
                              } else {
                                selectedCategories.add(category);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 8,
                      controller: _controller,
                      maxLength: 350,
                      decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          isDense: true,
                          counterText: "",
                          fillColor: DMColors.white,
                          hintText: "Type your complaint here...",
                          hintStyle: DMTypo.bold16MutedTextStyle),
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        DMPillButton(
                            text: "Submit",
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            textStyle: DMTypo.bold18WhiteTextStyle,
                            onPressed: () {
                              final String complaint = _controller.text;
                              if (complaint.trim().isEmpty) {
                                DMSnackBar.show(
                                    context, "Enter your complaint");
                              } else if (selectedCategories.isEmpty) {
                                DMSnackBar.show(
                                    context, "Choose at least one category");
                              } else {
                                _bloc.add(PlaceComplaint(
                                    selectedCategories.toList(), complaint));
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
  
```  
# modules\student\complaints\ui\widgets\filter_chip.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String chipName;
  final bool isSelected;
  final VoidCallback onTap;

  FilterChips({
    Key key,
    this.chipName,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                offset: Offset(0, 4),
                blurRadius: 4)
          ],
          color: isSelected ? DMColors.primaryBlue : DMColors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              chipName,
              style: isSelected
                  ? DMTypo.bold16WhiteTextStyle
                  : DMTypo.bold16PrimaryBlueTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\help\ui\screens\help_screen.dart  
```dart
import 'package:DigiMess/common/constants/app_faqs.dart';
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/help_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHelpScreen extends StatelessWidget {
  _makingPhoneCall() async {
    const url = 'tel://${DMDetails.staffPhoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
                child: Text("Help centre", style: DMTypo.bold20BlackTextStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30).copyWith(bottom: 0),
              child: InkWell(
                onTap: () => _makingPhoneCall(),
                child: SvgPicture.asset("assets/icons/callbutton.svg",
                    height: 25, color: DMColors.primaryBlue),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30).copyWith(bottom: 0),
          child: Text("FAQs", style: DMTypo.bold18DarkBlueTextStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 0),
            itemCount: DMFaqs.studentFAQs.length,
            itemBuilder: (_, index) {
              return HelpWidget(
                question: DMFaqs.studentFAQs[index].question,
                answer: DMFaqs.studentFAQs[index].answer,
              );
            },
          ),
        )
      ],
    );
  }
}
  
```  
# modules\student\home\bloc\home_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/home/bloc/home_events.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/data/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvents, StudentHomeStates> {
  final StudentHomeRepository _homeRepository;

  StudentHomeBloc(StudentHomeStates initialState, this._homeRepository)
      : super(initialState);

  @override
  Stream<StudentHomeStates> mapEventToState(StudentHomeEvents event) async* {
    yield StudentHomeLoading();
    if (event is FetchStudentHomeDetails) {
      final DMTaskState menuResult = await _homeRepository.getTodaysMenu();
      if (menuResult.isTaskSuccess) {
        final DMTaskState noticeResult =
            await _homeRepository.getLatestNotice();
        if (noticeResult.isTaskSuccess) {
          final DMTaskState paymentResult =
              await _homeRepository.getPaymentStatus();
          if (paymentResult.isTaskSuccess) {
            final DMTaskState leaveCountResult = await _homeRepository
                .getLeaveCount(paymentResult.taskResultData);
            if (leaveCountResult.isTaskSuccess) {
              yield StudentHomeFetchSuccess(
                  paymentStatus: paymentResult.taskResultData,
                  latestNotice: noticeResult.taskResultData,
                  listOfTodaysMeals: menuResult.taskResultData,
                  leaveCount: leaveCountResult.taskResultData);
            } else {
              yield StudentHomeError(leaveCountResult.error);
            }
          } else {
            yield StudentHomeError(paymentResult.error);
          }
        } else {
          yield StudentHomeError(noticeResult.error);
        }
      } else {
        yield StudentHomeError(menuResult.error);
      }
    } else if (event is MakePayment) {
      final DMTaskState paymentResult =
          await _homeRepository.makePayment(event.payment);
      if (paymentResult.isTaskSuccess) {
        yield StudentHomePaymentSuccess();
      } else {
        yield StudentHomeError(paymentResult.error);
      }
    }
  }
}
  
```  
# modules\student\home\bloc\home_events.dart  
```dart
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:equatable/equatable.dart';

abstract class StudentHomeEvents extends Equatable {
  const StudentHomeEvents();
}

class FetchStudentHomeDetails extends StudentHomeEvents {
  @override
  List<Object> get props => [];
}

class MakePayment extends StudentHomeEvents {
  final Payment payment;

  MakePayment(this.payment);

  @override
  List<Object> get props => [payment];
}
  
```  
# modules\student\home\bloc\home_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StudentHomeStates extends Equatable {
  const StudentHomeStates();
}

class StudentHomeLoading extends StudentHomeStates {
  @override
  List<Object> get props => [];
}

class StudentHomeIdle extends StudentHomeStates {
  @override
  List<Object> get props => [];
}

class StudentHomePaymentSuccess extends StudentHomeStates {
  final PaymentStatus paymentStatus =
      PaymentStatus(hasPaidFees: true, lastPaymentDate: DateTime.now());

  @override
  List<Object> get props => [];
}

class StudentHomeFetchSuccess extends StudentHomeStates {
  final List<MenuItem> listOfTodaysMeals;
  final List<Notice> latestNotice;
  final PaymentStatus paymentStatus;
  final int leaveCount;

  StudentHomeFetchSuccess({
    @required this.listOfTodaysMeals,
    @required this.latestNotice,
    @required this.paymentStatus,
    @required this.leaveCount,
  });

  @override
  List<Object> get props => [
        this.listOfTodaysMeals,
        this.latestNotice,
        this.paymentStatus,
        this.leaveCount
      ];
}

class StudentHomeError extends StudentHomeStates {
  final DMError errors;

  StudentHomeError(this.errors);

  @override
  List<Object> get props => [this.errors];
}
  
```  
# modules\student\home\data\home_repository.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHomeRepository {
  final CollectionReference _menuClient;
  final CollectionReference _noticesClient;
  final CollectionReference _paymentsClient;
  final CollectionReference _absenteesClient;

  StudentHomeRepository(this._menuClient, this._noticesClient,
      this._paymentsClient, this._absenteesClient);

  Future<DMTaskState> getTodaysMenu() async {
    try {
      final today = DateTime.now();
      final String dayKey = today.getDayKey();
      return await _menuClient
          .where("isEnabled", isEqualTo: true)
          .where("daysAvailable.$dayKey", isEqualTo: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<MenuItem> todaysFood =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(todaysFood);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: todaysFood, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getLatestNotice() async {
    try {
      return await _noticesClient
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((value) {
        final latestNotice =
            value.docs.map((e) => Notice.fromDocument(e)).toList();
        print(latestNotice);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: latestNotice, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getPaymentStatus() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _paymentsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((value) {
        final today = DateTime.now();
        final Payment latestPayment =
            value.docs.isEmpty ? null : Payment.fromDocument(value.docs.first);
        print(latestPayment);
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: PaymentStatus(
                hasPaidFees: latestPayment != null &&
                    latestPayment.paymentDate.isSameMonthAs(today),
                lastPaymentDate: latestPayment.paymentDate),
            error: null);
      }).onError((error, stackTrace) {
        print(stackTrace);
        print(error);
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> makePayment(Payment payment) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      final Payment paymentWithUserRef = payment.copyWith(user: user);
      return await _paymentsClient
          .add(paymentWithUserRef.toMap())
          .then((value) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> getLeaveCount(PaymentStatus paymentStatus) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      DateTime lastDayOfDueMonth;
      DateTime firstDayOfDueMonth;
      if (paymentStatus.lastPaymentDate == null) {
        final DateTime today = DateTime.now();
        lastDayOfDueMonth = DateTime(today.year, today.month, 0);
        firstDayOfDueMonth = DateTime(today.year, today.month - 1);
      } else {
        lastDayOfDueMonth = DateTime(paymentStatus.lastPaymentDate.year,
            paymentStatus.lastPaymentDate.month + 1, 0);
        firstDayOfDueMonth = DateTime(paymentStatus.lastPaymentDate.year,
            paymentStatus.lastPaymentDate.month);
      }
      return await _absenteesClient
          .where('userId', isEqualTo: user)
          .where('startDate', isLessThanOrEqualTo: lastDayOfDueMonth)
          .where('startDate', isGreaterThanOrEqualTo: firstDayOfDueMonth)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList =
            data.map((e) => LeaveEntry.fromDocument(e)).toList();
        int leaveCount = 0;
        leavesList.forEach((element) {
          for (DateTime day = element.startDate;
              day.compareTo(element.endDate) <= 0;
              day = day.copyWith(day: day.day + 1)) {
            if (day.month != lastDayOfDueMonth.month) break;
            leaveCount++;
          }
        });
        print(leaveCount);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: leaveCount, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\home\ui\screens\home_screen.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/annual_poll_card.dart';
import 'package:DigiMess/modules/student/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/student/home/bloc/home_events.dart';
import 'package:DigiMess/modules/student/home/bloc/home_states.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/home_bg_scroll_view.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/notice_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/payment_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_card.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentHomeScreen extends StatefulWidget {
  final VoidCallback noticesCallback;

  const StudentHomeScreen({Key key, this.noticesCallback}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<MenuItem> listOfTodaysMeals;
  Notice latestNotice;
  PaymentStatus paymentStatus;
  int lastMonthLeaveCount = 0;
  bool _isLoading = false;
  StudentHomeBloc _homeBloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentHomeBloc, StudentHomeStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentHomeLoading;
          });
          if (state is StudentHomeError) {
            DMSnackBar.show(context, state.errors.message);
          } else if (state is StudentHomeFetchSuccess) {
            setState(() {
              paymentStatus = state.paymentStatus;
              listOfTodaysMeals = state.listOfTodaysMeals;
              latestNotice = state.latestNotice.takeFirstOrNull();
              lastMonthLeaveCount = state.leaveCount;
            });
          } else if (state is StudentHomePaymentSuccess) {
            setState(() {
              paymentStatus = state.paymentStatus;
            });
          }
        },
        builder: (context, state) {
          _homeBloc = BlocProvider.of<StudentHomeBloc>(context);
          if (state is StudentHomeIdle) {
            _homeBloc.add(FetchStudentHomeDetails());
            return Container();
          } else if (state is StudentHomeFetchSuccess ||
              state is StudentHomePaymentSuccess) {
            return HomeScrollView(
                child: Column(
              children: [
                TodaysFoodCard(listOfTodaysMeals: listOfTodaysMeals),
                Visibility(
                    visible: !DateExtensions.isNightTime(),
                    child: TodaysFoodPageView(
                        listOfTodaysMeals: listOfTodaysMeals)),
                Visibility(
                  visible: !DateExtensions.isNightTime(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                ),
                Visibility(
                  visible: latestNotice != null,
                  child: NoticeCard(
                      latestNotice: latestNotice,
                      noticesCallback: widget.noticesCallback),
                ),
                HomePaymentCard(
                  paymentStatus: paymentStatus,
                  lastMonthLeaveCount: lastMonthLeaveCount,
                  onPaymentSuccessCallback: onPaymentSuccessCallback,
                ),
                StudentAnnualPollCard()
              ],
            ));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  onPaymentSuccessCallback(Payment payment) {
    _homeBloc.add(MakePayment(payment));
  }
}
  
```  
# modules\student\home\ui\widgets\home_bg_scroll_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScrollView extends StatelessWidget {
  final Widget child;

  const HomeScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Container(
        color: DMColors.lightBlue,
        child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    child: SvgPicture.asset("assets/icons/home_bg.svg",
                        fit: BoxFit.cover),
                  ),
                  child,
                ],
              ),
            )),
      );
    });
  }
}
  
```  
# modules\student\home\ui\widgets\notice_card.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final Notice latestNotice;
  final VoidCallback noticesCallback;

  const NoticeCard({Key key, this.latestNotice, this.noticesCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DMColors.white,
          border: Border.all(color: DMColors.primaryBlue, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Icon(Icons.circle, color: DMColors.yellow, size: 10)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(latestNotice.title, style: DMTypo.bold14BlackTextStyle)),
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(latestNotice.date.getTimeAgo(),
                                style: DMTypo.bold12MutedTextStyle)),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: noticesCallback,
              child: Row(
                children: [
                  Text("View more", style: DMTypo.bold12PrimaryBlueTextStyle),
                  Icon(Icons.double_arrow, color: DMColors.primaryBlue, size: 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
  
```  
# modules\student\home\ui\widgets\payment_card.dart  
```dart
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePaymentCard extends StatefulWidget {
  final PaymentStatus paymentStatus;
  final int lastMonthLeaveCount;
  final Function(Payment) onPaymentSuccessCallback;

  const HomePaymentCard(
      {Key key, this.paymentStatus, this.lastMonthLeaveCount, this.onPaymentSuccessCallback})
      : super(key: key);

  @override
  _HomePaymentCardState createState() => _HomePaymentCardState();
}

class _HomePaymentCardState extends State<HomePaymentCard> {
  int amount = 0;
  String dueDateHint = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    amount = getPaymentAmount();
    description = getDescription();
    dueDateHint = getDueDate();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.paymentStatus.hasPaidFees,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 10),
        decoration:
            BoxDecoration(color: DMColors.primaryBlue, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(getDueFees(context), style: DMTypo.bold30WhiteTextStyle)),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(getDueDate(), style: DMTypo.bold12WhiteTextStyle),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: DMPillButton(
                  isEnabled: amount > 0,
                  onPressed: () async {
                    Navigator.pushNamed(context, Routes.DUMMY_PAYMENT_SCREEN,
                        arguments: DummyPaymentArguments(description, amount, () {
                          // ignore: missing_required_param
                          widget.onPaymentSuccessCallback(Payment(
                              description: description,
                              paymentAccountType: PaymentAccountType.CARD,
                              paymentAmount: amount,
                              paymentDate: DateTime.now()));
                        }));
                  },
                  onDisabledPressed: () async {
                    DMSnackBar.show(context,
                        "An error has occurred with fee calculation, contact the admin from the help section.");
                  },
                  text: "Pay Now",
                  textStyle: DMTypo.bold14WhiteTextStyle,
                  padding: EdgeInsets.symmetric(horizontal: 20)),
            )
          ],
        ),
      ),
    );
  }

  String getDueFees(context) {
    return amount.getFormattedCurrency(isSymbol: false);
  }

  String getDueDate() {
    final monthNameFormat = DateFormat("MMMM");
    final DateTime today = DateTime.now();
    if (widget.paymentStatus.lastPaymentDate.isLastMonthOf(today) &&
        DateExtensions.isBeforeDueDate()) {
      return "Due 7th ${monthNameFormat.format(today)}";
    } else {
      return "Was due 7th ${monthNameFormat.format(widget.paymentStatus.lastPaymentDate.copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1))}";
    }
  }

  String getDescription() {
    final monthYearFormat = DateFormat("MMMM yyyy");
    final DateTime today = DateTime.now();
    if (widget.paymentStatus.lastPaymentDate.isLastMonthOf(today) &&
        DateExtensions.isBeforeDueDate()) {
      return "Fees of ${monthYearFormat.format(today)}";
    } else {
      return "Fees of ${monthYearFormat.format(widget.paymentStatus.lastPaymentDate.copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1))}";
    }
  }

  int getPaymentAmount() {
    final int noOfDaysInMonth = widget.paymentStatus.lastPaymentDate
        .copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1, day: 0)
        .day;
    if (noOfDaysInMonth < widget.lastMonthLeaveCount || noOfDaysInMonth < 28) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DMSnackBar.show(context,
            "An error has occurred with fee calculation, contact the admin from the help section.");
      });
      return 0;
    } else {
      final DateTime today = DateTime.now();

      int daysSinceDue = 0;
      final dueDate = widget.paymentStatus.lastPaymentDate
          .copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1, day: 7);
      if (today.isAfter(dueDate)) {
        daysSinceDue = dueDate.difference(today).inDays.abs();
      }
      final int amount = DMDetails.constantMessPrice +
          ((noOfDaysInMonth - widget.lastMonthLeaveCount) * DMDetails.dailyMessPrice) +
          (daysSinceDue * DMDetails.dailyFinePrice);
      print("lastPaymentDate: ${widget.paymentStatus.lastPaymentDate}\n"
          "hasPaidFees: ${widget.paymentStatus.hasPaidFees}\n"
          "noOfDaysInDueMonth : $noOfDaysInMonth\n"
          "lastMonthLeaveCount : ${widget.lastMonthLeaveCount}\n"
          "daysSinceDue : $daysSinceDue\namount : $amount");
      if (amount < 0)
        return 0;
      else
        return amount;
    }
  }
}
  
```  
# modules\student\home\ui\widgets\todays_food_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TodaysFoodCard extends StatelessWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodCard({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.all(20), child: getMenuIconOrClosedIcon()),
          Expanded(
            child: Container(margin: EdgeInsets.all(20), child: getTodayMessOrClosedHint()),
          ),
        ],
      ),
    );
  }

  Widget getTodayMessOrClosedHint() {
    if (DateExtensions.isNightTime()) {
      return Text("Mess closed", style: DMTypo.bold24BlackTextStyle);
    } else {
      return Column(
        children: [
          Text("Today's Food", style: DMTypo.bold24BlackTextStyle),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(getTimeInterval(), style: DMTypo.bold12MutedTextStyle),
          ),
          getFoodItemsOfCurrentTime()
        ],
      );
    }
  }

  String getTimeInterval() {
    if (DateExtensions.isBreakfastTime()) {
      return "9:00 AM - 11:00 AM";
    } else if (DateExtensions.isLunchTime()) {
      return "12:00 PM - 1:00 PM";
    } else if (DateExtensions.isDinnerTime()) {
      return "8:00 PM - 9:00 PM";
    } else {
      return "";
    }
  }

  Widget getFoodItemsOfCurrentTime() {
    String mealsString;
    if (DateExtensions.isBreakfastTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isLunchTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isDinnerTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    }

    return Text(mealsString ?? "Food not marked by mess staff", style: DMTypo.bold12BlackTextStyle);
  }

  getMenuIconOrClosedIcon() {
    if (DateExtensions.isNightTime()) {
      return SvgPicture.asset("assets/icons/moon_icon.svg");
    } else {
      return SvgPicture.asset("assets/icons/food_icon.svg");
    }
  }
}
  
```  
# modules\student\home\ui\widgets\todays_food_item.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TodaysFoodItem extends StatelessWidget {
  final String title;
  final MenuItem nonVegItem;
  final MenuItem vegItem;

  const TodaysFoodItem({Key key, this.title, this.nonVegItem, this.vegItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(title, style: DMTypo.bold18BlackTextStyle),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getImagesOrEmptyHint(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getImagesOrEmptyHint() {
    if (vegItem == null && nonVegItem == null) {
      return [
        Text("Food not marked by mess staff",
            style: DMTypo.bold12BlackTextStyle)
      ];
    } else if (vegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        )
      ];
    } else if (nonVegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    } else {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        ),
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    }
  }
}

class FoodImageItem extends StatelessWidget {
  final bool isVeg;
  final String foodName;
  final String imageUrl;

  const FoodImageItem({Key key, this.isVeg, this.foodName, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      foodName,
                      style: DMTypo.bold12BlackTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SvgPicture.asset(
                    isVeg
                        ? "assets/icons/veg_icon.svg"
                        : "assets/icons/non_veg_icon.svg",
                    height: 10,
                    width: 10,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
  
```  
# modules\student\home\ui\widgets\todays_food_page_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class TodaysFoodPageView extends StatefulWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodPageView({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  _TodaysFoodPageViewState createState() => _TodaysFoodPageViewState();
}

class _TodaysFoodPageViewState extends State<TodaysFoodPageView> {
  double currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: double.infinity,
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: PageController(initialPage: currentIndex.toInt()),
              onPageChanged: onPageChanged,
              children: getPages(),
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: currentIndex,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(30.0, 9.0),
              activeColor: DMColors.primaryBlue,
              color: DMColors.accentBlue,
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentIndex = value.toDouble();
    });
  }

  List<TodaysFoodItem> getPages() {
    final List<MenuItem> breakfastFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isBreakfast).toList();
    final List<MenuItem> lunchFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isLunch).toList();
    final List<MenuItem> dinnerFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isDinner).toList();
    return [
      TodaysFoodItem(
          title: "Breakfast",
          vegItem: breakfastFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: breakfastFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Lunch",
          vegItem: lunchFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: lunchFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Dinner",
          vegItem: dinnerFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: dinnerFood.firstWhere((element) => !element.isVeg, orElse: () => null))
    ];
  }
}
  
```  
# modules\student\leaves\bloc\leaves_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/student/leaves/data/leaves_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLeaveBloc extends Bloc<StudentLeaveEvents, StudentLeaveStates> {
  final StudentLeavesRepository _leavesRepository;

  StudentLeaveBloc(StudentLeaveStates initialState, this._leavesRepository)
      : super(initialState);

  @override
  Stream<StudentLeaveStates> mapEventToState(StudentLeaveEvents event) async* {
    yield StudentLeaveLoading();
    if (event is GetAllLeaves) {
      final DMTaskState result = await _leavesRepository.getAllLeaves();
      if (result.isTaskSuccess) {
        yield StudentLeaveFetchSuccess(result.taskResultData);
      } else {
        yield StudentLeaveError(result.error);
      }
    } else if (event is PlaceLeave) {
      final DMTaskState result =
          await _leavesRepository.applyForLeave(event.leaveInterval);
      if (result.isTaskSuccess) {
        yield StudentLeaveSuccess();
      } else {
        yield StudentLeaveError(result.error);
      }
    }
  }
}
  
```  
# modules\student\leaves\bloc\leaves_events.dart  
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StudentLeaveEvents extends Equatable {
  const StudentLeaveEvents();
}

class GetAllLeaves extends StudentLeaveEvents {
  @override
  List<Object> get props => [];
}

class PlaceLeave extends StudentLeaveEvents {
  final DateTimeRange leaveInterval;

  PlaceLeave(this.leaveInterval);

  @override
  List<Object> get props => [leaveInterval];
}
  
```  
# modules\student\leaves\bloc\leaves_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentLeaveStates extends Equatable {
  const StudentLeaveStates();
}

class StudentLeaveIdle extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}

class StudentLeaveLoading extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}

class StudentLeaveError extends StudentLeaveStates {
  final DMError error;

  StudentLeaveError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentLeaveFetchSuccess extends StudentLeaveStates {
  final List<LeaveEntry> listOfLeaves;

  StudentLeaveFetchSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StudentLeaveSuccess extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}
  
```  
# modules\student\leaves\data\leaves_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentLeavesRepository {
  final CollectionReference _absenteesClient;

  StudentLeavesRepository(this._absenteesClient);

  Future<DMTaskState> getAllLeaves() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _absenteesClient
          .where('userId', isEqualTo: user)
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList =
            data.map((e) => LeaveEntry.fromDocument(e)).toList();
        print(leavesList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: leavesList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> applyForLeave(DateTimeRange leaveInterval) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _absenteesClient
          .add(LeaveEntry(
                  startDate: leaveInterval.start,
                  endDate: leaveInterval.end,
                  applyDate: DateTime.now(),
                  user: user,
                  leaveEntryId: '')
              .toMap())
          .then((value) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\leaves\ui\screens\leaves_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_events.dart';
import 'package:DigiMess/modules/student/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/student/leaves/ui/widgets/leave_entry_card.dart';
import 'package:DigiMess/modules/student/leaves/ui/widgets/place_leave_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentLeavesScreen extends StatefulWidget {
  @override
  _StudentLeavesScreenState createState() => _StudentLeavesScreenState();
}

class _StudentLeavesScreenState extends State<StudentLeavesScreen> {
  bool _isLoading = false;
  bool _isLeaveOngoing = false;
  List<LeaveEntry> leavesList = [];
  StudentLeaveBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        dismissible: false,
        inAsyncCall: _isLoading,
        child: BlocConsumer<StudentLeaveBloc, StudentLeaveStates>(
            listener: (context, state) {
          setState(() {
            _isLoading = state is StudentLeaveLoading;
          });
          if (state is StudentLeaveError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentLeaveFetchSuccess) {
            setState(() {
              leavesList = state.listOfLeaves;
              final DateTime now = DateTime.now();
              _isLeaveOngoing = leavesList.isNotEmpty &&
                  ((leavesList.first.startDate.compareTo(now) <= 0 &&
                          leavesList.first.endDate
                                  .copyWith(
                                      day: leavesList.first.endDate.day + 1)
                                  .compareTo(now) >=
                              0) ||
                      leavesList.first.startDate.isAfter(now));
            });
          } else if (state is StudentLeaveSuccess) {
            DMSnackBar.show(context, "Leave placed!");
            _bloc.add(GetAllLeaves());
          }
        }, builder: (context, state) {
          _bloc = BlocProvider.of<StudentLeaveBloc>(context);
          if (state is StudentLeaveIdle) {
            _bloc.add(GetAllLeaves());
            return Container();
          } else if (state is StudentLeaveLoading) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: leavesList == null || leavesList.isEmpty
                  ? 6
                  : leavesList.length + 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Text("Take leave",
                            style: DMTypo.bold16BlackTextStyle)),
                  );
                } else if (index == 1) {
                  return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Divider(
                        color: DMColors.primaryBlue,
                        thickness: 1,
                      ));
                } else if (index == 2) {
                  return PlaceLeaveCard(
                      onLeaveSubmit: onLeaveSubmit,
                      isLeaveOngoing: _isLeaveOngoing);
                } else if (index == 3) {
                  return Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Text("Leave history",
                            style: DMTypo.bold16BlackTextStyle)),
                  );
                } else if (index == 4) {
                  return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Divider(
                        color: DMColors.primaryBlue,
                        thickness: 1,
                      ));
                } else if (index == 5 &&
                    (leavesList == null || leavesList.isEmpty)) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("No leaves taken yet.",
                          style: DMTypo.bold12MutedTextStyle),
                    ),
                  );
                } else {
                  return LeaveEntryCard(
                    leaveEntry: leavesList[index - 5],
                    isOnGoingLeave: _isLeaveOngoing && index == 5,
                  );
                }
              },
            );
          }
        }));
  }

  void onLeaveSubmit(DateTimeRange leaveInterval) {
    _bloc.add(PlaceLeave(leaveInterval));
  }
}
  
```  
# modules\student\leaves\ui\widgets\leave_entry_card.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LeaveEntryCard extends StatelessWidget {
  final LeaveEntry leaveEntry;
  final bool isOnGoingLeave;

  const LeaveEntryCard({Key key, this.leaveEntry, this.isOnGoingLeave = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              isOnGoingLeave
                  ? Icon(Icons.access_time, color: DMColors.black, size: 15)
                  : SvgPicture.asset("assets/icons/check.svg",
                      color: DMColors.green, height: 15, width: 15),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                          isOnGoingLeave ? "Leave ongoing" : "Leave taken from",
                          style: DMTypo.bold14BlackTextStyle))),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getDayCount(),
                      style: DMTypo.bold14PrimaryBlueTextStyle))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  child: Text(getDateInterval(),
                      style: DMTypo.bold12MutedTextStyle),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getDayCount() {
    return leaveEntry.startDate.getDifferenceInDays(leaveEntry.endDate);
  }

  String getDateInterval() {
    final DateFormat format = DateFormat("d MMM yyyy");
    return "${format.format(leaveEntry.startDate)} - ${format.format(leaveEntry.endDate)}";
  }
}
  
```  
# modules\student\leaves\ui\widgets\place_leave_card.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_date_picker.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaceLeaveCard extends StatefulWidget {
  final Function(DateTimeRange) onLeaveSubmit;
  final bool isLeaveOngoing;

  const PlaceLeaveCard({Key key, this.onLeaveSubmit, this.isLeaveOngoing})
      : super(key: key);

  @override
  _PlaceLeaveCardState createState() => _PlaceLeaveCardState();
}

class _PlaceLeaveCardState extends State<PlaceLeaveCard> {
  DateTime startDate;
  DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text("From")),
                Container(
                  child: Container(width: 55, height: 15),
                ),
                Expanded(
                  child: Text("To"),
                ),
              ],
            ),
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  child: Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () => showStartDatePickerAndAwait(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: DMColors.primaryBlue, width: 1)),
                        child: Center(child: getFromStartDate()),
                      ),
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.arrow_forward_ios,
                      color: DMColors.primaryBlue, size: 15),
                ),
                Expanded(
                    child: Container(
                  child: Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () => showEndDatePickerAndAwait(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: DMColors.primaryBlue, width: 1)),
                        child: Center(child: getFromEndDate()),
                      ),
                    ),
                  ),
                )),
              ]),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(getIntervalDuration(),
                  style: DMTypo.bold14BlackTextStyle)),
          DMPillButton(
            text: "Submit",
            isEnabled: !widget.isLeaveOngoing,
            textStyle: DMTypo.bold14WhiteTextStyle,
            padding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: () {
              if (startDate == null || endDate == null) {
                DMSnackBar.show(context, "Choose an interval first");
              } else {
                widget.onLeaveSubmit(
                    DateTimeRange(start: startDate, end: endDate));
              }
            },
            onDisabledPressed: () {
              DMSnackBar.show(context, "Leave is already ongoing");
            },
          )
        ],
      ),
    );
  }

  void showStartDatePickerAndAwait(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime pickerStartDate =
        DateExtensions.isNightTime() ? now.add(Duration(days: 1)) : now;
    final DateTime pickedDate = await DMDatePicker.showPicker(context,
        firstDate: pickerStartDate, initialDate: pickerStartDate);
    setState(() {
      if (pickedDate != null) {
        if (endDate != null) endDate = null;
        startDate = pickedDate;
      }
    });
  }

  void showEndDatePickerAndAwait(BuildContext context) async {
    if (startDate == null) {
      DMSnackBar.show(context, "Choose start date first.");
      return;
    }
    final DateTime pickerStartDate = startDate.add(Duration(days: 1));
    final DateTime pickerEndDate = startDate.add(Duration(days: 61));
    final DateTime pickedDate = await DMDatePicker.showPicker(context,
        firstDate: pickerStartDate,
        initialDate: pickerStartDate,
        lastDate: pickerEndDate);
    setState(() {
      if (pickedDate != null) {
        endDate = pickedDate;
      }
    });
  }

  Text getFromStartDate() {
    if (startDate == null) {
      return Text("dd/mm/yyyy", style: DMTypo.bold12MutedTextStyle);
    } else {
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return Text(format.format(startDate),
          style: DMTypo.bold12PrimaryBlueTextStyle);
    }
  }

  Text getFromEndDate() {
    if (endDate == null) {
      return Text("dd/mm/yyyy", style: DMTypo.bold12MutedTextStyle);
    } else {
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return Text(format.format(endDate),
          style: DMTypo.bold12PrimaryBlueTextStyle);
    }
  }

  String getIntervalDuration() {
    if (startDate == null || endDate == null) {
      return "Number of days : 0";
    } else {
      return "Number of days : ${startDate.difference(endDate).inDays.abs()}";
    }
  }
}
  
```  
# modules\student\main\ui\screens\main_screen.dart  
```dart
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
  
```  
# modules\student\main\ui\widgets\student_nav_drawer.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/widgets/nav_item.dart';
import 'package:DigiMess/modules/student/main/util/student_nav_destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentNavDrawer extends StatelessWidget {
  final Function(StudentNavDestinations) itemOnClickCallBack;
  final StudentNavDestinations currentScreen;

  const StudentNavDrawer({Key key, this.itemOnClickCallBack, this.currentScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: DMColors.primaryBlue,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/logo/ic_foreground.svg", height: 30),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.clear),
                        color: DMColors.white,
                        iconSize: 24,
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: DMColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavItem(
                          text: "Home",
                          iconAsset: "assets/icons/home.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.HOME,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.HOME),
                        ),
                        NavItem(
                          text: "Menu",
                          iconAsset: "assets/icons/menu.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.MENU,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.MENU),
                        ),
                        NavItem(
                          text: "Complaints",
                          iconAsset: "assets/icons/complaints.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.COMPLAINTS,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.COMPLAINTS),
                        ),
                        NavItem(
                          text: "Payments",
                          iconAsset: "assets/icons/payments.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.PAYMENTS,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.PAYMENTS),
                        ),
                        NavItem(
                          text: "Leaves",
                          iconAsset: "assets/icons/leaves.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.LEAVES,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.LEAVES),
                        ),
                        NavItem(
                          text: "Notices",
                          iconAsset: "assets/icons/notices.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.NOTICES,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.NOTICES),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Divider(
                            color: DMColors.mutedBlue,
                          ),
                        ),
                        NavItem(
                          text: "Profile",
                          iconAsset: "assets/icons/profile.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.PROFILE,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.PROFILE),
                        ),
                        NavItem(
                          text: "Help",
                          iconAsset: "assets/icons/help.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.HELP,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.HELP),
                        ),
                        NavItem(
                          text: "About",
                          iconAsset: "assets/icons/about.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.ABOUT,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.ABOUT),
                        ),
                        NavItem(
                          text: "Share",
                          iconAsset: "assets/icons/share.svg",
                          isItemSelected: currentScreen == StudentNavDestinations.SHARE,
                          onClick: () => itemOnClickCallBack(StudentNavDestinations.SHARE),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\main\util\student_nav_destinations.dart  
```dart
enum StudentNavDestinations {
  HOME,
  MENU,
  COMPLAINTS,
  PAYMENTS,
  LEAVES,
  NOTICES,
  PROFILE,
  HELP,
  ABOUT,
  SHARE
}

extension StudentNavDestinationExtensions on StudentNavDestinations {
  String toStringValue() {
    return this.toString().split('.').last;
  }

}
  
```  
# modules\student\menu\bloc\menu_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_events.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_states.dart';
import 'package:DigiMess/modules/student/menu/data/menu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMenuBloc extends Bloc<StudentMenuEvents, StudentMenuStates> {
  final StudentMenuRepository _menuRepository;

  StudentMenuBloc(StudentMenuStates initialState, this._menuRepository)
      : super(initialState);

  @override
  Stream<StudentMenuStates> mapEventToState(StudentMenuEvents event) async* {
    yield StudentMenuLoading();
    if (event is FilterMenuItems) {
      final DMTaskState result = await _menuRepository.getMenuItems(menuFilterType: event.menuFilterType);
      if (result.isTaskSuccess) {
        yield StudentMenuSuccess(result.taskResultData);
      } else {
        yield StudentMenuError(result.error);
      }
    }
  }
}
  
```  
# modules\student\menu\bloc\menu_events.dart  
```dart
import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class StudentMenuEvents extends Equatable {
  const StudentMenuEvents();
}

class FilterMenuItems extends StudentMenuEvents {
  final MenuFilterType menuFilterType;

  FilterMenuItems({this.menuFilterType = MenuFilterType.BOTH});

  @override
  List<Object> get props => [this.menuFilterType];
}
  
```  
# modules\student\menu\bloc\menu_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentMenuStates extends Equatable {
  const StudentMenuStates();
}

class StudentMenuLoading extends StudentMenuStates {
  @override
  List<Object> get props => [];
}

class StudentMenuIdle extends StudentMenuStates {
  @override
  List<Object> get props => [];
}

class StudentMenuError extends StudentMenuStates {
  final DMError error;

  StudentMenuError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentMenuSuccess extends StudentMenuStates {
  final List<MenuItem> menuItems;

  StudentMenuSuccess(this.menuItems);

  @override
  List<Object> get props => [menuItems];
}
  
```  
# modules\student\menu\data\menu_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentMenuRepository {
  final CollectionReference _menuClient;

  StudentMenuRepository(this._menuClient);

  Future<DMTaskState> getMenuItems(
      {MenuFilterType menuFilterType = MenuFilterType.BOTH}) async {
    try {
      Query query;
      if (menuFilterType == MenuFilterType.BOTH) {
        query = _menuClient.where("isEnabled", isEqualTo: true);
      } else {
        query = _menuClient
            .where("isEnabled", isEqualTo: true)
            .where("isVeg", isEqualTo: menuFilterType == MenuFilterType.VEG);
      }
      return await query.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: menuList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\menu\data\util\menu_filter_type.dart  
```dart
enum MenuFilterType { VEG, NONVEG, BOTH}

extension FilterExtension on MenuFilterType{
  String toStringValue() {
    return this.toString().split('.').last;
  }
}  
```  
# modules\student\menu\ui\screens\menu_screen.dart  
```dart
import 'dart:async';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_bloc.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_events.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_states.dart';
import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:DigiMess/modules/student/menu/ui/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentMenuScreen extends StatefulWidget {
  @override
  _StudentMenuScreenState createState() => _StudentMenuScreenState();
}

class _StudentMenuScreenState extends State<StudentMenuScreen> {
  List<MenuItem> currentList = [];
  List<MenuItem> fullList = [];
  bool _isLoading = false;
  StudentMenuBloc _bloc;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController(text: "");
  MenuFilterType currentFilter = MenuFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StudentMenuBloc, StudentMenuStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentMenuLoading;
          });
          if (state is StudentMenuSuccess) {
            setState(() {
              fullList = state.menuItems;
              currentList = fullList;
            });
          } else if (state is StudentMenuError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentMenuBloc>(context);
          if (state is StudentMenuIdle) {
            _bloc.add(FilterMenuItems());
            return Container();
          } else if (state is StudentMenuLoading) {
            return Container();
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: DMColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DMColors.blueBg,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Search food item",
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintStyle: DMTypo.bold16MutedTextStyle,
                                prefixIcon: Container(
                                    child: Icon(Icons.search,
                                        color: DMColors.primaryBlue,
                                        size: 20))),
                            maxLines: 1,
                            style: DMTypo.bold16BlackTextStyle,
                            keyboardType: TextInputType.text,
                            controller: _searchController,
                            onChanged: onSearch,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          child: DMFilterMenu(
                            icon: Icon(Icons.filter_list,
                                color: DMColors.primaryBlue, size: 20),
                            selectedValue: selectedFilterIndex,
                            listOfValuesAndItems: [
                              MapEntry(0, "show veg only"),
                              MapEntry(1, "show non-veg only"),
                              MapEntry(2, "show all"),
                            ],
                            onChanged: filterBySelected,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: getListViewOrEmptyHint(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void onSearch(String value) {
    searchQuery = value;
    if (searchDebounceTimer != null) {
      searchDebounceTimer.cancel();
    }
    searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
      final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      setState(() {
        if (searchQuery.trim().isEmpty) {
          _searchController.text = "";
          currentList = fullList;
        } else {
          currentList = fullList
              .where((element) => element.name
                  .trim()
                  .toLowerCase()
                  .contains(searchQuery.trim().toLowerCase()))
              .toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    _searchController.text = "";
    if (value == 0) {
      currentFilter = MenuFilterType.VEG;
    } else if (value == 1) {
      currentFilter = MenuFilterType.NONVEG;
    } else {
      currentFilter = MenuFilterType.BOTH;
    }
    _bloc.add(FilterMenuItems(menuFilterType: currentFilter));
  }

  Widget getListViewOrEmptyHint() {
    if (currentList.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No items for the selected search and filter found.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (_, int index) {
            return MenuCard(item: currentList[index]);
          },
        ),
      );
    }
  }
}
  
```  
# modules\student\menu\ui\widgets\menu_card.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(item.imageUrl), fit: BoxFit.cover)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:
                          Text(item.name, style: DMTypo.bold12BlackTextStyle)),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: SvgPicture.asset(item.isVeg
                          ? "assets/icons/veg_icon.svg"
                          : "assets/icons/non_veg_icon.svg")),
                  Container(
                      padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                      child: Text(getDaysAvailable(),
                          style: DMTypo.bold12MutedTextStyle)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getDaysAvailable() {
    String days;
    int count = 0;
    item.daysAvailable.toMap().forEach((key, value) {
      if (value) {
        count++;
        if (days == null) {
          days = "Available on ${key}s";
        } else {
          days += ", ${key}s";
        }
      }
    });
    if (days == null) {
      return "Days available not marked by staff.";
    } else if (count == 7) {
      return "Available everyday.";
    } else {
      return "$days.";
    }
  }
}
  
```  
# modules\student\mess_card\bloc\mess_card_bloc.dart  
```dart
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_events.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_states.dart';
import 'package:DigiMess/modules/student/mess_card/data/mess_card_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessCardBloc extends Bloc<MessCardEvents, MessCardStates> {
  final MessCardRepository _repository;

  MessCardBloc(MessCardStates initialState, this._repository)
      : super(initialState);

  @override
  Stream<MessCardStates> mapEventToState(MessCardEvents event) async* {
    yield MessCardLoading();
    if (event is GetMessCardStatus) {
      final DMTaskState result = await _repository.getMessCardStatus();
      if (result.isTaskSuccess) {
        final String admissionNo = await SharedPrefRepository.getUsername();
        yield MessCardSuccess(result.taskResultData, admissionNo);
      } else {
        yield MessCardError(result.error);
      }
    }
  }
}
  
```  
# modules\student\mess_card\bloc\mess_card_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class MessCardEvents extends Equatable {
  const MessCardEvents();
}

class GetMessCardStatus extends MessCardEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\student\mess_card\bloc\mess_card_states.dart  
```dart
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class MessCardStates extends Equatable {
  const MessCardStates();
}

class MessCardIdle extends MessCardStates {
  @override
  List<Object> get props => [];
}

class MessCardLoading extends MessCardStates {
  @override
  List<Object> get props => [];
}

class MessCardSuccess extends MessCardStates {
  final bool isActive;
  final String admissionNo;

  MessCardSuccess(this.isActive, this.admissionNo);

  @override
  List<Object> get props => [isActive, admissionNo];
}

class MessCardError extends MessCardStates {
  final DMError error;

  MessCardError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\student\mess_card\data\mess_card_repository.dart  
```dart
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessCardRepository {
  final CollectionReference _paymentsClient;

  MessCardRepository(this._paymentsClient);

  Future<DMTaskState> getMessCardStatus() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _paymentsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((value) async {
        final today = DateTime.now();
        final Payment latestPayment =
            value.docs.isEmpty ? null : Payment.fromDocument(value.docs.first);
        print(latestPayment);
        return await user.get().then((value) {
          print(value.data());
          if (!value.exists || value.data() == null) {
            return DMTaskState(
                isTaskSuccess: false,
                taskResultData: null,
                error: DMError(message: "User details not found!"));
          }
          final User userDetails = User.fromDocument(value);
          return DMTaskState(
              isTaskSuccess: true,
              taskResultData: latestPayment != null &&
                  userDetails.isEnrolled &&
                  ((latestPayment.paymentDate.isSameMonthAs(today)) ||
                      (latestPayment.paymentDate.isLastMonthOf(today) &&
                          DateExtensions.isBeforeDueDate())),
              error: null);
        }).onError((error, stackTrace) {
          print(stackTrace);
          print(error);
          return DMTaskState(
              isTaskSuccess: false,
              taskResultData: null,
              error: DMError(message: error.toString()));
        });
      }).onError((error, stackTrace) {
        print(stackTrace);
        print(error);
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\mess_card\ui\mess_card.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_bloc.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_events.dart';
import 'package:DigiMess/modules/student/mess_card/bloc/mess_card_states.dart';
import 'package:DigiMess/modules/student/mess_card/data/mess_card_repository.dart';
import 'package:DigiMess/modules/student/mess_card/ui/mess_card_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMessCard {
  StudentMessCard._();

  static show(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return BlocProvider(
            create: (_) => MessCardBloc(
                MessCardIdle(),
                MessCardRepository(
                    FirebaseClient.getPaymentsCollectionReference())),
            child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                      width: constraints.maxWidth,
                      child: BlocConsumer<MessCardBloc, MessCardStates>(
                        listener: (context, state) {
                          if (state is MessCardError) {
                            DMSnackBar.show(context, state.error.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is MessCardIdle) {
                            BlocProvider.of<MessCardBloc>(context)
                                .add(GetMessCardStatus());
                            return Container();
                          } else if (state is MessCardSuccess) {
                            return MessCardScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.all(50).copyWith(bottom: 0),
                                    child: Text("MESS CARD",
                                        style:
                                            DMTypo.bold30PrimaryBlueTextStyle,
                                        textAlign: TextAlign.center),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.all(40).copyWith(top: 10),
                                    child: Text(
                                        "ID : ${state.admissionNo ?? "Unavailable, Log in again"}",
                                        style:
                                            DMTypo.bold18PrimaryBlueTextStyle,
                                        textAlign: TextAlign.center),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 80)
                                          .copyWith(top: 0),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: DMColors.primaryBlue)),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Text.rich(
                                                TextSpan(
                                                  style: DMTypo
                                                      .bold18BlackTextStyle,
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Status : '),
                                                    TextSpan(
                                                        text: state.isActive
                                                            ? "Active"
                                                            : "Inactive",
                                                        style: state.isActive
                                                            ? DMTypo
                                                                .bold18GreenTextStyle
                                                            : DMTypo
                                                                .bold18RedTextStyle),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center),
                                          ),
                                          state.isActive
                                              ? Icon(Icons.circle,
                                                  color: DMColors.green,
                                                  size: 80)
                                              : Icon(Icons.circle,
                                                  color: DMColors.red, size: 80)
                                        ],
                                      ))
                                ],
                              ),
                            );
                          } else if (state is MessCardLoading) {
                            return LayoutBuilder(builder: (_, constraints) {
                              return Container(
                                  height: constraints.maxWidth,
                                  margin: EdgeInsets.all(20),
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            });
                          } else {
                            Navigator.of(context).pop();
                            return Container(height: 0);
                          }
                        },
                      ));
                })),
          );
        });
  }
}
  
```  
# modules\student\mess_card\ui\mess_card_scroll_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessCardScrollView extends StatelessWidget {
  final Widget child;

  const MessCardScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DMColors.primaryBlue)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SvgPicture.asset("assets/icons/corner_icon_top.svg"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset("assets/icons/corner_icon_bottom.svg"),
              ),
              Center(child: child)
            ],
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\notices\bloc\notices_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/student/notices/data/notices_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentNoticesBloc
    extends Bloc<StudentNoticesEvents, StudentNoticesStates> {
  final StudentNoticesRepository _noticesRepository;

  StudentNoticesBloc(StudentNoticesStates initialState, this._noticesRepository)
      : super(initialState);

  @override
  Stream<StudentNoticesStates> mapEventToState(
      StudentNoticesEvents event) async* {
    yield StudentNoticesLoading();
    if (event is GetAllNotices) {
      final DMTaskState result = await _noticesRepository.getAllNotices();
      if (result.isTaskSuccess) {
        yield StudentNoticesSuccess(result.taskResultData);
      } else {
        yield StudentNoticesError(result.error);
      }
    }
  }
}
  
```  
# modules\student\notices\bloc\notices_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StudentNoticesEvents extends Equatable {
  const StudentNoticesEvents();
}

class GetAllNotices extends StudentNoticesEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\student\notices\bloc\notices_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentNoticesStates extends Equatable {
  const StudentNoticesStates();
}

class StudentNoticesIdle extends StudentNoticesStates {
  @override
  List<Object> get props => [];
}

class StudentNoticesLoading extends StudentNoticesStates {
  @override
  List<Object> get props => [];
}

class StudentNoticesSuccess extends StudentNoticesStates {
  final List<Notice> listOfNotices;

  StudentNoticesSuccess(this.listOfNotices);

  @override
  List<Object> get props => [listOfNotices];
}

class StudentNoticesError extends StudentNoticesStates {
  final DMError error;

  StudentNoticesError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\student\notices\data\notices_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentNoticesRepository {
  final CollectionReference _noticesClient;

  StudentNoticesRepository(this._noticesClient);

  Future<DMTaskState> getAllNotices() async {
    try {
      return await _noticesClient
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Notice> noticesList =
            data.map((e) => Notice.fromDocument(e)).toList();
        print(noticesList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: noticesList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\notices\ui\screens\notices_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/list_extensions.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/student/notices/bloc/notices_states.dart';
import 'package:DigiMess/modules/student/notices/ui/widgets/notices_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentNoticesScreen extends StatefulWidget {
  @override
  _StudentNoticesScreenState createState() => _StudentNoticesScreenState();
}

class _StudentNoticesScreenState extends State<StudentNoticesScreen> {
  List<Notice> noticesList = [];
  List<Notice> recentNoticesList = [];
  List<Notice> oldNoticesList = [];
  bool _isLoading = false;
  StudentNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentNoticesBloc, StudentNoticesStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentNoticesLoading;
          });
          if (state is StudentNoticesError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentNoticesSuccess) {
            final DateTime now = DateTime.now();
            setState(() {
              noticesList = state.listOfNotices;
              final ListResult result = noticesList
                  .splitWhere((element) => element.date.isSameMonthAs(now));
              recentNoticesList = result.matched;
              oldNoticesList = result.unmatched;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentNoticesBloc>(context);
          if (state is StudentNoticesIdle) {
            _bloc.add(GetAllNotices());
            return Container();
          } else if (state is StudentNoticesLoading) {
            return Container();
          } else {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        margin: EdgeInsets.all(20).copyWith(bottom: 0),
                        child: Center(
                          child: Text("Recent notices",
                              style: DMTypo.bold16BlackTextStyle),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          thickness: 1,
                          color: DMColors.primaryBlue,
                        ))
                  ]),
                ),
                SliverList(
                  delegate: getRecentNoticesOrEmptyHint(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                                .copyWith(bottom: 0),
                        child: Center(
                          child: Text("Old notices",
                              style: DMTypo.bold16BlackTextStyle),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          thickness: 1,
                          color: DMColors.primaryBlue,
                        ))
                  ]),
                ),
                SliverList(
                  delegate: getOldNoticesOrEmptyHint(),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        [Container(margin: EdgeInsets.only(bottom: 20))]))
              ],
            );
          }
        },
      ),
    );
  }

  SliverChildDelegate getRecentNoticesOrEmptyHint() {
    if (recentNoticesList == null || recentNoticesList.isEmpty) {
      return SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(50),
          child: Center(
              child: Text("No recent notices",
                  style: DMTypo.bold12MutedTextStyle)),
        )
      ]);
    } else {
      return SliverChildBuilderDelegate((_, index) {
        return NoticesCardItem(notice: recentNoticesList[index]);
      }, childCount: recentNoticesList.length);
    }
  }

  SliverChildDelegate getOldNoticesOrEmptyHint() {
    if (oldNoticesList == null || oldNoticesList.isEmpty) {
      return SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(50),
          child: Center(
              child:
                  Text("No old notices", style: DMTypo.bold12MutedTextStyle)),
        )
      ]);
    } else {
      return SliverChildBuilderDelegate((_, index) {
        return NoticesCardItem(notice: oldNoticesList[index]);
      }, childCount: oldNoticesList.length);
    }
  }
}
  
```  
# modules\student\notices\ui\widgets\notices_card.dart  
```dart
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class NoticesCardItem extends StatelessWidget {
  final Notice notice;

  const NoticesCardItem({Key key, this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20).copyWith(bottom: 0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/notice_alarm.svg",
                  height: 15, width: 15),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(notice.title ?? "Notice",
                        style: DMTypo.bold14BlackTextStyle)),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 20, left: 25, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child:
                          Text(getDate(), style: DMTypo.bold12MutedTextStyle)),
                ],
              ))
        ],
      ),
    );
  }

  String getDate() {
    if (notice == null || notice.date == null) {
      return "Date unavailable";
    } else {
      final DateFormat format = DateFormat("d MMM yyyy");
      return format.format(notice.date);
    }
  }
}
  
```  
# modules\student\payment_dummy\ui\screens\card_details_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardDetailsScreen extends StatelessWidget {
  final AsyncCallback paymentSuccessCallback;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  CardDetailsScreen({Key key, this.paymentSuccessCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 56),
                    color: DMColors.primaryBlue,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: DMColors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Card Payment",
                            style: DMTypo.bold24WhiteTextStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: SvgPicture.asset(
                            "assets/icons/card.svg",
                            height: 20,
                            color: DMColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Text(
                      "Card Number :",
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "0000 0000 0000 0000",
                          isDense: true,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                          counterText: "",
                        ),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 19,
                        inputFormatters: [
                          MaskedInputFormatter("#### #### #### ####",
                              anyCharMatcher: RegExp(r'[0-9]+'))
                        ],
                        style: DMTypo.bold18BlackTextStyle,
                        validator: (value) {
                          final regex = RegExp(r"\d{4} \d{4} \d{4} \d{4}");
                          final bool match = regex.hasMatch(value);
                          return match ? null : "Invalid card number";
                        }),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Expiration Date :",
                                style: DMTypo.bold18BlackTextStyle,
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: DMColors.primaryBlue, width: 2)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: DMColors.primaryBlue, width: 2)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: DMColors.primaryBlue, width: 2)),
                                  counterText: "",
                                  hintText: "MM/YY",
                                  hintStyle: DMTypo.bold18MutedTextStyle,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                maxLines: 1,
                                validator: (value) {
                                  final regex = RegExp(r"\d{2}/\d{2}");
                                  final bool match = regex.hasMatch(value);
                                  return match ? null : "Invalid format";
                                },
                                inputFormatters: [CreditCardExpirationDateFormatter()],
                                style: DMTypo.bold18BlackTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "CVV :",
                                  style: DMTypo.bold18BlackTextStyle,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: DMColors.primaryBlue, width: 2)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: DMColors.primaryBlue, width: 2)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: DMColors.primaryBlue, width: 2)),
                                    counterText: "",
                                    hintText: "XXX",
                                    hintStyle: DMTypo.bold18MutedTextStyle,
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 3,
                                  maxLines: 1,
                                  validator: (value) => value.length == 3 ? null : "Invalid cvv",
                                  obscureText: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: DMTypo.bold18BlackTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20.0, top: 30.0),
                    child: Text(
                      "Card Holder's Name:",
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20.0, top: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: DMColors.primaryBlue, width: 2)),
                        counterText: "",
                        hintText: "John Doe",
                        hintStyle: DMTypo.bold18MutedTextStyle,
                      ),
                      keyboardType: TextInputType.name,
                      maxLength: 20,
                      maxLines: 1,
                      validator: (value) => value.isNotEmpty ? null : "Enter a name",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 70,
                            child: Hero(
                              tag: "proceedBtn",
                              child: DMPillButton(
                                  text: "Proceed",
                                  onPressed: () {
                                    if (_key.currentState.validate()) {
                                      Navigator.pushNamed(context, Routes.PAYMENT_OTP_SCREEN,
                                          arguments: paymentSuccessCallback);
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\payment_dummy\ui\screens\dummy_payments_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DummyPaymentsScreen extends StatelessWidget {
  final String message;
  final int paymentAmount;
  final AsyncCallback paymentSuccessCallback;

  const DummyPaymentsScreen(
      {Key key, this.paymentAmount, this.message, this.paymentSuccessCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            color: DMColors.primaryBlue,
            child: Container(
              margin: EdgeInsets.only(top: 140.0, bottom: 20),
              child: Text(
                "For\n$message",
                style: DMTypo.bold24WhiteTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Text(
              "Amount to be paid",
              style: DMTypo.bold24BlackTextStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Text(
              paymentAmount.getFormattedCurrency(),
              style: DMTypo.bold48BlackTextStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Text(
              "To DigiMess",
              style: DMTypo.bold24MutedTextStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Hero(
                    tag: "proceedBtn",
                    child: DMPillButton(
                        text: "Pay Now",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.PAYMENT_CARD_DETAILS_SCREEN,
                              arguments: paymentSuccessCallback);
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
  
```  
# modules\student\payment_dummy\ui\screens\otp_screen.dart  
```dart
import 'dart:math';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final AsyncCallback paymentSuccessCallback;

  const OtpScreen({Key key, this.paymentSuccessCallback}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentOtp = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
    );

    _showNotification();
  }

  Future<void> _showNotification() async {
    final Random random = Random();
    final int otp = 1000 + random.nextInt(8999);
    currentOtp = otp.toString();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            "com.sharkaboi.DigiMess",
            "OTP Notification channel",
            "Notification channel for showing dummy OTP for payments.",
            importance: Importance.max);
    final NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, "OTP for payment in DigiMess",
        currentOtp, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 120),
                  child: SvgPicture.asset('assets/icons/mail.svg',
                      height: 160, width: 160),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child:
                      Text("Verification", style: DMTypo.bold30BlackTextStyle),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text("You will receive an OTP via SMS",
                      style: DMTypo.bold18MutedTextStyle),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Container(
                    width: 200,
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      appContext: context,
                      controller: _controller,
                      autoDismissKeyboard: true,
                      onChanged: (_) {},
                      textStyle: DMTypo.bold24BlackTextStyle,
                      length: 4,
                      showCursor: false,
                      animationType: AnimationType.none,
                      pinTheme: PinTheme(
                        inactiveColor: DMColors.black,
                        selectedColor: DMColors.black,
                        activeColor: DMColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Hero(
                    tag: "proceedBtn",
                    child: DMPillButton(
                      text: "Verify",
                      onPressed: verifyOtp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive an OTP ?",
                        style: DMTypo.bold14MutedTextStyle,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: InkWell(
                          child: Text(
                            "Send again",
                            style: DMTypo.bold14PrimaryBlueTextStyle,
                          ),
                          onTap: () => {_showNotification()},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyOtp() {
    if (currentOtp == _controller.text) {
      Random rnd = Random();
      int trial = rnd.nextInt(1000);
      if (trial == 13) {
        Navigator.pushNamed(context, Routes.PAYMENT_FAILED_SCREEN);
      } else {
        Navigator.pushNamed(context, Routes.PAYMENT_SUCCESS_SCREEN,
            arguments: widget.paymentSuccessCallback);
      }
    } else {
      DMSnackBar.show(context, "Invalid OTP");
      print("$currentOtp != ${_controller.text}");
    }
  }
}
  
```  
# modules\student\payment_dummy\ui\screens\payment_fail_screen.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentFailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/failed.svg',
                    color: DMColors.primaryBlue, height: 200, width: 160),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    "Payment Failed! ☹",
                    style: DMTypo.bold24PrimaryBlueTextStyle,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Hero(
                    tag: "proceedBtn",
                    child: DMPillButton(
                      text: "Try Again",
                      onPressed: () => navigateBackToDummyPayment(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateBackToDummyPayment(BuildContext context) {
    int i = 3;
    while (i > 0 && Navigator.canPop(context)) {
      i--;
      Navigator.pop(context);
    }
  }
}
  
```  
# modules\student\payment_dummy\ui\screens\payment_success_screen.dart  
```dart
import 'dart:async';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final AsyncCallback paymentSuccessCallback;

  const PaymentSuccessScreen({Key key, this.paymentSuccessCallback}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      int i = 4;
      while (i > 0 && Navigator.canPop(context)) {
        i--;
        Navigator.pop(context);
      }
      await widget.paymentSuccessCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: DMColors.primaryBlue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 160,
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Payment Successful!",
                    style: DMTypo.bold24WhiteTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  
```  
# modules\student\payment_dummy\ui\widgets\otp_text_field.dart  
```dart
import 'package:flutter/material.dart';

class OTPTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
  
```  
# modules\student\payment_dummy\util\dummy_payment_args.dart  
```dart
import 'package:flutter/foundation.dart';

class DummyPaymentArguments {
  final String message;
  final int paymentAmount;
  final AsyncCallback paymentSuccessCallback;

  DummyPaymentArguments(this.message, this.paymentAmount, this.paymentSuccessCallback);
}
  
```  
# modules\student\payment_history\bloc\payments_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/student/payment_history/data/payments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPaymentsBloc extends Bloc<StudentPaymentsEvents, StudentPaymentsStates> {
  final StudentPaymentsRepository _paymentsRepository;

  StudentPaymentsBloc(
      StudentPaymentsStates initialState, this._paymentsRepository)
      : super(initialState);

  @override
  Stream<StudentPaymentsStates> mapEventToState(StudentPaymentsEvents event) async* {
    yield StudentPaymentsLoading();
    if (event is GetAllPayments) {
      final DMTaskState result = await _paymentsRepository.getAllPayments();
      if (result.isTaskSuccess) {
        yield StudentPaymentsSuccess(result.taskResultData);
      } else {
        yield StudentPaymentsError(result.error);
      }
    }
  }
}
  
```  
# modules\student\payment_history\bloc\payments_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StudentPaymentsEvents extends Equatable {
  const StudentPaymentsEvents();
}

class GetAllPayments extends StudentPaymentsEvents {
  @override
  List<Object> get props => [];
}
  
```  
# modules\student\payment_history\bloc\payments_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentPaymentsStates extends Equatable {
  const StudentPaymentsStates();
}

class StudentPaymentsIdle extends StudentPaymentsStates {
  @override
  List<Object> get props => [];
}

class StudentPaymentsLoading extends StudentPaymentsStates {
  @override
  List<Object> get props => [];
}

class StudentPaymentsSuccess extends StudentPaymentsStates {
  final List<Payment> listOfPayments;

  StudentPaymentsSuccess(this.listOfPayments);

  @override
  List<Object> get props => [listOfPayments];
}

class StudentPaymentsError extends StudentPaymentsStates {
  final DMError error;

  StudentPaymentsError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\student\payment_history\data\payments_repository.dart  
```dart
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPaymentsRepository {
  final CollectionReference _paymentsClient;

  StudentPaymentsRepository(this._paymentsClient);

  Future<DMTaskState> getAllPayments() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _paymentsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Payment> paymentsList =
            data.map((e) => Payment.fromDocument(e)).toList();
        print(paymentsList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: paymentsList, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\payment_history\ui\screens\payment_history_screen.dart  
```dart
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_bloc.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_events.dart';
import 'package:DigiMess/modules/student/payment_history/bloc/payments_states.dart';
import 'package:DigiMess/modules/student/payment_history/ui/widgets/payments_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentPaymentHistoryScreen extends StatefulWidget {
  @override
  _StudentPaymentHistoryScreenState createState() =>
      _StudentPaymentHistoryScreenState();
}

class _StudentPaymentHistoryScreenState
    extends State<StudentPaymentHistoryScreen> {
  bool _isLoading = false;
  List<Payment> listOfPayments = [];
  StudentPaymentsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StudentPaymentsBloc, StudentPaymentsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentPaymentsLoading;
          });

          if (state is StudentPaymentsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentPaymentsSuccess) {
            setState(() {
              listOfPayments = state.listOfPayments;
            });
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentPaymentsBloc>(context);
          if (state is StudentPaymentsIdle) {
            _bloc.add(GetAllPayments());
            return Container();
          } else if (state is StudentPaymentsLoading) {
            return Container();
          } else {
            return Container(child: getListOrEmptyHint());
          }
        },
      ),
    );
  }

  Widget getListOrEmptyHint() {
    if (listOfPayments == null || listOfPayments.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text("All payments", style: DMTypo.bold16BlackTextStyle)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Divider(
              color: DMColors.primaryBlue,
              thickness: 1,
            ),
          ),
          Expanded(
            child: Center(
              child: Text("No payments done so far.",
                  style: DMTypo.bold14MutedTextStyle),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: listOfPayments.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Center(
                    child: Text("All payments",
                        style: DMTypo.bold16BlackTextStyle),
                  ));
            } else if (index == 1) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Divider(
                  color: DMColors.primaryBlue,
                  thickness: 1,
                ),
              );
            } else {
              return PaymentsCard(payment: listOfPayments[index - 2]);
            }
          });
    }
  }
}
  
```  
# modules\student\payment_history\ui\widgets\payments_card.dart  
```dart
import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentsCard extends StatelessWidget {
  final Payment payment;

  const PaymentsCard({Key key, this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.circle,
                        color: DMColors.green,
                        size: 15,
                      ),
                    ),
                    Text("Paid on", style: DMTypo.bold14BlackTextStyle),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Text(getDate(), style: DMTypo.bold12MutedTextStyle)),
                Container(
                    margin: EdgeInsets.only(top: 30, left: 25),
                    child: Text(payment.description,
                        style: DMTypo.bold12BlackTextStyle))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(getCurrency(), style: DMTypo.bold18GreenTextStyle))
        ],
      ),
    );
  }

  String getDate() {
    if (payment != null && payment.paymentDate != null) {
      return DateFormat("MMM d yyyy").format(payment.paymentDate);
    } else {
      return "Invalid date";
    }
  }

  String getCurrency() {
    if (payment != null && payment.paymentAmount != null) {
      return payment.paymentAmount.getFormattedCurrency();
    } else {
      return "Invalid amount";
    }
  }
}
  
```  
# modules\student\profile\bloc\profile_bloc.dart  
```dart
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_events.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_states.dart';
import 'package:DigiMess/modules/student/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvents, StudentProfileStates> {
  final StudentProfileRepository _profileRepository;

  StudentProfileBloc(StudentProfileStates initialState, this._profileRepository)
      : super(initialState);

  @override
  Stream<StudentProfileStates> mapEventToState(
      StudentProfileEvents event) async* {
    yield StudentProfileLoading();
    if (event is GetUserDetails) {
      final DMTaskState result = await _profileRepository.getUserDetails();
      if (result.isTaskSuccess) {
        yield StudentProfileFetchSuccess(result.taskResultData);
      } else {
        yield StudentProfileError(result.error);
      }
    } else if (event is CloseAccount) {
      final DMTaskState result = await _profileRepository.closeAccount();
      if (result.isTaskSuccess) {
        yield StudentCloseAccountSuccess();
      } else {
        yield StudentProfileError(result.error);
      }
    }
  }
}
  
```  
# modules\student\profile\bloc\profile_events.dart  
```dart
import 'package:equatable/equatable.dart';

abstract class StudentProfileEvents extends Equatable {
  const StudentProfileEvents();
}

class GetUserDetails extends StudentProfileEvents {
  @override
  List<Object> get props => [];
}

class CloseAccount extends StudentProfileEvents {
  @override
  List<Object> get props => [];
}  
```  
# modules\student\profile\bloc\profile_states.dart  
```dart
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentProfileStates extends Equatable {
  const StudentProfileStates();
}

class StudentProfileIdle extends StudentProfileStates {
  @override
  List<Object> get props => [];
}

class StudentProfileLoading extends StudentProfileStates {
  @override
  List<Object> get props => [];
}

class StudentProfileFetchSuccess extends StudentProfileStates {
  final User userDetails;

  StudentProfileFetchSuccess(this.userDetails);

  @override
  List<Object> get props => [userDetails];
}

class StudentCloseAccountSuccess extends StudentProfileStates {
  StudentCloseAccountSuccess();

  @override
  List<Object> get props => [];
}

class StudentProfileError extends StudentProfileStates {
  final DMError error;

  StudentProfileError(this.error);

  @override
  List<Object> get props => [error];
}
  
```  
# modules\student\profile\data\profile_repository.dart  
```dart
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfileRepository {
  final CollectionReference _usersClient;

  StudentProfileRepository(this._usersClient);

  Future<DMTaskState> getUserDetails() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      return await _usersClient.doc(userId).get().then((value) {
        print(value.data());
        if (!value.exists || value.data() == null) {
          return DMTaskState(
              isTaskSuccess: false,
              taskResultData: null,
              error: DMError(message: "User details not found!"));
        }
        final User userDetails = User.fromDocument(value);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: userDetails, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> closeAccount() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      return await _usersClient
          .doc(userId)
          .update({'isEnrolled': false}).then((_) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString()));
    }
  }
}
  
```  
# modules\student\profile\ui\screens\profile_screen.dart  
```dart
import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/annual_poll_card.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_bloc.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_events.dart';
import 'package:DigiMess/modules/student/profile/bloc/profile_states.dart';
import 'package:DigiMess/modules/student/profile/ui/widgets/profile_card.dart';
import 'package:DigiMess/modules/student/profile/ui/widgets/profile_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _isLoading = false;
  StudentProfileBloc _bloc;
  User _userDetails;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        dismissible: false,
        inAsyncCall: _isLoading,
        child: BlocConsumer<StudentProfileBloc, StudentProfileStates>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is StudentProfileLoading;
            });

            if (state is StudentProfileError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is StudentProfileFetchSuccess) {
              setState(() {
                _userDetails = state.userDetails;
              });
            } else if (state is StudentCloseAccountSuccess) {
              BlocProvider.of<DMBloc>(context).add(LogOutUser());
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<StudentProfileBloc>(context);
            if (state is StudentProfileIdle) {
              _bloc.add(GetUserDetails());
              return Container();
            } else if (state is StudentProfileLoading) {
              return Container();
            } else {
              return ProfileScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileCard(userDetails: _userDetails),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: DMRoundedPrimaryButton(
                                  onPressed: () async {
                                    final bool choice = await DMAlertDialog.show(
                                        context,
                                        "Do you want to close your account?",
                                        description:
                                            "This will permanently close your  mess subcription");
                                    if (choice) {
                                      _bloc.add(CloseAccount());
                                    }
                                  },
                                  text: "CLOSE ACCOUNT",
                                  textStyle: DMTypo.bold16WhiteTextStyle,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: DMRoundedWhiteButton(
                                text: "LOG OUT",
                                onPressed: () async {
                                  final bool choice = await DMAlertDialog.show(
                                      context, "Logout of Digimess?");
                                  if (choice) {
                                    BlocProvider.of<DMBloc>(context)
                                        .add(LogOutUser());
                                  }
                                },
                                textStyle: DMTypo.bold16BlackTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      StudentAnnualPollCard()
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
  
```  
# modules\student\profile\ui\widgets\profile_card.dart  
```dart
import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ProfileCard extends StatelessWidget {
  final User userDetails;

  const ProfileCard({Key key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
            ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 120),
                    child: Text(userDetails.name,
                        style: DMTypo.bold18BlackTextStyle, textAlign: TextAlign.center)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50).copyWith(top: 10),
                  child: Divider(height: 1, color: DMColors.primaryBlue),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Admission number", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.username,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Email ID", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.email,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Date of Birth", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getDob(),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Batch", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getBatch(),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Phone number", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.phoneNumber,
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(bottom: 0),
                    child: Text("Food preference", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 5),
                    child: Text((userDetails.isVeg ? "Veg" : "Non-veg"),
                        style: DMTypo.bold16PrimaryBlueTextStyle, textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
            ], color: DMColors.white, shape: BoxShape.circle),
            child: SvgPicture.asset("assets/icons/profile_circle.svg", height: 150, width: 150),
          )
        ],
      ),
    );
  }

  String getDob() {
    if (userDetails == null || userDetails.dob == null) {
      return "DOB unavailable";
    } else {
      final DateFormat format = DateFormat("d/MM/yyyy");
      return format.format(userDetails.dob);
    }
  }

  String getBatch() {
    if (userDetails == null ||
        userDetails.yearOfAdmission == null ||
        userDetails.yearOfCompletion == null ||
        userDetails.branch == null) {
      return "Batch unavailable";
    } else {
      return "${userDetails.branch.toStringValue()} ${userDetails.yearOfAdmission.year}-${userDetails.yearOfCompletion.year}";
    }
  }
}
  
```  
# modules\student\profile\ui\widgets\profile_scroll_view.dart  
```dart
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScrollView extends StatelessWidget {
  final Widget child;

  const ProfileScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return Container(
          color: DMColors.lightBlue,
          child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      child: SvgPicture.asset("assets/icons/home_bg.svg",
                          fit: BoxFit.cover),
                    ),
                    child,
                  ],
                ),
              )),
        );
      },
    );
  }
}
  
```  
