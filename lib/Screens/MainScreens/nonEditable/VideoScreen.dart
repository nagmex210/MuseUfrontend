import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


class VideoScreen extends StatefulWidget {

  final List<dynamic> videoPaths;

  const VideoScreen({Key key,this.videoPaths}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  List<VideoPlayerController> videoPlayerControllers = [];
  List<ChewieController> chewieControllers=[];

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
    transformvideos();
  }

  @override
  void dispose() {
    videoPlayerControllers.forEach((element) { element.dispose();});
    chewieControllers.forEach((element) { element.dispose();});
    super.dispose();
  }


  Future<void> transformvideos() async {
    for(int i = 0;i< widget.videoPaths.length;i++)
    {
      final videoPlayerController = VideoPlayerController.network(widget.videoPaths[i]);
      videoPlayerControllers.add(videoPlayerController);
      await videoPlayerController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => debugPrint('Option 1 pressed!'),
              iconData: Icons.chat,
              title: 'Option 1',
            ),
            OptionItem(
              onTap: () =>
                  debugPrint('Option 2 pressed!'),
              iconData: Icons.share,
              title: 'Option 2',
            ),
          ];
        },
      );
      chewieControllers.add(chewieController);
    }
    setState(() {});
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
              height: 120,
            ),
            Text(
              'Videos',
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
                  child: widget.videoPaths.isEmpty ? Container() :PageView.builder(
                    itemBuilder: (context, index) {
                        return Container(
                            width: double.infinity,
                            height: 300,
                            child: chewieControllers.isEmpty ? Container() :Chewie(
                              controller: chewieControllers[index],
                            )
                        );
                      }
                    ,
                    physics: BouncingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (i) {
                      position = i;
                      setState(() {});
                    },
                    itemCount: widget.videoPaths.length,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: widget.videoPaths.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: widget.videoPaths.length,
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

