import 'package:blogging_app/OurWidgets&&Functions/PostWidget.dart';
import 'package:blogging_app/screens/CreationOfPost.dart';
import 'package:blogging_app/screens/PostPage.dart';
import 'package:blogging_app/screens/ProfilePageSeenBySomeOne.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OneCategoryPage extends StatefulWidget {
  @override
  String Category;
  String id;
  OneCategoryPage({this.id, this.Category});

  _OneCategoryPageState createState() =>
      _OneCategoryPageState(id: id, Category: Category);
}

class _OneCategoryPageState extends State<OneCategoryPage> {
  @override
  String Category;
  String id;
  int j = 0;
  TextEditingController comment = TextEditingController();
  _OneCategoryPageState({this.id, this.Category});

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff2b106a),
        title: Text(
          Category,
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFFFBEAFF),
            fontFamily: "Montserrat",
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("Posts").where("Category", isEqualTo: Category).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView(
                      children: WidgetsOfPosts().GlobaleList(
                        snapshot: snapshot,
                        id: id,
                        context: context,
                        comment: comment,
                      ),
                  ),
              );
            }

            else {

              return Padding(
                  padding: EdgeInsets.only(left: 0, right: 0, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "There is no Posts",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ));
            }
          }),
    );
  }
}
