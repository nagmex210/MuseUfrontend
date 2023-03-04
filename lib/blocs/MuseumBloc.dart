import 'package:muse_u/helpers/apiRequestMaker.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';


class MuseumsCubit extends Cubit<List<Museum>> {
  MuseumsCubit() : super([]);

  /// When increment is called, the current state
  /// of the cubit is accessed via `state` and
  /// a new `state` is emitted via `emit`.
  Future<void> getMuseums(uid) async{
    try
    {
      await apiHandler.getMuseums(uid).then((value) {
        var museums = value.map((element) => Museum(
            name: element["name"],
            images: element["images"],
            videos: element["videos"],
            sounds: element["sounds"],
            secrets: element["secrets"],
            documents: element["documents"],
            guestList: element["gusetList"]
        )).toList();
        emit(museums);
      });
    }
    catch(e)
    {
      print(e);
    }
  }
    
 // void addMuseums(String uid , String name) async
 // {
 //   try{
 //     await apiHandler.addMuseum(uid: uid , name: name);
 //     Museum newMuseum = Museum(
 //         name: name,
 //         images: [],
 //         videos: [],
 //         sounds: [],
 //         documents: [],
 //         secrets:[],
 //         guestList: []
 //     );
 //     emit([...state, newMuseum]);
 //   }
 //   catch (e)
 //   {
    //  print(e);
  //  }
//  }

  void updateImages(int index,List<dynamic> imagePaths){
    final  museums = state;
    final updatedMuseum = Museum(
      name: museums[index].name,
      images: imagePaths,
      videos: museums[index].videos,
      sounds: museums[index].sounds,
      documents: museums[index].documents,
        secrets: museums[index].secrets,
      guestList: museums[index].guestList
    );
    final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
      emit(updatedMuseums);
    }
    
  void updateSounds(int index,List<dynamic> soundPaths){
    final  museums = state;
    final updatedMuseum = Museum(
        name: museums[index].name,
        images: museums[index].images,
        videos: museums[index].videos,
        sounds: soundPaths,
        documents: museums[index].documents,
        secrets: museums[index].secrets,
        guestList: museums[index].guestList
    );
    final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
    emit(updatedMuseums);
  }

  void updateVideos(int index,List<dynamic> videoPaths){
    final  museums = state;
    final updatedMuseum = Museum(
        name: museums[index].name,
        images: museums[index].videos,
        videos: videoPaths,
        sounds: museums[index].sounds,
        documents: museums[index].documents,
        secrets: museums[index].secrets,
      guestList: museums[index].guestList
    );
    final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
    emit(updatedMuseums);
  }

  void updatePdfs(int index,List<dynamic> pdfPaths){
    final  museums = state;
    final updatedMuseum = Museum(
        name: museums[index].name,
        images: museums[index].images,
        videos: museums[index].videos,
        sounds: museums[index].sounds,
        documents: pdfPaths,
        secrets: museums[index].secrets,
      guestList: museums[index].guestList
    );
    final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
    emit(updatedMuseums);
  }

  Future<void> addToGuestList(String uid,String guestUsername) async{
    const index = 0;
    bool anyError = await apiHandler.add2guestlist(uid: uid, guestUsername: guestUsername);
    if (!anyError)
    {
      var nGuestList = state[0].guestList;
      nGuestList.add(guestUsername);
      final  museums = state;
      final updatedMuseum = Museum(
          name: museums[0].name,
          images: museums[0].images,
          videos: museums[0].videos,
          sounds: museums[0].sounds,
          documents: museums[0].guestList,
          secrets: museums[0].secrets,
          guestList: nGuestList
      );
      final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
      emit(updatedMuseums);
    }
  }

  Future<void> removeFromGuestList(String uid,String guestUsername) async{
    const index = 0;
    bool anyError = await apiHandler.removeFromGuestList(uid: uid, guestUsername: guestUsername);
    if (!anyError)
    {
      var nGuestList = state[0].guestList;
      nGuestList.remove(guestUsername);
      final  museums = state;
      final updatedMuseum = Museum(
          name: museums[0].name,
          images: museums[0].images,
          videos: museums[0].videos,
          sounds: museums[0].sounds,
          documents: museums[0].guestList,
          secrets: museums[0].secrets,
          guestList: nGuestList
      );
      final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
      emit(updatedMuseums);
    }
  }

  void updateSecrets(int index,List<dynamic> nSecrets){
    final  museums = state;
    final updatedMuseum = Museum(
        name: museums[index].name,
        images: museums[index].images,
        videos: museums[index].videos,
        sounds: museums[index].sounds,
        documents: museums[index].guestList,
        secrets: nSecrets,
        guestList: museums[index].guestList
    );
    final updatedMuseums = [ ...museums.sublist(0, index),updatedMuseum,...museums.sublist(index + 1),];
    emit(updatedMuseums);
  }

}
