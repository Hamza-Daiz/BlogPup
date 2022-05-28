
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/Auth&&FireStore/FireStoreProfile.dart';
import 'package:blogging_app/OurWidgets&&Functions/Profile&&EditeProfile.dart';
import 'package:blogging_app/screens/EditeProfile_Screen.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:blogging_app/screens/PostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:full_screen_image/full_screen_image.dart';


import 'package:blogging_app/OurWidgets&&Functions/PostWidget.dart';

class ProfileScreen extends StatefulWidget {

  String id;
  ProfileScreen({this.id});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen(id:id);
  }
}

class _ProfileScreen extends State<ProfileScreen> {

  String id;
  _ProfileScreen({this.id});
  AuthService _auth= AuthService();String hamoda="";
  final UsersData=Firestore.instance.collection("UsersProfiles");

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
    
    TextEditingController comment=TextEditingController();
    int j=0;

    return StreamBuilder<Userdata>(

        stream:Fire(id:id).data,

        builder: (context,snapshot) {

          var user=snapshot.data;

          if (snapshot.hasData) {
            return SingleChildScrollView(
                          child:Column(
                            children: [
                              SizedBox(height:10),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  FullScreenWidget(
                                  backgroundColor: Colors.black54 ,
                                    child: Hero(
                                     tag: "imageProfile",
                                       child:ClipRRect(
                                         borderRadius: BorderRadius.circular(40),
                                         child: user.UserImageUrl == null ?
                                         Image.asset(
                                             "assets/images/userwithoutprofileimage.png",
                                           height: 60,
                                           width: 60,
                                         ) :
                                         Image.network(
                                           user.UserImageUrl, height: 60,
                                           width: 60,
                                         ),
                                       ),
                                       ),
                                  ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                      child : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              user.Username,
                                              textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                              style: TextStyle(
                                                  fontSize:20,
                                                  color: Colors.black,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w800
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 5,),

                                          Container(
                                            child: Text(
                                              user.Location,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontFamily: "Montserratmini",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    IconButton(
                                        icon: Icon(Icons.settings,color:Color(0xff2b106a),),
                                        onPressed:(){
                                          Navigator.push(context, MaterialPageRoute(builder:(context)=>EditeProfileScreen(id:id,)));
                                        }),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),

                              Padding(
                                padding: const EdgeInsets.only(right: 20,left: 20),

                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Simplecolumn(user.nbrposts.toString(),"Postes"),
                                       /* Simplecolumn(user.nbrfollowers.toString(),"Followers"),
                                        Simplecolumn(user.nbrfollowing.toString(),"Fllowing"),*/
                                      ],
                                    ),

                                    SizedBox(height:20,),
                                    katba("About",user.Aboutuser),
                                    SizedBox(height:20,),
                                    katbaWithIconEducation("Education",user.Education,EducationIcon()),
                                    SizedBox(height:20,),
                                    GestureDetector(
                                      onTap: (){
                                          var url = user.Portfolio ;
                                          launchURL(url);
                                      },
                                        child: katbaWithIconPortfolio("Portfolio",user.Portfolio.contains("https://")?user.Portfolio: "https://"+user.Portfolio ,PortfolioIcon())
                                    ),
                                    SizedBox(height:20,),
                                    katba("Skills",user.Skills),
                                    SizedBox(height:20,),
                                  ],
                                ),
                              ),
                              user.nbrposts!=0?Container(
                                height: 10,
                                width:double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border:null
                                ),
                              ):Container(),

                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection("Posts").where("Owner",isEqualTo:id).snapshots(),

                                  builder: (context,bro){
                                    if(bro.hasData){
                                      return
                                        WidgetsOfPosts().GlobalListProfile(
                                          id: id,
                                          idVitor: id,
                                          context: context,
                                          comment: comment,
                                         bro: bro,
                                        )
                                    ;}
                                    else{
                                      return  WidgetsOfPosts().NullPost();
                                    }
                                  }
                              ),
                                ],
                              )
                        );
          }
          else{
            return LoadingScreen();
          }
        }
    );
  }
}

