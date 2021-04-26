import 'package:blogging_app/screens/OneCategoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(left: 30,right: 30,top: 20),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Categories").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.count(
                crossAxisCount: 2,
                children:snapshot.data.documents.map(
                      (DocumentSnapshot doc) =>
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder:(context)=>OneCategoryPage(Category:doc.data["Category"])));
                              },
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(doc.data["ImageUrl"]),
                                  fit:BoxFit.cover,
                                )
                            ),
                          ),
                          SizedBox(height:10,),
                          RichText(
                            text:TextSpan(
                                text:doc.data["Category"],
                                style:TextStyle(
                                  fontSize:17,
                                  color: Color(0xff2b106a),
                                  fontFamily: "Montserratmini",
                                  fontWeight: FontWeight.w500,
                                  decoration:TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,MaterialPageRoute(builder:(context)=>OneCategoryPage(Category:doc.data["Category"])));
                                  }),
                          )
                        ],
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
