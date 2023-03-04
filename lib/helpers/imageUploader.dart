import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'apiRequestMaker.dart';





class MediaUploader
{
  final storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String> _pickImage() async {
      try{
        final image = await _picker.pickImage(source: ImageSource.gallery);
        return image.path;
      }
      catch(e){print(e);}
  }




  Future<String> uploadImage(String uid,String museumName,int index) async {
    try
    {
      String anyError;
      final imagePath = await _pickImage();
      print(imagePath);
      if (imagePath != null)
      {
        final storageRef = FirebaseStorage.instance.ref();
        Reference imageRef = storageRef.child(uid).child("images").child(museumName);
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +".png";
        final spaceRef = imageRef.child(fileName);
        File file = File(imagePath);
        await spaceRef.putFile(file);
        final String link = "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/${uid}%2Fimages%2F${museumName}%2F${fileName}?alt=media";
        final possibleError =  await apiHandler.addImage(uid: uid,index: index,postUrl: link);
        if(!possibleError)
        {
          anyError = link;
        }
      }
      return anyError;
    }
    catch(e){
      print(e);
    }
  }

  Future<String> updateProfilePicture(String uid) async {
    try
    {
      String anyError;
      final imagePath = await _pickImage();
      print(imagePath);
      if (imagePath != null)
      {
        final storageRef = FirebaseStorage.instance.ref();
        Reference imageRef = storageRef.child("profilePictures");
        final String fileName = uid+".png";
        final spaceRef = imageRef.child(fileName);
        File file = File(imagePath);
        await spaceRef.putFile(file);
        final String link = "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/profilePictures%2F${fileName}?alt=media";
        final possibleError =  await apiHandler.addImage(uid: uid,postUrl: link);
        if(!possibleError)
        {
          anyError = link;
        }
      }
      return anyError;
    }
    catch(e){
      print(e);
    }
  }


  Future<String> _pickVideo() async {
    try{
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      return video.path;
    }
    catch(e){print(e);}
  }

  Future<String> uploadVideo(String uid,String museumName,int index) async {
    try
    {
      String anyError;
      final soundPath = await _pickVideo();
      print(soundPath);
      if (soundPath != null)
      {
        final storageRef = FirebaseStorage.instance.ref();
        Reference videoRef = storageRef.child(uid).child("videos").child(museumName);
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +".mp4";
        final spaceRef = videoRef.child(fileName);
        File file = File(soundPath);
        await spaceRef.putFile(file);
        final String link = "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/${uid}%2Fvideos%2F${museumName}%2F${fileName}?alt=media";
        final possibleError =  await apiHandler.addVideo(uid: uid,index: index,postUrl: link);
        if(!possibleError)
        {
          anyError = link;
        }
      }
      return anyError;
    }
    catch(e){
      print(e);
    }
  }


  Future<String> _pickPdf() async {
    try {
      print("aq0");
      final pdf =  await FilePicker.platform.pickFiles(type:FileType.custom, allowedExtensions:['pdf'],allowMultiple: false);
      print("aq1");
      //file picker can get multiple files but we only got 1 file so we need only the first files path to upload because we only got one
      return pdf.paths[0];
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadPdf(String uid,String museumName,int index) async {
    try
    {
      String anyError;
      final pdfPath = await _pickPdf();
      print(pdfPath);
      if (pdfPath != null)
      {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pdfRef = storageRef.child(uid).child("pdfs").child(museumName);
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +".pdf";
        final spaceRef = pdfRef.child(fileName);
        File file = File(pdfPath);
        await spaceRef.putFile(file);
        final String link = "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/${uid}%2Fpdfs%2F${museumName}%2F${fileName}?alt=media";
        final possibleError =  await apiHandler.addPdf(uid: uid,index: index,postUrl: link);
        if(!possibleError)
        {
          anyError = link;
        }
      }
      return anyError;
    }
    catch(e){
      print(e);
    }
  }

  Future<String> _pickSound() async {
    try {
      print("aq0");
      try{
        final sound =  await FilePicker.platform.pickFiles(type:FileType.custom, allowedExtensions:['mp3', 'ogg', 'wav'],allowMultiple: false);
        return sound.paths[0];
      }catch(e){print(e);}
      print("aq1");
      //file picker can get multiple files but we only got 1 file so we need only the first files path to upload because we only got one
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadSound(String uid,String museumName,int index) async {
    try
    {
      String anyError;
      final soundPath = await _pickSound();
      print(soundPath);
      if (soundPath != null)
      {
        final storageRef = FirebaseStorage.instance.ref();
        Reference soundRef = storageRef.child(uid).child("sounds").child(museumName);
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +".m4a";
        final spaceRef = soundRef.child(fileName);
        File file = File(soundPath);
        await spaceRef.putFile(file);
        final String link = "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/${uid}%2Fsounds%2F${museumName}%2F${fileName}?alt=media";
        final possibleError =  await apiHandler.addSound(uid: uid,index: index,postUrl: link);
        if(!possibleError)
        {
          anyError = link;
        }
      }
      return anyError;
    }
    catch(e){
      print(e);
    }
  }






}