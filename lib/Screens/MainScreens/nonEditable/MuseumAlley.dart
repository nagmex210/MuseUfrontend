import 'package:flutter/material.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/Screens/MainScreens/nonEditable/PDFScreen.dart';
import 'MuseumScreen.dart';
import 'VideoScreen.dart';
import 'package:dots_indicator/dots_indicator.dart';

class MuseumAlley extends StatefulWidget {
  final Museum museum;
  final String name ;

  const MuseumAlley({Key key,@required this.museum, @required this.name}) : super(key: key);

  @override
  _MuseumAlleyState createState() => _MuseumAlleyState();
}

class _MuseumAlleyState extends State<MuseumAlley> {

  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
              ),
              Container(
                width: 350,
                margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black, width: 0.1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 20))
                    ]),
                padding: EdgeInsets.only(top: 50),
                height: 300,
                child: Center(
                    child: PageView(
                      children:
                      [
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MuseumScreen(imagePaths: widget.museum.images)),
                            );
                          },
                          child: Container(
                              width: double.infinity,
                              height: 300,
                              child: Center(child: Text("images"))),
                        ),
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VideoScreen(videoPaths: widget.museum.videos)),
                            );
                          },
                          child: Container(
                              width: double.infinity,
                              height: 300,
                              child: Center(child: Text("Videos"))),
                        ),
                        InkWell(
                          onTap: ()
                          {
                            //Sonra soundsa gidiş koy soundsu hallendice
                          },
                          child: Container(
                              width: double.infinity,
                              height: 300,
                              child: Center(child: Text("Sounds olcaktı"))),
                        ),
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PDFScreen(pdfs: widget.museum.documents)),
                            );
                          },
                          child: Container(
                              width: double.infinity,
                              height: 300,
                              child: Center(child: Text("Documents"))),
                        ),
                      ],
                      physics: BouncingScrollPhysics(),
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (i) {
                        position = i;
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child:  DotsIndicator(
                  dotsCount: 4 ,
                  position: position.toDouble(),
                  decorator: DotsDecorator(
                      activeColor: Color(0xFFFB2576),
                      size: Size(17, 17),
                      activeSize: Size(18.5, 18.5)),
                ),
              )
            ],
          ),
        )
    );
  }
}

