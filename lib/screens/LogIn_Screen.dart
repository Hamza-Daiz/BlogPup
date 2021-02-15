import 'package:flutter/material.dart';

import 'package:blogging_app/screens/SignUp_Screen.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
  String _email;
  String _name;
  String _password;
  bool isVisibile = true;

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffFBEAFF),
      body:  Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: globalKey,
              child: Container(
                width: widthScreen * (0.8),
                //height: heightScreen * (1.5),
                margin: EdgeInsets.symmetric(horizontal:30, ),
                child: Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
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
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: (String value){
                          if(value.isEmpty)
                          {
                            return 'Please enter your email';
                          }
                          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20,),

                      TextFormField(
                        obscureText: isVisibile,
                        showCursor: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xff4c4c4c),
                            size: 25,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisibile
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "please enter your Password";
                          }
                          if (value.length < 6) {
                            return "Password < 6";
                          }
                          return null;
                        },
                      ),

                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: FlatButton(
                          color: Color(0xff2B106A),
                          minWidth: widthScreen*(0.8),
                          height: 50,
                          onPressed: (){
                            validateAndSave();
                            if (globalKey.currentState.validate()) {
                              print(_name);
                            }
                            print(_email);
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
                        minWidth: widthScreen*(0.8),
                        onPressed: (){},
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            
                            children: [
                              Image.asset("assets/images/google.png",height: 30,),

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
                        minWidth: widthScreen*(0.8),
                        onPressed: (){},
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset("assets/images/facebook.png",height: 30,),

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
                        padding: const EdgeInsets.only(top:50.0),
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
                        minWidth: widthScreen*(0.8),
                        height: 50,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
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
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
