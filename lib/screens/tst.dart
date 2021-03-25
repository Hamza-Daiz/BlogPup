import 'package:flutter/material.dart';
class Tst extends StatelessWidget{
  String id;
 Tst({this.id});
  @override
  Widget build(BuildContext context) {
    print("tsttttttttttttttt: $id");
    return Scaffold(
      appBar: null,
      body: Center(
        child:Text("mar7baaa",
        style: TextStyle(
          fontSize: 50
        ),
        )
      ),
    );
  }

}