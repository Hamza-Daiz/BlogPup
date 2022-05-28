import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/OurWidgets&&Functions/SignUp.dart';
import 'package:blogging_app/main.dart';
import 'package:blogging_app/screens/HomePage.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:blogging_app/screens/LogIn_Screen.dart';
import 'package:blogging_app/screens/Profile_Screen.dart';
import 'package:blogging_app/screens/ResetPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blogging_app/screens/SignUp_Screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final auth = FirebaseAuth.instance;
  GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
  final _EmailController = TextEditingController();
  String  _email;


  @override
  Widget build(BuildContext context) {

    print("${ReadLoginStatue()}");
    final double widthScreen = MediaQuery
        .of(context)
        .size
        .width;
    final double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Color(0xffFBEAFF),
      body: Center(

        child: SingleChildScrollView(

          child: SafeArea(

            child:  Form(
              key: globalKey,

              child: Container(
                width: widthScreen * (0.8),
                //height: heightScreen * (1.5),

                margin: EdgeInsets.symmetric(horizontal: 30,),

                child: Center(
                  child:
                  Column(
                    children: [

                      Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Color(0xff2B106A),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // email :
                      TextFormField(
                        showCursor: true,

                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red
                                )
                            ),
                            focusedErrorBorder:UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red
                                )
                            ),
                            errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserratmini"
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff4c4c4c),
                              size: 25,
                            ),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              color: Color(0xffc7c1cc),
                              fontSize: 20,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff2B106A),
                                    width: 2
                                )
                            )
                        ),

                        controller: _EmailController,

                        validator:EmailValidator,

                        onChanged: (value){
                          setState(() {
                             _email=value;
                          });
                        },
                      ),

                      SizedBox(height: 10,),

                      FlatButton(
                        color: Color(0xffFBEAFF),
                        minWidth: widthScreen * (0.8),
                        height: 50,
                        onPressed: () {
                          if(validateAndSave()) {

                              auth.sendPasswordResetEmail(email: _email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("A password reset link has been sent to $_email"),
                                  ));
                              Navigator.of(context).pop();

                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("please enter a valid email"),
                            ));
                          }





                        },
                        child: Text(
                          'Send Request',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff2B106A),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                            side: BorderSide(
                              color: Color(0xff2B106A),
                            )
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
