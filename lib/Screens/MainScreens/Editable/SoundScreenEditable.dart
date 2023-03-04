import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:muse_u/Models/AddButton.dart';
import 'package:muse_u/helpers/imageUploader.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';
import "dart:io";





class SoundScreenEditable extends StatefulWidget {

  final String name;
  final MuseumsCubit museums;

  const SoundScreenEditable({Key key,this.name,this.museums}) : super(key: key);

  @override
  _SoundScreenEditableState createState() => _SoundScreenEditableState();
}

class _SoundScreenEditableState extends State<SoundScreenEditable> {
  //not that important function
  String formatTime(Duration duration)
  {
    String twoDigits(int n) =>n.toString().padLeft(2,"0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes%60);
    final seconds = twoDigits(duration.inSeconds%60);
    return [
      if(duration.inHours > 0) hours,
      minutes,
      seconds
    ].join(":");
  }


  Museum museum;
  int index= 0 ;
  int position = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<dynamic> soundPaths = [];
  //image paths on local device
  List<String> soundsFilesPathsLocal = [];


  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration pos = Duration.zero;



  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //finds and adds sounds
    museum = widget.museums.state[0];
    soundPaths = museum.sounds;
    cacheSounds();

    //audioplayer initilaziton
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
        print(event);
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
        print(duration);
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        pos = event;
        print(pos);
      });
    });

  }


  Future<void> cacheSounds()async{
    for(int i = 0; i< soundPaths.length; i++)
    {
      final file = await DefaultCacheManager().getSingleFile(soundPaths[i]);
      print(file.path);
      soundsFilesPathsLocal.add(file.path);
    }
    setState(() {});
  }

  Future<List<dynamic>> updateSounds(String uid,String link) async{
    try
    {
      soundPaths.add(link);
      widget.museums.updateSounds(index, soundPaths);
      final file = await DefaultCacheManager().getSingleFile(link);
      soundsFilesPathsLocal.add(file.path);
      setState(() {});
    }
    catch(e)
    {
      print(e);
    }
  }






  @override
  void dispose() async{
    // TODO: implement dispose

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/sounds1.png"),
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
              'Sounds',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,color: Colors.black),
            ),
            Container(
              width: 150,
              margin: EdgeInsets.only(top:40,right: 170),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.1),
                  color: Colors.white
              ),
              height: 295,
              child: Center(
                  child: PageView.builder(
                    itemBuilder: (context,index){
                      if(index == 0)
                      {
                        return  AddButton(()
                        async {
                          EasyLoading.show();
                          String uid = Auth().currentUser.uid;
                          final link = await MediaUploader().uploadSound(uid,museum.name,this.index);
                          if(link == null)
                          {
                            await EasyLoading.dismiss();
                            EasyLoading.showError("There was an error please try again") ;
                          }
                          else
                          {
                            updateSounds(uid,link);
                            await EasyLoading.dismiss();
                            EasyLoading.showSuccess("succesfully uploaded");
                          }
                        }
                        );
                      }
                      return  Container(
                          width: double.infinity,
                          height: 300,
                          child: Column(
                            children: [
                              Slider(
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: pos.inSeconds.toDouble(),
                                  onChanged: (value) async{
                                    final pos = Duration(seconds: value.toInt());
                                    await audioPlayer.seek(pos);
                                  }
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatTime(pos)),
                                    Text(formatTime(duration-pos))
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                child: Center(
                                  child: IconButton(icon: Icon(isPlaying ? Icons.pause: Icons.play_arrow),
                                      iconSize: 40,
                                      onPressed: () async{
                                        if(isPlaying)
                                        {
                                          await audioPlayer.pause();
                                        }
                                        else
                                        {
                                          await audioPlayer.resume();
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ],
                          )
                      );
                    },
                    physics: BouncingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: soundsFilesPathsLocal.length + 1,
                    onPageChanged: (i) async{
                        position = i;
                        print("aq0");
                        setState(() {
                        });
                      setState(() {});
                    },
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0,right:170 ),
              child: soundPaths.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: soundPaths.length +1,
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


