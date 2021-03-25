import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/OurWidgets&&Functions/SignUp.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:blogging_app/screens/Profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:blogging_app/screens/SignUp_Screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  AuthService _auth = AuthService();
  GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  bool isVisibile = false;
  bool Waiting = false;
  bool IncorrectPassword=false;
  Userid user;
  @override
  Widget build(BuildContext context) {
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
                            'LOG IN',
                            style: TextStyle(
                              color: Color(0xff2B106A),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            showCursor: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
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
                            ),
                            controller: _EmailController,
                            validator:EmailValidator,
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            obscureText: !isVisibile,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserratmini"
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xff4c4c4c),
                                size: 25,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(!isVisibile ? Icons.visibility_off : Icons
                                    .visibility,
                                  color: Color(0xff4c4c4c),
                                  size: 25,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isVisibile = !isVisibile;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(0xffc7c1cc),
                                fontSize: 20,
                              ),
                            ),
                            controller: _PasswordController,
                            validator: PasswordValidatorAll,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 30),
                            child:Waiting?spin():FlatButton(
                              color: Color(0xff2B106A),
                              minWidth: widthScreen * (0.8),
                              height: 50,
                              onPressed: () async {
                                if (validateAndSave()) {
                                  setState(() {
                                    Waiting=true;
                                  });
                                  dynamic result = await _auth
                                      .LoginWithEmailAndPassword(
                                      _EmailController.text.trim(),
                                      _PasswordController.text);
                                  if (result!=null) {
                                    user = await _auth.UserFromDatabase(result);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            ProfileScreen(id: user.id)));
                                  }

                                  if(result==null){
                                    setState(() {
                                      IncorrectPassword=true;
                                    });
                                    validateAndSave();
                                  }
                                  setState(() {
                                    Waiting=false;
                                  });
                                  IncorrectPassword=false;


                                }
                              },
                              child: Text(
                                'LOG IN',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                  side: BorderSide(color: Color(0xff2B106A))
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Color(0xffFBEAFF),
                            minWidth: widthScreen * (0.8),
                            onPressed: () {
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/google.png", height: 30,),
                                  SizedBox(width: 30,),
                                  Text(
                                    'LOG IN WITH GOOGLE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff2B106A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                                side: BorderSide(
                                  color: Color(0xff2B106A),
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          FlatButton(
                            color: Color(0xffFBEAFF),
                            minWidth: widthScreen * (0.8),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/facebook.png", height: 30,),
                                  SizedBox(width: 30,),
                                  Text(
                                    'LOG IN WITH FACEBOOK',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff2B106A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                                side: BorderSide(
                                  color: Color(0xff2B106A),
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              'Don''t have an account ?',
                              style: TextStyle(
                                color: Color(0xff4B4553),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            color: Color(0xffFBEAFF),
                            minWidth: widthScreen * (0.8),
                            height: 50,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              'SIGN UP',
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
  Widget spin(){
    return Center(
      child: SpinKitThreeBounce(
        color: Color(0xff2B106A),
        size: 30,
      ),
    );
  }
  String PasswordValidatorAll(String value){
    if (value.toString().isEmpty) {
      return "please enter your Password";
    }
    if (value.length < 6) {
      return "Password < 6";
    }
    if(IncorrectPassword){
      return "Password/Email is incorrect !";
    }
    return null;
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



