import 'package:blogging_app/Auth&&FireStore/Auth.dart';
import 'package:blogging_app/Auth&&FireStore/FireStoreProfile.dart';
import 'package:blogging_app/screens/AccueilPage.dart';
import 'package:blogging_app/screens/CategoriesPage.dart';
import 'package:blogging_app/screens/CreationOfPost.dart';
import 'package:blogging_app/screens/EditeProfile_Screen.dart';
import 'package:blogging_app/screens/LoadingScreen.dart';
import 'package:blogging_app/screens/LogIn_Screen.dart';
import 'package:blogging_app/screens/Profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:blogging_app/screens/Contact_Screen.dart';

class HomePage extends StatefulWidget {
  String id;
  HomePage({this.id});

  @override
  State<StatefulWidget> createState() {
    return _HomePage(id: id);
  }
}

class _HomePage extends State<HomePage> {
  DateTime _currentDate;

  int mount, day, hour, minute;

  String Getid() {
    return id;
  }

  String id;
  _HomePage({this.id});

  AuthService _auth = AuthService();

  var array = ["Home", "Categories", "Search", "Profile"];

  int index;

  final _Pages = <Widget>[
    Icon(Icons.home, size: 40),
    Icon(Icons.menu, size: 40),
    Icon(
      Icons.person,
      size: 40,
    )
  ];

  @override
  void initState() {
    _currentDate = new DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    var size = MediaQuery.of(context).size;

    return StreamBuilder<Userdata>(
        stream: Fire(id: id).data,
        builder: (context, snapshot) {
          var user = snapshot.data;

          if (snapshot.hasData) {
            return DefaultTabController(
                length: 3,
                child: Scaffold(
                    backgroundColor: Colors.white,

                    // ------ The app Bar --------- :
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Color(0xff2b106a),
                      title: Text(
                        index == 2 ? "profile" : index == 1 ? "Categories" : "Home",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFFBEAFF),
                          fontFamily: "Montserrat",
                        ),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreationOfPost(id: id)));
                            })
                      ],
                    ),

                    // ------ Bottom bar -------- :

                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff2b106a),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          )),
                      padding: EdgeInsets.only(top: 5),
                      child: TabBar(
                        onTap: (value) {
                          setState(() {
                            index = value;
                          });
                          print(index);
                        },
                        labelColor: Colors.greenAccent,
                        unselectedLabelColor: Colors.white,
                        indicatorWeight: 3,
                        indicatorColor: Colors.greenAccent,
                        tabs: _Pages,
                      ),
                    ),

                    //-------Drawer----------- :

                    drawer: Drawer(
                      child: Container(
                        color: Color(0xff2b106a),
                        child: Column(
                          children: [

                            Expanded(
                              child: ListView(
                                children: [
                                  DrawerHeader(
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                            child: user.UserImageUrl == null
                                                ? Image.asset("assets/images/userwithoutprofileimage.png",)
                                                : Image.network(user.UserImageUrl,),
                                          ),
                                          title: Container(
                                            child: Text(
                                              user.Username,
                                              textScaleFactor: MediaQuery.of(context)
                                                  .textScaleFactor,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          subtitle: Container(
                                            child: Text(
                                              user.Location,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontFamily: "Montserratmini",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 3,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditeProfileScreen(
                                                    id: id,
                                                  )));
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        size: 30,
                                        color: Colors.greenAccent,
                                      ),
                                      title: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FormUI(
                                                    UserEmail: Getid(),
                                                  )));
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.support_agent,
                                        size: 30,
                                        color: Colors.greenAccent,
                                      ),
                                      title: Text(
                                        "Contact Us",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50.0, vertical: 20),
                                    child: Divider(
                                      height: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences prefslog =
                                      await SharedPreferences.getInstance();
                                      prefslog.remove("email");
                                      WriteLoginStatue(false);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginScreen()));
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                          Icons.logout,
                                          size: 30,
                                          color: Colors.greenAccent,
                                        ),


                                      title: Text(
                                        "Log Out",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ) ,
                                ],
                              ),
                            ),

                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(bottom: 10,top:10,right: 10),
                              child: InkWell(
                                child: Icon(

                                  Icons.keyboard_return,
                                  size:30,
                                  color: Colors.greenAccent,
                                ),
                                onTap:()=> Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    body: TabBarView(
                      children: [
                        AcceuilPage(id: id, currentDate: _currentDate),
                        CategoriesPage(id: id),
                        ProfileScreen(id: id),
                      ],
                    )));
          } else {
            return LoadingScreen();
          }
        });
  }
}
