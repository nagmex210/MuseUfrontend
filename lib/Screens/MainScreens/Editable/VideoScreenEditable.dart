import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:muse_u/Models/AddButton.dart';
import 'package:muse_u/helpers/imageUploader.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoScreenEditable extends StatefulWidget {
  final String name;
  final MuseumsCubit museums;

  const VideoScreenEditable({Key key, this.name, this.museums})
      : super(key: key);

  @override
  _VideoScreenEditableState createState() => _VideoScreenEditableState();
}

class _VideoScreenEditableState extends State<VideoScreenEditable> {
  List<VideoPlayerController> videoPlayerControllers = [];
  List<ChewieController> chewieControllers = [];
  List<Widget> controllers = [];

  Museum museum;
  int index = 0;
  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<dynamic> videoPaths = [];
  List<File> videoPathsLocal = [];
  List<Widget> containers = [];

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    museum=widget.museums.state[0];
    videoPaths = museum.videos;
    cacheVideos();
  }

  @override
  void dispose() {
    videoPlayerControllers.forEach((element) {
      element.dispose();
    });
    chewieControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Future<void> transformvideos() async {
    for (int i = 0; i < videoPathsLocal.length; i++) {
      final videoPlayerController =
          VideoPlayerController.file(videoPathsLocal[i]);
      videoPlayerControllers.add(videoPlayerController);
      await videoPlayerController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
      );
      chewieControllers.add(chewieController);
    }
    turnToContainers();
  }

  Future<void> updateVideos(String uid, String link) async {
    try {
      //add video link to ram
      videoPaths.add(link);
      //update cubit
      widget.museums.updateVideos(index, videoPaths);
      //cache video
      final file = await DefaultCacheManager().getSingleFile(link);
      //add local path to ram
      videoPathsLocal.add(file);
      //create video players and necessary controllers
      final videoPlayerController = VideoPlayerController.file(file);
      videoPlayerControllers.add(videoPlayerController);
      await videoPlayerController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
      );
      chewieControllers.add(chewieController);
      //create container widget
      final returnWidget = Container(
          width: double.infinity,
          height: 300,
          child: Chewie(controller: chewieController));
      containers.add(returnWidget);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> cacheVideos() async {
    for (int i = 0; i < videoPaths.length; i++) {
      final file = await DefaultCacheManager().getSingleFile(videoPaths[i]);
      videoPathsLocal.add(file);
    }
    await transformvideos();
  }

  void turnToContainers() {
    print("aq0");
    containers = [];
    for (int i = 0; i < chewieControllers.length; i++) {
      final returnWidget = Container(
          width: double.infinity,
          height: 300,
          child: GestureDetector(
            onTap: (){
              chewieControllers[i].toggleFullScreen();
              print("aqqqq");
            },
            child: Chewie(
              controller: chewieControllers[i],
            ),
          ));
      containers.add(returnWidget);
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
                image: AssetImage("images/videos1.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Videos',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
            Container(
              width: 350,
              margin: EdgeInsets.only(top: 135),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.1),
                  color: Colors.white
              ),
              height: 220,
              child: Center(
                  child: PageView(
                children: [
                  AddButton(() async {
                    EasyLoading.show();
                    String uid = Auth().currentUser.uid;
                    final link = await MediaUploader()
                        .uploadVideo(uid, museum.name, this.index);
                    if (link == null) {
                      await EasyLoading.dismiss();
                      EasyLoading.showError(
                          "There was an error please try again");
                    } else {
                      updateVideos(uid, link);
                      await EasyLoading.dismiss();
                      EasyLoading.showSuccess("succesfully uploaded");
                    }
                  }),
                  ...containers
                ],
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (i) {
                  setState(() {
                    position = i;
                  });
                },
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: videoPaths.length == 0
                  ? null
                  : DotsIndicator(
                      dotsCount: videoPaths.length + 1,
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
