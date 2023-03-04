import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:muse_u/Models/AddButton.dart';
import 'package:muse_u/helpers/imageUploader.dart';
import 'package:muse_u/Models/auth.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';



//TODO:pdf packageını değiştir https://pub.dev/packages/advance_pdf_viewer_fork buna geç oç syncfusion paraistior
class PDFScreenEditable extends StatefulWidget {

  final String name;
  final MuseumsCubit museums;

  const PDFScreenEditable({Key key,this.name,this.museums}) : super(key: key);

  @override
  _PDFScreenEditableState createState() => _PDFScreenEditableState();
}

class _PDFScreenEditableState extends State<PDFScreenEditable> {
  Museum museum;
  //index of museum
  int index= 0 ;
  //position of the dot
  int position = 0;
  //Image widgets


  final PageController _pageController = PageController(initialPage: 0);
  //image paths on internet
  List<dynamic> pdfPaths = [];
  //image paths on local device
  List<dynamic> pdfFilesPathsLocal = [];
  //image widgets
  List<Widget> containers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    museum= widget.museums.state[0];
    pdfPaths = museum.documents;
    cachePdfs();
  }


  Future<List<dynamic>> updatePdfs(String uid,String link) async{
    try
    {
      pdfPaths.add(link);
      widget.museums.updatePdfs(index, pdfPaths);
      final file = await DefaultCacheManager().getSingleFile(link);
      pdfFilesPathsLocal.add(file.path);
      containers.add(Container(width: double.infinity, height: 300, child:SfPdfViewer.asset(file.path)));
      setState(() {});
    }
    catch(e)
    {
      print(e);
    }
  }

  Future<void> cachePdfs()async{
    for(int i = 0; i< pdfPaths.length; i++)
    {
      final file = await DefaultCacheManager().getSingleFile(pdfPaths[i]);
      pdfFilesPathsLocal.add(file.path);
    }
    turnToContainers();
    setState(() {});
  }

  void turnToContainers(){
    containers = [];
    for(int i = 0; i< pdfFilesPathsLocal.length; i++)
    {
      final returnWidget = Container(width: double.infinity, height: 700, child: SfPdfViewer.asset(pdfFilesPathsLocal[i]));
      containers.add(returnWidget);
    }
  }

  @override
  void dispose() {
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
              height: 700,
              child: Center(
                  child: PageView(
                    children:
                    [
                      AddButton(()
                      async {
                        EasyLoading.show();
                        String uid = Auth().currentUser.uid;
                        final link = await MediaUploader().uploadPdf(uid,museum.name,this.index);
                        if(link == null)
                        {
                          await EasyLoading.dismiss();
                          EasyLoading.showError("There was an error please try again") ;
                        }
                        else
                        {
                          updatePdfs(uid,link);
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
              child: pdfPaths.length == 0
                  ? null
                  : DotsIndicator(
                dotsCount: pdfPaths.length +1,
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

