import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:muse_u/Models/AddButton.dart';
import 'package:muse_u/helpers/imageUploader.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';



class MuseumScreenEditable extends StatefulWidget {

  final String name;
  final MuseumsCubit museums;

  const MuseumScreenEditable({Key key,this.name,this.museums}) : super(key: key);

  @override
  _MuseumScreenEditableState createState() => _MuseumScreenEditableState();
}

class _MuseumScreenEditableState extends State<MuseumScreenEditable> {

  Museum museum;
  //index of museum
  int index= 0 ;
  //position of the dot
  int position = 0;
  //Image widgets


  final PageController _pageController = PageController(initialPage: 0);
  //image paths on internet
  List<dynamic> imagePaths = [];
  //image paths on local device
  List<dynamic> imageFilesPathsLocal = [];
  //image widgets
  List<Widget> containers = [];

  @override
  void initState() {
    // TODO: implement initState
    museum = widget.museums.state[0];
    imagePaths = museum.images;
    cacheImages();
  }


  Future<List<dynamic>> updateImages(String uid,String link) async{
    try
    {
      imagePaths.add(link);
      widget.museums.updateImages(index, imagePaths);
      final file = await DefaultCacheManager().getSingleFile(link);
      imageFilesPathsLocal.add(file.path);
      containers.add(Container(width: double.infinity, height: 300, child:Image.asset(file.path)));
      setState(() {});
    }
    catch(e)
    {
      print(e);
    }
  }

  Future<void> cacheImages()async{
    for(int i = 0; i< imagePaths.length; i++)
    {
      final file = await DefaultCacheManager().getSingleFile(imagePaths[i]);
      imageFilesPathsLocal.add(file.path);
    }
    turnToContainers();
    setState(() {});
  }

  void turnToContainers(){
    containers = [];
    for(int i = 0; i< imageFilesPathsLocal.length; i++)
    {
      final returnWidget = Container(width: double.infinity, height: 300, child:Image.asset(imageFilesPathsLocal[i]));
      containers.add(returnWidget);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/gallery1.png"),
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
              margin: EdgeInsets.only(top: 110),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.1),
                  color: Colors.white
                  ),
              height: 300,
              child: Center(
                  child: PageView(
                      children:
                      [
                            AddButton(()
                            async {
                              EasyLoading.show();
                              String uid = Auth().currentUser.uid;
                              final link = await MediaUploader().uploadImage(uid,museum.name,this.index);
                              if(link == null)
                              {
                                await EasyLoading.dismiss();
                               EasyLoading.showError("There was an error please try again") ;
                              }
                              else
                              {
                                updateImages(uid,link);
                                await EasyLoading.dismiss();
                                EasyLoading.showSuccess("succesfully uploaded");
                              }
                            }
                            ),
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
              child: imagePaths.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: imagePaths.length +1,
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

