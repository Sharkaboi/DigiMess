
import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/auth/ui/widgets/background.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final UserType userType;
  const Login({this.userType});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  bool _obscureText = true;
  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {

    return DMScaffold(
      resizeToAvoidBottomInset:false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                child: Text('Sign In',
                    style: DMTypo.bold24BlackTextStyle
                )
            ),
            Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:<Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'username',
                        fillColor: Color.fromRGBO(230,232,239,1),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        contentPadding: new EdgeInsets.only(top: 10.0,bottom: 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: DMColors.primaryBlue
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: DMColors.white
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: DMColors.primaryBlue
                            )
                        ),
                      ),
                      maxLines: 1,
                      validator: (value){
                        if(value.length<8) {
                          return 'Invalid username';
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                  ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'password',
                          fillColor: Color.fromRGBO(230,232,239,1),
                          filled: true,
                          contentPadding: new EdgeInsets.only(top: 10.0,bottom: 10.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: DMColors.primaryBlue
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: DMColors.white
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: DMColors.primaryBlue
                              )
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon:  IconButton(
                            icon:Icon(_obscureText ? Icons.visibility:Icons.visibility_off,),
                            onPressed: _togglePasswordStatus,
                            color: DMColors.mutedBlue,
                          ),
                        ),
                        maxLines: 1,
                        validator: (value){
                          if(value.length<8) {
                            return 'min 8 characters';
                          }
                          else{
                            return null;
                          }
                        },
                        obscureText: _obscureText,
                        onChanged: (val){
                          setState(() {
                            _password = val.trim();
                          });
                        },
                      ),

                    ),
                    Container(
                      width: 200,
                      height: 60,
                      padding: const EdgeInsets.all(5.0),
                      child: Hero(
                          tag: 'signIn-Student',
                        child: DarkButton(
                          text: "Sign In",
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Container(
                            child: Text("Don't have an account?",
                            style: DMTypo.bold18BlackTextStyle,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text("click here to",
                                    style: DMTypo.bold16BlackTextStyle,
                                  ),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, Routes.AUTH_SCREEN);
                                    },
                                    child: Text(" sign up",
                                      style: DMTypo.bold16AccentBlueTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ]
                ),
              ),
            )
          ],
        ),
    );
  }
}