import 'dart:ui';
import 'package:blogging_app/screens/EditePost_Screen.dart';
import 'package:blogging_app/screens/ProfilePageSeenBySomeOne.dart';
import 'package:blogging_app/screens/PostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:blogging_app/constances.dart';




class WidgetsOfPosts {

  List GlobaleList({AsyncSnapshot<QuerySnapshot> snapshot, String id ,BuildContext context, TextEditingController comment }){

    return snapshot.data.documents.map((DocumentSnapshot docPostInfo){
          return Column  (
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),

                  //Section 1 :

                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection("UsersProfiles").document(docPostInfo.data["Owner"]).snapshots(),

                      builder: (context,docOwnerInfo) {

                        if(docOwnerInfo.hasData){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal:30.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: CircleAvatar(
                                    backgroundImage:
                                    docOwnerInfo.hasData ? ( docOwnerInfo.data["UserImageUrl"] != null ?
                                    NetworkImage(docOwnerInfo.data["UserImageUrl"]):AssetImage("assets/images/userwithoutprofileimage.png")) :
                                    AssetImage("assets/images/userwithoutprofileimage.png"),

                                    backgroundColor: Colors.white,
                                    radius: 25,
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=> ProfilePageSeenBySomeOne(id:id,pageid: docPostInfo.data["Owner"],)));
                                  },
                                ),

                                SizedBox(width: 15,),

                                Expanded(
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start ,
                                      children: [
                                        Text(
                                          snapshot.hasData ? docOwnerInfo.data['Username'] : "Unknown",
                                          style: TextStyle(
                                              fontSize:17,
                                              color: Colors.black,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w800
                                          ),
                                          maxLines: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:2.0),
                                          child: Text(
                                            "le : "+docPostInfo.data["datepub"],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=>ProfilePageSeenBySomeOne(id:id,pageid: docPostInfo.data ["Owner"],)));
                                    },
                                  ),
                                ),

