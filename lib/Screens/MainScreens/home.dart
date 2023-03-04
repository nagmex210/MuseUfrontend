
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'Editable/MuseumAlleyEditable.dart';
import 'package:muse_u/blocs/UserBloc.dart';
import 'searchScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profilePage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final cubit = MuseumsCubit();
  final User user = Auth().currentUser;
  final textFieldController = TextEditingController();
  final userCubit = UserCubit();
  int selectedOption = 0;


  Future<void> getMuseums() async {
    await cubit.getMuseums(user.uid);
    setState(() {});
  }

  Future<void> getUser() async {
    await userCubit.getUser(user.uid);
    setState(() {});
  }

  Future<void> addMuseum(String uid , String name) async{
    // await cubit.addMuseums(uid, name);
    setState(() {});
  }


@override
  void initState() {
    // TODO: implement initState
    getMuseums();
    getUser();
    super.initState();
  }

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false, child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 10),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                 flex: 1,
                 child: Container(
                   alignment: Alignment.centerLeft,
                   child:IconButton(onPressed: (){}, icon: Icon(Icons.list,color: Colors.white,size: 40,)),
                 ),
               ),
               Expanded(
                 flex: 2,
                 child: Container(
                   alignment: Alignment.center,
                   child:Text("MUSE U",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w900),),
                 ),
               ),
               Expanded(
                 flex: 1,
                 child: Container(
                   alignment: Alignment.centerRight,
                   child:IconButton(onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user: userCubit,)));
                   }, icon: Icon(Icons.account_circle,color: Colors.white,size: 40,)),
                 ),
               ),
             ],
           ),
         ),
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container( height: 300, child: InkWell(onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MuseumAlleyEditable(museums: cubit,name: cubit.state[0].name,) ),
                    );
                  }, child: Image(image: AssetImage("images/hall1.png")))),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cubit.state.isEmpty ? "wait" :cubit.state[0].name,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.white,size: 20,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userCubit.state.likes.toString()+" ",style: TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(width: 5,),
                  Icon(Icons.remove_red_eye,color: Colors.white,size: 20,),
                  SizedBox(width: 20,),
                  Text(" "+userCubit.state.viewCount.toString()+" ",style: TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(width: 5,),
                  Icon(Icons.favorite,color: Colors.white,size: 20,)
                ],
              ),
              SizedBox( height: 20),
              Container(
                color: Colors.white,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedOption = 0;
                          });
                        },
                        child: Text("Liked",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: selectedOption == 0 ? FontWeight.bold:FontWeight.normal),)),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedOption = 1;
                        });
                      },
                        child: Text("Most Viewed",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: selectedOption == 1 ? FontWeight.bold:FontWeight.normal),)),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedOption = 2;
                        });
                      },
                        child: Text("Guest List",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: selectedOption == 2 ? FontWeight.bold:FontWeight.normal),)),
                    SizedBox(width: 5,),
                    InkWell(child: Icon(Icons.search_rounded,color: Colors.black,size: 20,),onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchBar(userCubit: userCubit,museumsCubit: cubit,)),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
          if(selectedOption == 0)
          BlocBuilder(
            bloc: userCubit,
            builder: (context,state){
                return Expanded(
                  child: userCubit.state == null ? Container() :Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: userCubit.state.likedUsers.length, // replace with your actual item count
                      itemBuilder: (context, index) {
                        return ListItem(userCubit.state.likedUsers[index],()async{
                          await userCubit.removeLikeFromUser(userCubit.state.uid,userCubit.state.likedUsers[index]);
                          setState(() {});
                        },Icons.favorite,true);
                      },
                    ),
                  ),
                );
            },
          ),
          if(selectedOption == 1)
            Expanded(
              child: userCubit.state == null ? Container() :Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Center(child: Text("Coming Soon",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w700,),)),
              ),
            ),
          if(selectedOption == 2)
            BlocBuilder(
              bloc: cubit ,
              builder: (context,state){
                  return Expanded(
                    child: cubit.state == null ? Container() :Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: cubit.state[0].guestList.length, // replace with your actual item count
                        itemBuilder: (context, index) {
                          return ListItem(cubit.state[0].guestList[index],()async{
                            await cubit.removeFromGuestList(user.uid,cubit.state[0].guestList[index]);
                            setState(() {});
                          },Icons.close,false);
                        },
                      ),
                    ),
                  );
              },
            ),
        ],
      )),
    );
  }
}


Widget ListItem(String name,Function func,IconData icon,bool altText){

  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
    child: Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Text(
                  name.substring(0,1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xff000000),
                      height: 1.5384615384615385,
                      fontWeight: FontWeight.w600),
                  textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
                if(altText)
                  Text(
                    name +"'s Museum",
                    style: TextStyle(
                        fontSize: 10,
                        color: const Color(0x80232425),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  )
              ],
            ),
          ],
        ),
        InkWell(onTap: func,child: Icon(icon,size: 20,))
      ],
    ),
  );

}


