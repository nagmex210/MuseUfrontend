
import 'package:flutter/material.dart';
import 'package:muse_u/constants.dart';
import 'package:muse_u/Models/buttonModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;

  String password;

  String errorMessage = "";


  Future<void> signInWithEmailAndPassword() async {
    //easy loading
    EasyLoading.show(status: 'loading...');
    try {
      //authentication klasik
      await Auth().signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ).then((value) {
        print("succsfully signed in");
        EasyLoading.dismiss().then((value) {
          Navigator.pushNamed(context, EMAIL_SCREEN_ROUTE);
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      EasyLoading.dismiss();
      setState(() {
        errorMessage = e.message;
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
                      height: 300.0,
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
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextfieldecoration.copyWith(
                      hintText: 'Enter your password'),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Buttonolurins('Login', Colors.white, Colors.white, () async {
                  try {
                    signInWithEmailAndPassword();
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
