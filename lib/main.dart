import 'package:blogging_app/screens/CreationOfPost.dart';
import 'package:blogging_app/screens/HomePage.dart';
import 'package:blogging_app/screens/OneCategoryPage.dart';
import 'package:blogging_app/screens/PostPage.dart';
import 'package:blogging_app/screens/ProfilePageSeenBySomeOne.dart';
import 'package:blogging_app/screens/Profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:blogging_app/screens/LogIn_Screen.dart';
import 'package:blogging_app/screens/OnBoradingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' ;
import 'package:flutter/services.dart';

int initScreen;
var UserStatue;
String UserId;
String emailPref;

Future<void> main() async {


  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff220b57),
        statusBarIconBrightness: Brightness.light,
      )
  );

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  emailPref = preferences.getString("email");
  UserId = preferences.getString("userId");

  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);

  runApp(emailPref != null
      ? goToHome()
      : MyApp());

}
class goToHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff220b57),
          statusBarIconBrightness: Brightness.light,
        )
    );
    return MaterialApp(
      title: 'BloggingApp',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        id: UserId,
      ),
    );
  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff220b57),
          statusBarIconBrightness: Brightness.light,
        )
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      theme: ThemeData(

      ),
      title: 'BloggingApp',
      debugShowCheckedModeBanner: false,
      initialRoute: /*initScreen == 1 ? 'LogIn' :*/ 'onboard',
      routes: {
        'LogIn': (context) => LoginScreen(),
        'Home': (context) => HomePage(
              id: UserId,
            ),
        'onboard': (context) => OnBoarding(),
        'Profile': (context) => ProfileScreen(),
        'CreationOfPost': (context) => CreationOfPost(),
        'PostPage': (context) => PostPage(),
        'OneCategoryPage': (context) => OneCategoryPage(),
        'ProfileBySomeone': (context) => ProfilePageSeenBySomeOne(),
      },
    );
  }
}
