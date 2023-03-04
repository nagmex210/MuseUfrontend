import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:muse_u/blocs/UserBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:muse_u/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProfilePage extends StatefulWidget {
  final UserCubit user;
  const ProfilePage({this.user}) : super();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cahce();
  }


  String filepath;
  void cahce()async{
    final file = await DefaultCacheManager().getSingleFile(widget.user.state.ppLink);
    filepath = file.path;
    setState(() {});
  }
  Future<void> signOut() async {
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              InkWell(
                onTap:() async{
                  EasyLoading.show();
                  await widget.user.updateProfilePicture();
                  print(widget.user.state.ppLink);
                  DefaultCacheManager().emptyCache();
                  final file = await DefaultCacheManager().getSingleFile(widget.user.state.ppLink);
                  EasyLoading.dismiss();
                  setState(() {
                    filepath = file.path;
                  });
                },

                child: BlocBuilder(
                  bloc: widget.user,
                  builder:(context,state){
                    return Container(
                        padding: EdgeInsets.only(top: 15),
                        alignment: FractionalOffset.topCenter,
                        child: CircleAvatar(
                          backgroundImage: (widget.user.state.ppLink == "" || filepath == null )? AssetImage("images/yam10.png"):AssetImage(filepath),
                          radius: 70,
                        ));
                  }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () async{
                    //change profile pic
                    print("ADA");
                  },
                  child: Text(
                    'change profile picture',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue[900]),
                  ),
                ),
              ),
              Container(
                height: 300,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      title: Text(' Username: ${widget.user.state.username}'),
                    ),
                    ListTile(
                      title: Text(' Likes: ${widget.user.state.likes}'),
                    ),
                    ListTile(
                      title: Text(' Views: ${widget.user.state.viewCount}'),
                    ),
                    IconButton(icon: Icon(Icons.logout),onPressed:() async{
                      signOut();
                    })
                  ],
                ),
              )
            ],
          )),
    );;
  }
}
