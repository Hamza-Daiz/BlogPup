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
  final _Pages=<Widget>[
    Icon(Icons.home,size: 40),
    Icon(Icons.menu,size: 40),
    Icon(Icons.search_rounded,size: 40),
    Icon(Icons.person,size: 40,)
  ];
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return StreamBuilder<Userdata>(
        stream:Fire(id:id).data,
        builder: (context,snapshot) {
          var user=snapshot.data;
          if (snapshot.hasData) {
            return DefaultTabController(
                length: 4,
                child: Scaffold(
                    backgroundColor:Colors.white,
                    appBar:AppBar(
                      centerTitle: true,
                      backgroundColor:Color(0xff2b106a),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize:22,
                          color: Color(0xFFFBEAFF),
                          fontFamily:"Montserrat",
                        ),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.add,color: Colors.white,size: 30,),
                            onPressed: (){}
                        )],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight:Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                      ),
                    ),
                    bottomNavigationBar:Container(
                      decoration: BoxDecoration(
                          color: Color(0xff2b106a),
                          borderRadius: BorderRadius.only(
                            topRight:Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                      ),
                      padding: EdgeInsets.only(top: 10),
                      child: TabBar(
                        labelColor: Colors.greenAccent,
                        unselectedLabelColor: Colors.white,
                        indicatorWeight: 3,
                        indicatorColor:Colors.greenAccent,
                        tabs:_Pages,
                      ),
                    ),
                    drawer: Drawer(),
                    body:TabBarView(
                      children:[
                        Center(child: Text("Hola",style: TextStyle(fontSize: 60),)),
                        Center(child: Text("Hala",style: TextStyle(fontSize: 60),)),
                        Center(child: Text("Hila",style: TextStyle(fontSize: 60),)),
                        SingleChildScrollView(
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
                        ),
                      ],
                    )
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