                                docPostInfo.data["Owner"] == id ?
                                PopupMenuButton<String>(
                                    onSelected:(String value){
                                      if(value=="Modify"){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>EditePostScreen(id:id,postid:docPostInfo.documentID,),),
                                        );
                                      }
                                      else{
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context)=>AlertDialog(
                                              title: Text(
                                                "Delete Post",
                                                style:TextStyle(
                                                    color:Colors.black,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              content:Text(
                                                "Are you sure you want to delete this post?",
                                                style:TextStyle(
                                                    fontSize:16,
                                                    color:Colors.black,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              actions: [
                                                FlatButton(
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        color:Colors.blue,
                                                        fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Firestore.instance.collection("Posts").document(docPostInfo.documentID).collection("Comments").getDocuments().then(
                                                            (bee){
                                                          for(DocumentSnapshot joo in bee.documents){
                                                            joo.reference.delete();
                                                          }
                                                        }
                                                    );
                                                    Firestore.instance.collection("Posts").document(docPostInfo.documentID).delete();
                                                    Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                        {
                                                          "nbrposts":FieldValue.increment(-1)
                                                        }
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        color:Colors.blue,
                                                        fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                              backgroundColor: Colors.white,

                                            )
                                        );
                                      }
                                    },
                                    offset: Offset(0, 400),

                                    icon:Icon(Icons.more_horiz, color:Color(0xff2b106a)),

                                    itemBuilder:(context)=>[
                                      PopupMenuItem(
                                        value:"Modify",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,color:Color(0xff2b106a),size:20),
                                            SizedBox(width: 5,),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  "Modify",
                                                  style:TextStyle(
                                                      fontSize:16,
                                                      color:Color(0xff2b106a),
                                                      fontFamily: "Montserrat",
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value:"Delete",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,color:Colors.red,size:20),
                                            SizedBox(width: 5,),
                                            Container(
                                              child: Text(
                                                "Delete",
                                                style:TextStyle(
                                                    fontSize:16,
                                                    color:Colors.red,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]

                                ) : Container(),
                              ],
                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                      }
                  ),

                  SizedBox(height: 5,),

                  //Title :

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0),
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 0.8) ,
                      margin: EdgeInsets.only(left: 5.0),
                      child:Text(
                        docPostInfo.data["Title"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:17,
                          color: Colors.black,
                          fontFamily: "Montserratmini",
                          fontWeight: FontWeight.w700,

                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  // Image Post :

                  docPostInfo.data["ImageUrl"] != null ?
                  GestureDetector(
                    onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage(postid:docPostInfo.documentID,))),
                    child: Hero(
                      tag: "HomePostImage" + docPostInfo.data["ImageUrl"],
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        child: Image.network(docPostInfo.data["ImageUrl"],fit: BoxFit.cover,),
                      ),
                    ),
                  ):
                  Container(),

                  SizedBox(height: 5,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Row(
                          children: [
                            // icon Like + functioning of post likes :
                            StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance.collection("UsersProfiles").document(id).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: List.from(snapshot.data["LickedPosts"]).contains(docPostInfo.documentID) ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          if (List.from(snapshot.data["LickedPosts"]).contains(docPostInfo.documentID)) {
                                            Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                {
                                                  "LickedPosts": FieldValue.arrayRemove(
                                                      [
                                                        docPostInfo.documentID
                                                      ]
                                                  ),
                                                }
                                            );

                                            Firestore.instance.collection("Posts").document(docPostInfo.documentID).updateData(
                                                {
                                                  "nbrlikes":FieldValue.increment(-1)
                                                }
                                            );
                                          }
                                          else {
                                            Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                {
                                                  "LickedPosts": FieldValue.arrayUnion([docPostInfo.documentID])
                                                }
                                            );
                                            Firestore.instance.collection("Posts").document(docPostInfo.documentID)
                                                .updateData(
                                                {
                                                  "nbrlikes":FieldValue.increment(1)
                                                }
                                            );
                                          }
                                        }
                                    );
                                  }
                                  else{
                                    return Icon(
                                      Icons.favorite,
                                      size: 30,
                                      color: Colors.grey,
                                    );
                                  }
                                }
                            ),

                            //nbr of likes :
                            Text(
                              docPostInfo.data["nbrlikes"].toString(),
                              style: TextStyle(
                                  fontSize:15,
                                  color: Colors.black,
                                  fontFamily: "Montserratmini",
                                  fontWeight: FontWeight.w500
                              ),
                            ),

                            SizedBox(width: 5,),

                            // Comment :

                            IconButton(
                                icon: Icon(
                                  Icons.comment,
                                  size: 30,
                                  color: docPostInfo.data["nbrcomments"] != 0 ? Color(0xff2b106a):Colors.grey,
                                ),
                                onPressed: ()=>{
                                  comment.clear(),

                                  showModalBottomSheet(
                                      context: context,

                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight:Radius.circular(20),
                                      )),

                                      useRootNavigator: true,

                                      builder: (context){
                                        return  GestureDetector(
                                          onTap: (){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          },
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream:  Firestore.instance.collection("Posts").document(docPostInfo.documentID)
                                                  .collection("Comments").snapshots(),
                                              builder: (context, snapshot) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      height: 15,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color:Color(0xff2b106a),
                                                          borderRadius: BorderRadius.only(
                                                            topRight:Radius.circular(20),
                                                            topLeft: Radius.circular(20),
                                                          )
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),

                                                    Expanded(
                                                        child :
                                                        StreamBuilder<DocumentSnapshot>(
                                                            stream : Firestore.instance.collection("Posts").document(docPostInfo.documentID).snapshots(),
                                                            builder : (context, bim) {
                                                              if(bim.hasData){
                                                                return Container(
                                                                  color:Colors.white,
                                                                  child: bim.data["nbrcomments"]!= 0 ? (
                                                                      snapshot.hasData ?
                                                                      ListView(
                                                                        children:snapshot.data.documents.map(
                                                                                (DocumentSnapshot docCommentInfo){
                                                                              return Column(
                                                                                children: [
                                                                                  StreamBuilder<DocumentSnapshot> (
                                                                                      stream: Firestore.instance.collection("UsersProfiles").document(docCommentInfo.data["Owner"]).snapshots(),
                                                                                      builder: (context, bro)  {
                                                                                        if(bro.hasData  ){
                                                                                          return Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SizedBox(width: 5,),

                                                                                              CircleAvatar(
                                                                                                backgroundImage: bro.hasData  ?
                                                                                                bro.data["UserImageUrl"]!=null?
                                                                                                NetworkImage(bro.data["UserImageUrl"]):
                                                                                                AssetImage("assets/images/userwithoutprofileimage.png"):
                                                                                                AssetImage("assets/images/userwithoutprofileimage.png"),
                                                                                                backgroundColor: Colors.white,
                                                                                                radius: 20,
                                                                                              ),

                                                                                              SizedBox(width: 5,),

                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.grey[200],
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                  ),
                                                                                                  child:Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Expanded(
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                child: Text(
                                                                                                                  bro.data["Username"],
                                                                                                                  style: TextStyle(
                                                                                                                    fontSize: 16,
                                                                                                                    color: Colors.black,
                                                                                                                    fontFamily: "Montserratmini",
                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),

                                                                                                              SizedBox(height: 5,),

                                                                                                              Container(
                                                                                                                  child: Text(
                                                                                                                    docCommentInfo.data["Content"] ,
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: 16,
                                                                                                                        color: Colors.black,
                                                                                                                        fontFamily: "Montserratmini"
                                                                                                                    ),)
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),

                                                                                                        docCommentInfo.data["Owner"] == id || docPostInfo.data["Owner"] == id ?
                                                                                                        IconButton(
                                                                                                          icon:Icon(Icons.delete),
                                                                                                          color: KprimaryColor,
                                                                                                          onPressed: (){
                                                                                                            showDialog(
                                                                                                              context: context, builder: (context)=>
                                                                                                                AlertDialog(
                                                                                                                  title: Text(
                                                                                                                      "You want delete this comment ?"
                                                                                                                  ),
                                                                                                                  actions: [
                                                                                                                    TextButton(
                                                                                                                      onPressed: ()async{

                                                                                                                        await  Firestore.instance.collection("Posts")
                                                                                                                            .document(docPostInfo.documentID).collection("Comments")
                                                                                                                            .document(docCommentInfo.documentID).delete();

                                                                                                                        await  Firestore.instance.collection("Posts")
                                                                                                                            .document(docPostInfo.documentID).updateData(
                                                                                                                            {
                                                                                                                              "nbrcomments":FieldValue.increment(-1),
                                                                                                                            });
                                                                                                                        Navigator.pop(context);
                                                                                                                      },
                                                                                                                      child: Text(
                                                                                                                          "Yes"
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    FlatButton(onPressed: (){}, child: Text("No"),),
                                                                                                                  ],
                                                                                                                ),
                                                                                                            );

                                                                                                          },

                                                                                                        ) :
                                                                                                        Container(),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ) ,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: 5,),
                                                                                            ],
                                                                                          );
                                                                                        }
                                                                                        else{
                                                                                          return Text("");
                                                                                        }
                                                                                      }
                                                                                  ),
                                                                                  SizedBox(height: 15,),
                                                                                ],
                                                                              );

                                                                            }
                                                                        ).toList(),
                                                                      ):Text("")
                                                                  ):
                                                                  SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/comments.jpg",
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        Text(
                                                                          "No Comments Yet",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.grey
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Be the first to comment",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.grey
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 20,)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              else{
                                                                return Container();
                                                              }
                                                            }
                                                        )
                                                    ),

                                                    Row(
                                                      children: [
                                                        SizedBox(width: 5,),

                                                        StreamBuilder<DocumentSnapshot>(

                                                            stream:Firestore.instance.collection("UsersProfiles").
                                                            document(id).snapshots(),
                                                            builder: (context,boom) {

                                                              if(boom.hasData){
                                                                return CircleAvatar(
                                                                  backgroundColor:Colors.white,
                                                                  backgroundImage:boom.hasData?
                                                                  boom.data["UserImageUrl"]!=null?
                                                                  NetworkImage(boom.data["UserImageUrl"]):
                                                                  AssetImage("assets/images/userwithoutprofileimage.png"):
                                                                  AssetImage("assets/images/userwithoutprofileimage.png"),
                                                                  radius: 20,
                                                                );
                                                              }
                                                              else {
                                                                return  CircleAvatar(
                                                                  backgroundColor:Colors.white,
                                                                  radius: 20,
                                                                );
                                                              }
                                                            }
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Expanded(
                                                          child: TextFormField(
                                                              controller: comment,
                                                              keyboardType: TextInputType.text,
                                                              style: TextStyle(
                                                                  color:Colors.black,
                                                                  fontSize: 16,
                                                                  fontFamily: "Montserratmini"
                                                              ),
                                                              decoration:InputDecoration(
                                                                  suffixIcon: IconButton(
                                                                    icon:Icon(
                                                                      Icons.send_rounded,
                                                                    ),
                                                                    onPressed: () async{
                                                                      if(!comment.text.isEmpty){
                                                                        await Firestore.instance.collection("Posts").document(docPostInfo.documentID).
                                                                        collection("Comments").document().setData(
                                                                            {
                                                                              "Owner":id,
                                                                              "Content":comment.text
                                                                            }
                                                                        );
                                                                        comment.clear();
                                                                        await Firestore.instance.collection("Posts")
                                                                            .document(docPostInfo.documentID).updateData(
                                                                            {
                                                                              "nbrcomments":FieldValue.increment(1)
                                                                            }
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                  contentPadding: EdgeInsets.only(top: 20,left: 20),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(color:Color(0xffFBEAFF))
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: Colors.grey[200],
                                                                  hintText: "Write a comment...",
                                                                  hintStyle: TextStyle(
                                                                      fontSize: 16,
                                                                      color: Colors.black,
                                                                      fontFamily: "Montserratmini"
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    borderSide: BorderSide(color: Color(0xff2b106a),width: 2),
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,)
                                                  ],
                                                );
                                              }
                                          ),
                                        );
                                      }
                                  )
                                }
                            ),
                            Text(
                              docPostInfo.data["nbrcomments"].toString(),
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
                            docPostInfo.data["Category"],
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
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  docPostInfo.data["Text"],
                                  maxLines:2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:17,
                                      color: Colors.black,
                                      fontFamily: "Montserratmini",
                                      fontWeight: FontWeight.w500

                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5,),

                          GestureDetector(
                              child: Text(
                                "See more..",
                                style:TextStyle(
                                  fontSize:17,
                                  color: Color(0xff2b106a),
                                  fontFamily: "Montserratmini",
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                              onTap:() {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage(postid:docPostInfo.documentID,)));
                              }
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              ),

              Container(
                height:10,
                width:double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
              ),
            ],
          );
        }
        ).toList();
  }

  Widget GlobalListProfile({AsyncSnapshot<QuerySnapshot> bro, String id, String idVitor, BuildContext context, TextEditingController comment }){
    return Column(
        children:bro.data.documents.map(
                (DocumentSnapshot docPostInfo){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Column(
                      children: [
                        StreamBuilder<DocumentSnapshot>(

                            stream: Firestore.instance.collection("UsersProfiles").document(docPostInfo.data["Owner"]).snapshots(),

                            builder: (context,snapshot) {

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    CircleAvatar(
                                      backgroundImage:snapshot.hasData?(snapshot.data["UserImageUrl"]!=null?
                                      NetworkImage(snapshot.data["UserImageUrl"]):AssetImage("assets/images/userwithoutprofileimage.png")):
                                      AssetImage("assets/images/userwithoutprofileimage.png"),
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start ,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              snapshot.hasData?snapshot.data['Username']:" ",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize:17,
                                                  color: Colors.black,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w800
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(top:2.0),
                                            child: Text(
                                              "le : "+docPostInfo.data["datepub"],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    id == idVitor ?
                                    PopupMenuButton<String>(
                                        onSelected:(String value){
                                          if(value=="Modify"){
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context)=>EditePostScreen(id:id,postid:docPostInfo.documentID,),),
                                            );
                                          }
                                          else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context)=>AlertDialog(
                                                  title: Text(
                                                    "Delete Post",
                                                    style:TextStyle(
                                                        color:Colors.black,
                                                        fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  content:Text(
                                                    "Are you sure you want to delete this post?",
                                                    style:TextStyle(
                                                        fontSize:16,
                                                        color:Colors.black,
                                                        fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            fontSize:16,
                                                            color:Colors.blue,
                                                            fontFamily: "Montserrat",
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      onPressed: (){
                                                        Firestore.instance.collection("Posts").document(docPostInfo.documentID).collection("Comments").getDocuments().then(
                                                                (bee){
                                                              for(DocumentSnapshot joo in bee.documents){
                                                                joo.reference.delete();
                                                              }
                                                            }
                                                        );
                                                        Firestore.instance.collection("Posts").document(docPostInfo.documentID).delete();
                                                        Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                            {
                                                              "nbrposts":FieldValue.increment(-1)
                                                            }
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            fontSize:16,
                                                            color:Colors.blue,
                                                            fontFamily: "Montserrat",
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                  backgroundColor: Colors.white,

                                                )
                                            );
                                          }
                                        },
                                        offset: Offset(0, 400),

                                        icon:Icon(Icons.more_horiz, color:Color(0xff2b106a)),


                                           itemBuilder:(context)=>[
                                          PopupMenuItem(
                                            value:"Modify",
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,color:Color(0xff2b106a),size:20),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "Modify",
                                                      style:TextStyle(
                                                          fontSize:16,
                                                          color:Color(0xff2b106a),
                                                          fontFamily: "Montserrat",
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value:"Delete",
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,color:Colors.red,size:20),
                                                SizedBox(width: 5,),
                                                Container(
                                                  child: Text(
                                                    "Delete",
                                                    style:TextStyle(
                                                        fontSize:16,
                                                        color:Colors.red,
                                                        fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]

                                    ): Container(),
                                  ],
                                ),
                              );
                            }
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            child:Text(
                              docPostInfo.data["Title"],
                              style: TextStyle(
                                  fontSize:17,
                                  color: Colors.black,
                                  fontFamily: "Montserratmini",
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        docPostInfo.data["ImageUrl"]!=null?

                        GestureDetector(
                          onTap:() {
                             Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage(postid:docPostInfo.documentID,)));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            child: Image.network(docPostInfo.data["ImageUrl"],fit: BoxFit.cover,),
                          ),
                        ):Container(),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance.collection("UsersProfiles").document(id).snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return
                                            IconButton(
                                                icon: Icon(
                                                  Icons.favorite,
                                                  size: 30,
                                                  color: List.from(snapshot.data["LickedPosts"]).contains(docPostInfo.documentID)?
                                                  Colors.red:Colors.grey,
                                                ),
                                                onPressed: () async {
                                                  if (List.from(snapshot.data["LickedPosts"]).contains(docPostInfo.documentID)) {
                                                    Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                        {
                                                          "LickedPosts": FieldValue.arrayRemove([docPostInfo.documentID])
                                                        }
                                                    );
                                                    Firestore.instance.collection("Posts").document(docPostInfo.documentID).updateData(
                                                        {
                                                          "nbrlikes":FieldValue.increment(-1)
                                                        }
                                                    );
                                                  }
                                                  else {
                                                    Firestore.instance.collection("UsersProfiles").document(id).updateData(
                                                        {
                                                          "LickedPosts": FieldValue.arrayUnion([docPostInfo.documentID
                                                          ])
                                                        }
                                                    );
                                                    Firestore.instance.collection("Posts").document(docPostInfo.documentID).updateData(
                                                        { "nbrlikes":FieldValue.increment(1)
                                                        }
                                                    );
                                                  }
                                                }
                                            );
                                        }
                                        else{
                                          return Icon(Icons.favorite, size: 30, color: Colors.grey,);
                                        }
                                      }
                                  ),

                                  Text(
                                    docPostInfo.data["nbrlikes"].toString(),
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
                                        color: docPostInfo.data["nbrcomments"]!=0?Color(0xff2b106a):Colors.grey,
                                      ),
                                      onPressed: ()=>{
                                        showModalBottomSheet(context: context,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight:Radius.circular(20),
                                            )),
                                            builder: (context){

                                              return  GestureDetector(
                                                onTap: (){
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                },
                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream:  Firestore.instance.collection("Posts").document(docPostInfo.documentID)
                                                        .collection("Comments").snapshots(),
                                                    builder: (context, snapshot) {
                                                      return Column(
                                                        children: [
                                                          Container(
                                                            height: 15,
                                                            width: 700,
                                                            decoration: BoxDecoration(
                                                                color:Color(0xff2b106a),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight:Radius.circular(20),
                                                                  topLeft: Radius.circular(20),
                                                                )
                                                            ),
                                                          ),

                                                          SizedBox(height: 20,),

                                                          Expanded(
                                                              child:
                                                              StreamBuilder<DocumentSnapshot>(
                                                                  stream: Firestore.instance.collection("Posts")
                                                                      .document(docPostInfo.documentID).snapshots(),
                                                                  builder: (context, bim) {
                                                                    if(bim.hasData){
                                                                      return Container(
                                                                        color:Colors.white,
                                                                        child: bim.data["nbrcomments"]!=0? (
                                                                            snapshot.hasData?
                                                                            ListView(
                                                                              children:snapshot.data.documents.map(
                                                                                      (DocumentSnapshot docCommentInfo){
                                                                                    return Column(
                                                                                      children: [
                                                                                        StreamBuilder<DocumentSnapshot>(
                                                                                            stream: Firestore.instance.collection("UsersProfiles").
                                                                                            document(docCommentInfo.data["Owner"]).snapshots(),
                                                                                            builder: (context, bro) {
                                                                                              if(bro.hasData){
                                                                                                return Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    SizedBox(width: 5,),
                                                                                                    CircleAvatar(
                                                                                                      backgroundImage: bro.hasData?
                                                                                                      bro.data["UserImageUrl"]!=null?
                                                                                                      NetworkImage(bro.data["UserImageUrl"]):
                                                                                                      AssetImage("assets/images/userwithoutprofileimage.png"):
                                                                                                      AssetImage("assets/images/userwithoutprofileimage.png"),
                                                                                                      backgroundColor: Colors.white,
                                                                                                      radius: 20,
                                                                                                    ),
                                                                                                    SizedBox(width: 5,),
                                                                                                    Expanded(
                                                                                                      child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.grey[200],
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                        ),
                                                                                                        child:Padding(
                                                                                                          padding: const EdgeInsets.all(5.0),
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Container(
                                                                                                                      child:
                                                                                                                      Text(
                                                                                                                        bro.data["Username"],
                                                                                                                        style: TextStyle(
                                                                                                                          fontSize: 16,
                                                                                                                          color: Colors.black,
                                                                                                                          fontFamily: "Montserratmini",
                                                                                                                          fontWeight: FontWeight.bold,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    SizedBox(height: 2,),
                                                                                                                    Container(
                                                                                                                        child:
                                                                                                                        Text(
                                                                                                                          docCommentInfo.data["Content"]
                                                                                                                          ,
                                                                                                                          style: TextStyle(
                                                                                                                              fontSize: 14,
                                                                                                                              color: Colors.black,
                                                                                                                              fontFamily: "Montserratmini"
                                                                                                                          ),)
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),

                                                                                                              docCommentInfo.data["Owner"] == idVitor || id == idVitor ?
                                                                                                              IconButton(
                                                                                                                icon:Icon(Icons.delete),
                                                                                                                color: KprimaryColor,
                                                                                                                onPressed: (){
                                                                                                                  showDialog(
                                                                                                                    context: context, builder: (context)=>
                                                                                                                      AlertDialog(
                                                                                                                        title: Text(
                                                                                                                            "You want delete this comment ?"
                                                                                                                        ),
                                                                                                                        actions: [
                                                                                                                          TextButton(
                                                                                                                            onPressed: ()async{

                                                                                                                              await  Firestore.instance.collection("Posts")
                                                                                                                                  .document(docPostInfo.documentID).collection("Comments")
                                                                                                                                  .document(docCommentInfo.documentID).delete();

                                                                                                                              await  Firestore.instance.collection("Posts")
                                                                                                                                  .document(docPostInfo.documentID).updateData(
                                                                                                                                  {
                                                                                                                                    "nbrcomments":FieldValue.increment(-1),
                                                                                                                                  });
                                                                                                                              Navigator.pop(context);
                                                                                                                            },
                                                                                                                            child: Text(
                                                                                                                                "Yes"
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          FlatButton(onPressed: (){ Navigator.pop(context); }, child: Text("No"),),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                  );

                                                                                                                },

                                                                                                              ) :

                                                                                                              Container(),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ) ,
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(width: 5,),
                                                                                                  ],
                                                                                                );}
                                                                                              else{
                                                                                                return Text("");
                                                                                              }
                                                                                            }
                                                                                        ),
                                                                                        SizedBox(height: 15,),
                                                                                      ],
                                                                                    );
                                                                                  }
                                                                              ).toList(),
                                                                            ):Text("")
                                                                        ):
                                                                        SingleChildScrollView(
                                                                          child: Column(
                                                                            children: [
                                                                              Image.asset("assets/images/comments.jpg"),
                                                                              SizedBox(height: 10,),
                                                                              Text(
                                                                                "No Comments Yet",
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Colors.grey
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "Be the first to comment",
                                                                                style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: Colors.grey
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 20,)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    else{
                                                                      return Container();
                                                                    }
                                                                  }
                                                              )
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 5,),

                                                              StreamBuilder<DocumentSnapshot>(
                                                                  stream:Firestore.instance.collection("UsersProfiles").
                                                                  document(idVitor).snapshots(),
                                                                  builder: (context,boom) {
                                                                    if(boom.hasData){
                                                                      return CircleAvatar(
                                                                        backgroundColor:Colors.white,
                                                                        backgroundImage:boom.hasData?
                                                                        boom.data["UserImageUrl"]!=null?
                                                                        NetworkImage(boom.data["UserImageUrl"]):
                                                                        AssetImage("assets/images/userwithoutprofileimage.png"):
                                                                        AssetImage("assets/images/userwithoutprofileimage.png"),
                                                                        radius: 20,
                                                                      );
                                                                    }
                                                                    else {
                                                                      return  CircleAvatar(
                                                                        backgroundColor:Colors.white,
                                                                        radius: 20,
                                                                      );
                                                                    }
                                                                  }
                                                              ),

                                                              SizedBox(width: 5,),

                                                              Expanded(
                                                                child: TextFormField(
                                                                    controller: comment,
                                                                    keyboardType: TextInputType.text,
                                                                    style: TextStyle(
                                                                        color:Colors.black,
                                                                        fontSize: 16,
                                                                        fontFamily: "Montserratmini"
                                                                    ),
                                                                    decoration:InputDecoration(
                                                                        suffixIcon: IconButton(
                                                                          icon:Icon(
                                                                              Icons.send_rounded
                                                                          ),
                                                                          onPressed: ()async{
                                                                            if(!comment.text.isEmpty){
                                                                              await Firestore.instance.collection("Posts").document(docPostInfo.documentID).
                                                                              collection("Comments").document().setData(
                                                                                  {
                                                                                    "Owner":idVitor,
                                                                                    "Content":comment.text
                                                                                  }
                                                                              );
                                                                              comment.clear();
                                                                              await Firestore.instance.collection("Posts")
                                                                                  .document(docPostInfo.documentID).updateData(
                                                                                  {
                                                                                    "nbrcomments":FieldValue.increment(1)
                                                                                  }
                                                                              );

                                                                            }
                                                                          },
                                                                        ),
                                                                        contentPadding: EdgeInsets.only(top: 20,left: 20),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color:Color(0xffFBEAFF))
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: Colors.grey[200],
                                                                        hintText: "Write a comment...",
                                                                        hintStyle: TextStyle(
                                                                            fontSize: 16,
                                                                            color: Colors.black,
                                                                            fontFamily: "Montserratmini"
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          borderSide: BorderSide(color: Color(0xff2b106a),width: 2),
                                                                        )
                                                                    )
                                                                ),
                                                              ),
                                                              SizedBox(width: 5,),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10,)
                                                        ],
                                                      );
                                                    }
                                                ),
                                              );
                                            }
                                        )
                                      }
                                  ),

                                  Text(
                                    docPostInfo.data["nbrcomments"].toString(),
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
                                  docPostInfo.data["Category"],
                                  style: TextStyle(
                                      fontSize:15,
                                      color: Colors.black,
                                      fontFamily: "Montserratmini",
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        docPostInfo.data["Text"],
                                        maxLines:2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:17,
                                            color: Colors.black,
                                            fontFamily: "Montserratmini",
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                    child: Text(
                                      "See more..",
                                      style:TextStyle(
                                        fontSize:17,
                                        color: KprimaryColor,
                                        fontFamily: "Montserratmini",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onTap:() {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage(postid:docPostInfo.documentID,)));
                                    }
                                ),

                              ]
                          ),
                        ),

                        SizedBox(height: 5,),

                      ],
                    ),

                    Container(
                      height: 10,
                      width:double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              );
            }
        ).toList()
    );
  }

  Widget NullPost(){
    return Padding(
        padding: EdgeInsets.only(left: 30,right: 30,top: 20),
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