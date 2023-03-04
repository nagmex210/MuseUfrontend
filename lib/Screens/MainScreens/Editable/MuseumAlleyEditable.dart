
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'MuseumScreenEditable.dart';
import 'SoundScreenEditable.dart';
import 'VideoScreenEditable.dart';
import 'PDFScreenEditable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class MuseumAlleyEditable extends StatefulWidget {
final museums;
final name ;

  const MuseumAlleyEditable({Key key, this.museums, this.name}) : super(key: key);

  @override
  _MuseumAlleyEditableState createState() => _MuseumAlleyEditableState();
}

class _MuseumAlleyEditableState extends State<MuseumAlleyEditable> {

  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DefaultCacheManager().emptyCache();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/hall1.png"),
            fit: BoxFit.fill
          )
        ),
        width: double.infinity,
        child: Center(
          child:
              Padding(
                padding: EdgeInsets.only(top: 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoScreenEditable(name:widget.name,museums: widget.museums) ),
                        );
                      },
                      child: Container(
                          width: 110,
                          height: 223,
                      ),
                    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MuseumScreenEditable(name:widget.name,museums: widget.museums) ),
                        );
                      },
                      child: Container(
                          width: 110,
                          height: 223,
                      ),
                    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SoundScreenEditable(name:widget.name,museums: widget.museums) ),
                        );
                      },
                      child: Container(
                          width: 110,
                          height: 223,
                      ),
                    ),
            ],
          ),
              ),
        ),
      )
    );
  }
}

