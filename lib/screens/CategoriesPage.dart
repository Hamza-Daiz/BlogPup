import 'package:blogging_app/screens/OneCategoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesPage extends StatelessWidget {

  @override

  String id;
  CategoriesPage({this.id});

  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;

    return Padding(

      padding:EdgeInsets.only(left: 30,right: 30,top: 20),

      child: StreamBuilder<QuerySnapshot>(

        stream: Firestore.instance.collection("Categories").snapshots(),

        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.count(
                childAspectRatio: 1,
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                children:snapshot.data.documents.map(
                      (DocumentSnapshot doc) =>
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>OneCategoryPage(id:id,Category:doc.data["Category"])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom:20.0,left: 5,right: 5),

                          child: GridTile(

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(doc.data["ImageUrl"],fit: BoxFit.cover,),
                            ),

                            footer: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff2b106a),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                              ),
                              child: Text(
                                doc.data["Category"],
                                style:TextStyle(
                                  fontSize:17,
                                  color: Colors.white,
                                  fontFamily: "Montserratmini",
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),

                            ),
                          ),
                        ),
                      ),

                ).toList()
            );
          }
          else{
            return Column(
              children: [
                Text("")
              ],
            );
          }
        }
      ),
    );
  }
}
