import 'package:blogging_app/screens/PostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
class AcceuilPage extends StatefulWidget {
  String id;
  AcceuilPage({this.id});
  @override
  _AcceuilPageState createState() => _AcceuilPageState(id:id);
}

class _AcceuilPageState extends State<AcceuilPage> {
  String id;
  bool see=false;
  var array=[];
  int i=1;
  _AcceuilPageState({this.id});
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("Posts").snapshots(),
      builder: (context,snapshot){
         if(snapshot.hasData){
           return  Padding(
                 padding: EdgeInsets.only(left: 30,right: 30,top: 20),
                 child:ListView(
                   children:snapshot.data.documents.map(
                       (DocumentSnapshot doc){
                             return
                                Column(
                                children: [
                                 StreamBuilder<DocumentSnapshot>(
                                   stream: Firestore.instance.collection("UsersProfiles").document(doc.data["Owner"]).snapshots(),
                                   builder: (context,snapshot) {
                                     return Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         CircleAvatar(
                                           backgroundImage:snapshot.hasData?(snapshot.data["UserImageUrl"]!=null?
                                           NetworkImage(snapshot.data["UserImageUrl"]):AssetImage("assets/images/userwithoutprofileimage.png")):
                                           AssetImage("assets/images/userwithoutprofileimage.png"),
                                           backgroundColor: Colors.white,
                                           radius: 30,
                                         ),
                                         SizedBox(width: 15,),
                                         Expanded(
                                           child: Container(
                                             padding: EdgeInsets.only(top: 10),
                                             child: Text(
                                               snapshot.hasData?snapshot.data['Username']:" ",
                                               style: TextStyle(
                                                   fontSize:18,
                                                   color: Colors.black,
                                                   fontFamily: "Montserrat",
                                                   fontWeight: FontWeight.w800
                                               ),
                                             ),
                                           ),
                                         ),
                                         IconButton(
                                             icon: Icon(Icons.circle,color:Color(0xff2b106a),),
                                             onPressed:(){
                                             }),
                                       ],
                                     );
                                   }
                                 ),
                                 SizedBox(height: 10,),
                                 Container(
                                   width: double.infinity,
                                   child:Text(
                                     doc.data["Title"],
                                     style: TextStyle(
                                         fontSize:17,
                                         color: Colors.black,
                                         fontFamily: "Montserratmini",
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 10,),
                                 doc.data["ImageUrl"]!=null?
                                 Container(
                                   width: double.infinity,
                                   height: 300,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(20),
                                       color: Colors.black,
                                       image: DecorationImage(
                                         image: NetworkImage(doc.data["ImageUrl"]),
                                           fit: BoxFit.fitHeight
                                       )
                                   ),
                                 ):Text(""),
                                 SizedBox(height: 5,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: [
                                         IconButton(
                                             icon: Icon(
                                               Icons.favorite,
                                               size: 30,
                                               color: Colors.grey,
                                             ),
                                             onPressed: (){

                                             }
                                         ),
                                         Text(
                                           doc.data["nbrlikes"].toString(),
                                           style: TextStyle(
                                               fontSize:15,
                                               color: Colors.black,
                                               fontFamily: "Montserratmini",
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),
                                         SizedBox(width: 5,),
                                         IconButton(
                                             icon: Icon(
                                               Icons.comment,
                                               size: 30,
                                               color: Colors.grey,
                                             ),
                                             onPressed: (){
                                             }
                                         ),
                                         Text(
                                           doc.data["nbrcomments"].toString(),
                                           style: TextStyle(
                                               fontSize:15,
                                               color: Colors.black,
                                               fontFamily: "Montserratmini",
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),
                                       ],
                                     ),
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                       decoration: BoxDecoration(
                                         color: Colors.grey[300],
                                         borderRadius: BorderRadius.circular(5),
                                       ),
                                       child: Text(
                                         doc.data["Category"],
                                         style: TextStyle(
                                             fontSize:15,
                                             color: Colors.black,
                                             fontFamily: "Montserratmini",
                                             fontWeight: FontWeight.w500
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                                 SizedBox(height: 10,),
                                 Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Align(
                                         alignment: Alignment.centerLeft,
                                         child: Container(
                                           child: Text(
                                             doc.data["Text"],
                                             maxLines:2,
                                             style: TextStyle(
                                                 fontSize:17,
                                                 color: Colors.black,
                                                 fontFamily: "Montserratmini",
                                                 fontWeight: FontWeight.w500
                                             ),
                                           ),
                                         ),
                                       ),
                                       RichText(
                                         text:TextSpan(
                                             text:"See more",
                                             style:TextStyle(
                                               fontSize:17,
                                               color: Colors.blue,
                                               fontFamily: "Montserratmini",
                                               fontWeight: FontWeight.w500,
                                               decoration:TextDecoration.underline,
                                             ),
                                             recognizer: TapGestureRecognizer()
                                               ..onTap = () {
                                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage(postid:doc.documentID,)));
                                               }),
                                       )
                                     ]
                                 ),
                                 SizedBox(height: 15,),
                                 Container(
                                   height: 1,
                                   width:double.infinity,
                                   decoration: BoxDecoration(
                                     color: Colors.grey[200],
                                     border: Border.all(color:Colors.grey)
                                   ),
                                 ),
                                 SizedBox(height: 15,),
                               ],
                             );
                           }
                   ).toList()
                 )
           );
         }
         else{
           return  Padding(
                 padding: EdgeInsets.only(left: 30,right: 30,top: 20),
                 child:Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       "There is no Posts",
                       style: TextStyle(
                           fontSize:20,
                           color: Colors.black,
                           fontFamily: "Montserrat",
                           fontWeight: FontWeight.w800
                       ),
                     )
                   ],
                 )
           );
         }
      }
    );
  }

}
