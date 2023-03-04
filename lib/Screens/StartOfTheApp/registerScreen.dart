import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:muse_u/constants.dart';
import 'package:muse_u/Models/buttonModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class RegisterScreen extends StatefulWidget {


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String email;

  String password;
  String reRentredPassword;


  String username;

  String errorMessage = "";


    Future<void> registerInWithEmailAndPassword() async {
      //easy loading
      EasyLoading.show(status: 'loading...');
      final response = await http.get(Uri.parse('http://localhost:3000/api/v1/getFilteredUsers?prefix=${username}'));
      if (response.statusCode == 200) {
        // Parse the response body as a JSON object
        final data = jsonDecode(response.body);
        List<dynamic> found = data["item"];
        if(found.isEmpty)
        {
          try {
            //authentication klasik
            await Auth().createUserWithEmailAndPassword(
              email: email.trim(),
              password: password.trim(),
            ).then((value) async{

              final Uri url = Uri.parse('http://localhost:3000/api/v1/addUser');
              print(Auth().currentUser.uid);
              final Map<String, String> body = {'uid': Auth().currentUser.uid, 'username': username};

              final response = await http.post(
                url,
                headers: {'Content-type': 'application/json'},
                body: json.encode(body),
              );

              if (response.statusCode == 200) {
                print(response.body);
              } else {
                EasyLoading.dismiss();
                setState(() {
                  errorMessage = "There is an error currently with the server";
                });
                Auth().currentUser.delete();
              }
              EasyLoading.dismiss().then((value) {
                Navigator.pushNamed(context, EMAIL_SCREEN_ROUTE);
              });
            });
          } on FirebaseAuthException catch (e) {
            print(e);
            EasyLoading.dismiss();
            setState(() {
              errorMessage = e.message;
            });
          }
        }
        else
          {
            EasyLoading.dismiss();
            setState(() {
              errorMessage = "there is a user with the username " + username ;
            });
          }
      }
      else
        {
          EasyLoading.dismiss();
          setState(() {
            errorMessage = "there is an issue with the servers currently please try again later";
          });
        }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logov5.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your email'),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    username = value;
                    if(username.contains(" "))
                    {
                      errorMessage = "username cant contain blank spaces";
                    }
                    if(username.contains("/"))
                    {
                      errorMessage = "username cant contain slash";
                    }
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your username'),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your password'),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    reRentredPassword = value;
                    if(value != password){
                      setState(() {
                        errorMessage ="Your password doesnt match";
                      });
                    }
                    else{
                      setState(() {
                        errorMessage = "";
                      });
                    }
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Re-Enter your password'),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Buttonolurins('Register', Colors.white, Colors.white, () async {
                  try {
                    if(password == reRentredPassword && !username.contains(" ") && !username.contains("/"))
                    {
                      registerInWithEmailAndPassword();
                    }
                  } catch (e) {
                    print(e);
                  }
                }, Colors.black, Colors.black, 200, 50),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(errorMessage,style: kerrMessageStyle),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


