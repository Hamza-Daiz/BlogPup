import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormUI extends StatefulWidget {
  String UserEmail;
  FormUI({this.UserEmail});
  @override
  _FormUIState createState() => _FormUIState();
}

String messageSend ;

class _FormUIState extends State<FormUI> {

  Firestore fire = Firestore.instance;

  // FToast fToast;


  Future SendMessageToFireStore(String message,String email)async{
    try {
      await fire.collection("Contact").document().setData(
          {
            "email":email,
            "message":message,

          }
      );

    } on Exception catch (e) {
      print(e.toString());
    }
  }



  TextEditingController _messageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Color(0xFFFBEAFF),
      appBar: AppBar(
        backgroundColor: Color(0xff2b106a),
        centerTitle: true,
        title: Text(
          "Contact us",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                cursorHeight: 20,
                controller: _messageController,
                maxLines: 4,
                maxLength: 300,
                scrollController: ScrollController(),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.greenAccent ),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your  message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: RaisedButton(
                      color: Color(0xff2b106a),
                      child: Text("Send",style: TextStyle(color: Colors.white),),
                      onPressed: () async{


                        setState(() {
                          messageSend = _messageController.text.toString();
                        });
                        Email email = Email(
                          body: messageSend,
                          subject: 'Contact BlogPup app',
                          recipients: ['hitec.appdev@gmail.com'],
                        );
                        SendMessageToFireStore(_messageController.text.toString(),"mustapha@gmail.com");


                        await FlutterEmailSender.send(email);

                        _messageController.clear();
                        //call method flutter upload
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
