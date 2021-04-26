import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/Auth&&FireStore/FireStoreProfile.dart';
import 'package:blogging_app/OurWidgets&&Functions/Profile&&EditeProfile.dart';
import 'package:blogging_app/screens/EditeProfile_Screen.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  AuthService _auth= AuthService();
  final UsersData=Firestore.instance.collection("UsersProfiles");
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return StreamBuilder<Userdata>(
        stream:Fire(id:id).data,
        builder: (context,snapshot) {
          var user=snapshot.data;
          if (snapshot.hasData) {
            return SingleChildScrollView(
                          child:Column(
                            children: [
                              SizedBox(height:30),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:Colors.white,
                                      backgroundImage:user.UserImageUrl==null?AssetImage("assets/images/userwithoutprofileimage.png"):NetworkImage(user.UserImageUrl),
                                      radius: 40,
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
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
                                padding: const EdgeInsets.only(right: 30,left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Simplecolumn(user.nbrposts.toString(),"Postes"),
                                        Simplecolumn(user.nbrfollowers.toString(),"Followers"),
                                        Simplecolumn(user.nbrfollowing.toString(),"Fllowing"),
                                      ],
                                    ),
                                    SizedBox(height:20,),
                                    katba("About",user.Aboutuser),
                                    SizedBox(height:20,),
                                    katbaWithIconEducation("Education",user.Education,EducationIcon()),
                                    SizedBox(height:20,),
                                    katbaWithIconPortfolio("Portfolio",user.Portfolio,PortfolioIcon()),
                                    SizedBox(height:20,),
                                    katba("Skills",user.Skills),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
          }
          else{
            return LoadingScreen();
          }
        }
    );
  }
}

