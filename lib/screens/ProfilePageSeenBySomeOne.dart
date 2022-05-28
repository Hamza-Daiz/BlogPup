import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/Auth&&FireStore/FireStoreProfile.dart';
import 'package:blogging_app/OurWidgets&&Functions/PostWidget.dart';
import 'package:blogging_app/OurWidgets&&Functions/Profile&&EditeProfile.dart';
import 'package:blogging_app/screens/CreationOfPost.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:blogging_app/screens/PostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageSeenBySomeOne extends StatefulWidget {
  String id;
  String pageid;
  ProfilePageSeenBySomeOne({this.id, this.pageid});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageSeenBySomeOne(id: id, pageid: pageid);
  }
}

class _ProfilePageSeenBySomeOne extends State<ProfilePageSeenBySomeOne> {
  String id;
  String pageid;
  int j = 0;
  TextEditingController comment = TextEditingController();

  _ProfilePageSeenBySomeOne({this.id, this.pageid});

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff2b106a),
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFFFBEAFF),
            fontFamily: "Montserrat",
          ),
        ),
      ),

      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("UsersProfiles").document(pageid).snapshots(),
          builder: (context, snapshot) {
            var user = snapshot.data;
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FullScreenWidget(
                            backgroundColor: Colors.black54,
                            child: Hero(
                              tag: "imageProfileSeenBySomeone",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: user["UserImageUrl"] == null
                                    ? Image.asset( "assets/images/userwithoutprofileimage.png",
                                        height: 60,
                                        width: 60,
                                      )
                                    : Image.network( user["UserImageUrl"],
                                        height: 60,
                                        width: 60,
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    snapshot.data["Username"],
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    snapshot.data["Location"],
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

                          Simplecolumn(snapshot.data["nbrposts"].toString(), "Postes"),

                          SizedBox(width: 10,),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(right: 30, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /* Simplecolumn(snapshot.data["nbrfollowers"].toString(),"Followers"),
                              Simplecolumn(snapshot.data["nbrfollowing"].toString(),"Fllowing"),*/
                            ],
                          ),
                          SizedBox(height: 20,),

                          katba("About", snapshot.data["Aboutuser"]),

                          SizedBox(height: 20,),

                          katbaWithIconEducation("Education", snapshot.data["Education"], EducationIcon()),

                          SizedBox(height: 20,),

                          GestureDetector(
                              onTap: () {
                                var url = snapshot.data["Portfolio"];
                                launchURL(url);
                              },
                              child: katbaWithIconPortfolio("Portfolio", snapshot.data["Portfolio"], PortfolioIcon())),

                          SizedBox(height: 20,),

                          katba("Skills", snapshot.data["Skills"]),

                          SizedBox(height: 20,),
                        ],
                      ),
                    ),

                    snapshot.data["nbrposts"] != 0
                        ? Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[300], border: null),
                          )
                        : Container(),

                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("Posts").where("Owner", isEqualTo: pageid).snapshots(),
                        builder: (context, bro) {
                          if (bro.hasData) {
                            return WidgetsOfPosts().GlobalListProfile(
                              id: pageid,
                              idVitor: id,
                              context: context,
                              comment: comment,
                              bro: bro,
                            );
                          }

                          else {
                            return WidgetsOfPosts().NullPost();
                          }
                        }),
                  ],
                ),
              );
            } else {
              return LoadingScreen();
            }
          }),
    );
  }
}
