import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  final UserType userType;

  const LoginScreen({this.userType});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  bool _obscureText = true;

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10).copyWith(top: 0),
                child: Text('SIGN IN', style: DMTypo.bold24BlackTextStyle)),
            Form(
              key: _formKey,
              child: Column(children: [
                Container(
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
                ),
                Container(
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
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Hero(
                    tag: 'signUp-Staff',
                    child: DMPillButton(
                      text: "Sign In",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final username = _usernameController.text;
                          final password = _passController.text;
                          if (widget.userType == UserType.STUDENT) {
                            await SharedPrefRepository.setUserType(UserType.STUDENT);
                            await SharedPrefRepository.setUsername("20418076");
                            await SharedPrefRepository.setTheUserId("QXe986cVzOQUgQgC2ETo");
                            await Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.MAIN_SCREEN_STUDENT, (route) => false);
                          } else {
                            await SharedPrefRepository.setUserType(UserType.STAFF);
                            await SharedPrefRepository.setUsername("20418076");
                            await SharedPrefRepository.setTheUserId("QXe986cVzOQUgQgC2ETo");
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.MAIN_SCREEN_STAFF, (route) => false);
                          }
                        }
                      },
                    ),
                  ),
                ),
                Container(
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
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
