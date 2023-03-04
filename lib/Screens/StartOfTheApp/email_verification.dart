
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muse_u/constants.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EmailVerification extends StatefulWidget {
  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false ;
  Timer timer;

  //firebase shit
  Future<void> singOut() async {
    try {
      //sign out
      await Auth().signOut(
      ).then((value) {
        print("succsfully signed out");
        Navigator.pushNamedAndRemoveUntil(context,ENTERANCE_SCREEN_ROUTE, (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  //mongodb shit
  Future<void> logout() async {
    final Uri url = Uri.parse('http://localhost:3000/api/v1/deleteUser');
    Map data = {'uid': Auth().currentUser.uid};
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    ).then((value)
    {
      if (value.statusCode == 200)
      {
        Auth().currentUser.delete();
        singOut();
      }
    });

  }

  Future<void> sendEmailVerification() async{
    try{
      await FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) => print("sent"));
    }
    catch(e){
      print(e);
    }
  }

  Future<void> checkEmailVerified() async{
    try{
      FirebaseAuth.instance.currentUser.reload().then((value) {
        setState(() {
         isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
        });
        if(isEmailVerified)
          {
            //future delayed in içine koydum çünkü yoksa push methodunun için yine push metodu çağırmış gibi oluyor ondada kafayı yiyor
            Future.delayed(Duration.zero, () {
              Navigator.pushNamedAndRemoveUntil(context, HOME_SCREEN_ROUTE, (Route<dynamic> route) => false);
            });
          }
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    if(!isEmailVerified){
    sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (value) => checkEmailVerified());
    }
    else
      {
        //future delayed in içine koydum çünkü yoksa push methodunun için yine push metodu çağırmış gibi oluyor ondada kafayı yiyor
        Future.delayed(Duration.zero, () {
          Navigator.pushNamedAndRemoveUntil(context, HOME_SCREEN_ROUTE, (Route<dynamic> route) => false);
        });
      }
  }
  @override
  void dispose() {
    // ? null olup olmadığını kontrol ediyor eğer nullsa cancel methodunu çağırmıyor
    timer?.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("please verify email"),
                BackButton(onPressed: () {
                 logout();
                }),
                BackButton(onPressed: (){
                  sendEmailVerification();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}


