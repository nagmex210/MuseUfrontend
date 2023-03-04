import 'package:flutter/material.dart';
import "package:muse_u/constants.dart";
import 'package:muse_u/Models/buttonModel.dart';


class Enterance extends StatelessWidget {

  static String id = 'enterance_v01';

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'images/logov5.png',
                height: 400,
                width: 400,
              ),
            ),
            Center(
              child: Text(
                'Muse U',
                style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Buttonolurins('Login', Colors.white,Colors.white, () {
                Navigator.pushNamed(context, LOGIN_SCREEN_ROUTE);

              }, Colors.black, Colors.black, 200, 50),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0.00025),
                child:
                Buttonolurins('Register', Colors.black, Colors.black, () {
                  Navigator.pushNamed(context, REGISTER_SCREEN_ROUTE);
                }, Colors.white, Colors.white, 200, 50))
          ],
        ),
      ),
    );
  }
}
