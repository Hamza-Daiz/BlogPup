import 'package:blogging_app/screens/LogIn_Screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoarding extends StatelessWidget {
  List<PageViewModel> getPages(){
    return[
      PageViewModel(
        decoration: PageDecoration(
          titleTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 25),
          bodyTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 20),
        ),
        image: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.network(
              "https://www.washingtonpost.com/resizer/xx8hf7YOL0KAR3KyIeiOfgg1KCQ=/"
                  "arc-anglerfish-washpost-prod-washpost/public/JVUR6EDDEUI6VATXP3Z7JVD5MQ.jpg",
              height: 300),
        ),
        title: "CRISIS FLUTTER-Project",
        body: "best way to spread the knowledge ",

      ),
      PageViewModel(
        decoration: PageDecoration(
          titleTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 25),
          bodyTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 20),
        ),
        image: Image.network("https://firebasestorage.googleapis.com/v0/b/blogging-app-80378.appspot.com/"
            "o/onboarding%2Fonboarding2.jpeg?alt=media&token=05902ac5-9990-4efb-a5b3-292f67fbac32",
            height: 300),
        title: "CRISIS FLUTTER-Project",
        body: "best way to get the knowledge ",

      ),
      PageViewModel(
        decoration: PageDecoration(
          titleTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 25),
          bodyTextStyle: TextStyle(color: Color(0xff2b106a),fontWeight: FontWeight.bold,fontSize: 20),
        ),
        image: Center(
          child: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/blogging-app-80378.appspot.com/"
                  "o/onboarding%2Fonboarding3.jpeg?alt=media&token=b2a384d2-3930-46f4-aac2-3bb8c2bba715",
              fit: BoxFit.cover,),
        ),
        title: "CRISIS FLUTTER-Project",
        body: "best way to develop the knowledge ",
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
          done: Text('Continue',
            style: TextStyle(
              color: Color(0xff2b106a),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          showNextButton: true,
          onSkip: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>
                    LoginScreen()));
          } ,
          onDone: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>
                    LoginScreen()));
          },
          pages: getPages(),
          dotsDecorator: DotsDecorator(
            activeColor: Color(0xff2b106a),
          ),
        ),
    );
  }
}
