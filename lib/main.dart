import 'package:blogging_app/screens/SignUp_Screen.dart';

import 'package:flutter/material.dart';
import 'package:blogging_app/screens/LogIn_Screen.dart';
import 'package:blogging_app/screens/OnBoradingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen',1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BloggingApp',
      initialRoute: initScreen != 0 ? 'onboard' : 'LogIn',
      routes: {
        'LogIn' : (context)=> LoginScreen(),
        'onboard' : (context)=> OnBoarding(),
        //'homeScreen' : (context)=> HomeScreen(),
      },
    );
  }
}
