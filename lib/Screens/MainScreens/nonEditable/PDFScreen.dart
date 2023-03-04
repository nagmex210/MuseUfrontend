import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PDFScreen extends StatefulWidget {

  final List<dynamic> pdfs;

  const PDFScreen({Key key,this.pdfs}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {

  int index= 0 ;
  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }

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
              height: 50,
            ),
            Text(
              'Documents',
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
              height: 750,
              child: Center(
                  child: widget.pdfs.isEmpty ? Container() : PageView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                            width: double.infinity,
                            height: 750,
                            child: SfPdfViewer.network(widget.pdfs[index]));
                    },
                    physics: BouncingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (i) {
                      position = i;
                      setState(() {});
                    },
                    itemCount: widget.pdfs.length ,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: widget.pdfs.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: widget.pdfs.length ,
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

