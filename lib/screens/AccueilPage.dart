import 'package:blogging_app/screens/PostPage.dart';
import 'package:blogging_app/screens/ProfilePageSeenBySomeOne.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:blogging_app/constances.dart';

import 'package:blogging_app/OurWidgets&&Functions/PostWidget.dart';


  class AcceuilPage extends StatefulWidget {
    String id;
    DateTime _currentDate;
    AcceuilPage({this.id, DateTime currentDate});

    @override
    _AcceuilPageState createState() => _AcceuilPageState(id:id);
  }

class _AcceuilPageState extends State<AcceuilPage> {


  String id;
  bool see=false;
  var posts=[];
  bool exist=true;
  TextEditingController comment = TextEditingController();

  _AcceuilPageState({this.id});


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(

      stream: Firestore.instance.collection("Posts").orderBy("nbrpost",descending: true).snapshots(),
      builder: (context,snapshot){

         if(snapshot.hasData){
           return
             ListView(
               children: WidgetsOfPosts().GlobaleList(
                 snapshot: snapshot,
                 id: id,
                 context: context,
                 comment: comment,
               ),
             );

         }

         else{

           return  Padding(
                 padding: EdgeInsets.only(left: 0,right: 0,top: 20),
                 child:Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       "There is no Posts",
                       style: TextStyle(
                           fontSize:20,
                           color: Colors.white,
                           fontFamily: "Montserrat",
                           fontWeight: FontWeight.w800
                       ),
                     ),
                   ],
                 )
           );
         }
      }
    );
  }
}
