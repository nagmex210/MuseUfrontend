import 'package:flutter/material.dart';

const Color kpurple = Color(0xFF3A2E78);
const Color kblue = Color(0xFF3BBEF0);
const Color kyellow = Color(0xFFFED214);
const Color kgreen = Color(0xFF45E0A2);

const TextStyle kerrMessageStyle = TextStyle(color: Colors.red,fontSize: 18);

const String REGISTER_SCREEN_ROUTE = "register_screen_route";
const String LOGIN_SCREEN_ROUTE = "login_screen_route";
const String HOME_SCREEN_ROUTE = "home_screen_route";
const String EMAIL_SCREEN_ROUTE = "Email_screen_route";
const String ENTERANCE_SCREEN_ROUTE = "Enterance_screen_route";



const kTextfieldecoration =InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle( color: Colors.grey),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
