import 'package:flutter/material.dart';


ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
  ),
);

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
  // color: Colors.black54,
);

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  CustomTopBar({@required this.title,
    @required this.child,
    @required this.onPressed,
    this.onTitleTapped})
      : preferredSize = Size.fromHeight(60.0);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // SizedBox(height: 30,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Hero(
                tag: 'topBarBtn',
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 15,
                    )
                  ]),
                  child: Card(
                    elevation: 10,
                    shape: kBackButtonShape,
                    child: MaterialButton(
                      height: 50,
                      minWidth: 50,
                      elevation: 10,
                      shape: kBackButtonShape,
                      onPressed: onPressed,
                      child: child,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 50,
              // ),
              Hero(
                tag: 'title',
                transitionOnUserGestures: true,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 15,
                    )
                  ]),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: InkWell(
                      onTap: onTitleTapped,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Muse " ,
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  // color: Colors.black54,
                                ) ,),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    // color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}


