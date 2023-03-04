import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class MuseumScreen extends StatefulWidget {
  final List<dynamic> imagePaths;

  const MuseumScreen({@required this.imagePaths});

  @override
  _MuseumScreenState createState() => _MuseumScreenState();
}

class _MuseumScreenState extends State<MuseumScreen> {

  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backgroundimageimage1.png"),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Images',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,color: Colors.black),
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
                        color: Color(0xFF150050),
                        blurRadius: 10,
                        offset: Offset(0, 20))
                  ]),
              padding: EdgeInsets.only(top: 50),
              height: 300,
              child: Center(
                  child: widget.imagePaths.isEmpty ? Container() :PageView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                          width: double.infinity,
                          height: 300,
                          child: Image(image: NetworkImage(widget.imagePaths[index])));
                    },
                    physics: BouncingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (i) {
                      position = i;
                      setState(() {});
                    },
                    itemCount: widget.imagePaths.length,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: widget.imagePaths.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: widget.imagePaths.length ,
                position: position.toDouble(),
                decorator: DotsDecorator(
                    activeColor: Color(0xFFFB2576),
                    size: Size(17, 17),
                    activeSize: Size(18.5, 18.5)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
