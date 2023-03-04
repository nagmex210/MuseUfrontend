import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:io";
import 'package:path_provider/path_provider.dart';
import 'imageUploader.dart';

class apiHandler
{

  static Future<List<dynamic>> addMuseum({String uid,String name}) async {
 //   try
  //  {
  //    final Uri url = Uri.parse('http://localhost:3000/api/v1/addMuseum');
  //    Map data =
  //    {
  //      'uid': uid,
    //"name": name,
   //     "images": [],
   //     "videos": [],
   //     "sounds": [],
    //    "documents":[],
  //      "secret": [],
  //    };
 //     var body = json.encode(data);
 //     final response = await http.post(
 //       url,
 //       headers: {"Content-Type": "application/json"},
 //       body: body,
 //     ).then((value)
  //    {
 //       if (value.statusCode == 200)
 //       {
          print("eyvallah");
 //       }
 //     });
 //   }
 //   catch(e){
  //    print(e);
 //   }
  }

  static Future<bool> addImage({String uid,int index,String postUrl}) async {
      final Uri url = Uri.parse(
          'http://localhost:3000/api/v1/uploadImageToMuseum');
      Map data =
      {
        'uid': uid,
        "index": index,
        "url": postUrl
      };
      var body = json.encode(data);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        return false;
      }
      return true;
    }

  static Future<bool> updateProfilePicture({String uid}) async {
    String link = await MediaUploader().updateProfilePicture(uid);
    if(link == null) {return true;}
    final Uri url = Uri.parse(
        'http://localhost:3000/api/v1/updateUserPpLink');
    Map data =
    {
      'uid': uid,
      "ppLink": link
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      return false;
    }
    return true;
  }


  static Future<bool> addVideo({String uid,int index,String postUrl}) async {

      final Uri url = Uri.parse('http://localhost:3000/api/v1/uploadVideoToMuseum');
      Map data =
      {
        'uid': uid,
        "index": index,
        "url": postUrl
      };
      var body = json.encode(data);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
        if (response.statusCode == 200)
        {
          return false;
        }
        return true;
  }

  static Future<bool> addSound({String uid,int index,String postUrl}) async {
      final Uri url = Uri.parse('http://localhost:3000/api/v1/uploadSoundToMuseum');
      Map data =
      {
        'uid': uid,
        "index": index,
        "url": postUrl
      };
      var body = json.encode(data);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
        if (response.statusCode == 200)
        {
          return false;
        }
        return true;
  }

  static Future<bool> addPdf({String uid,int index,String postUrl}) async {
      final Uri url = Uri.parse('http://localhost:3000/api/v1/uploadPdfToMuseum');
      Map data =
      {
        'uid': uid,
        "index": index,
        "url": postUrl
      };
      var body = json.encode(data);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
        if (response.statusCode == 200)
        {
          return false;
        }
        return true;
  }

  static Future<bool> likeUser({String uid,String likedUserUsername}) async {
    final Uri url = Uri.parse('http://localhost:3000/api/v1/likeUser');
    Map data =
    {
      'likingUserUID': uid,
      "likedUserUsername": likedUserUsername
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200)
    {
      return false;
    }
    return true;
  }

  static Future<bool> add2guestlist({String uid,String guestUsername}) async {
    final Uri url = Uri.parse('http://localhost:3000/api/v1/add2guestlist');
    Map data =
    {
      'hostUID': uid,
      "guestUsername": guestUsername
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200)
    {
      return false;
    }
    return true;
  }

  static Future<bool> removeLikeFromUser({String uid,String likedUserUsername}) async {
    final Uri url = Uri.parse('http://localhost:3000/api/v1/unlikeUser');
    Map data =
    {
      'likingUserUID': uid,
      "likedUserUsername": likedUserUsername
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200)
    {
      return false;
    }
    return true;
  }

  static Future<bool> removeFromGuestList({String uid,String guestUsername}) async {
    final Uri url = Uri.parse('http://localhost:3000/api/v1/removeFromGuestlist');
    Map data =
    {
      'hostUID': uid,
      "guestUsername": guestUsername
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200)
    {
      return false;
    }
    return true;
  }



  static Future<List<dynamic>> getFilteredUsers(String searchQuery) async {
    //search etme şeyi
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/v1/getFilteredUsers?prefix=${searchQuery}'));
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);
      List<dynamic> found = data["item"];
      return found;
    }
  }

  static Future<List<dynamic>> getMuseums(String searchQuery) async {
    //search etme şeyi
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/v1/getMuseums?uid=${searchQuery}'));
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);
      List<dynamic> found = data["item"];
      return found;
    }
  }

  static Future<Map> getActiveMuseum(String searchQuery) async {
    //search etme şeyi
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/v1/getActiveMuseum?name=${searchQuery}'));
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);
      return data;
    }
  }

  static Future<Map> getUserInfo(String searchQuery) async {
    //search etme şeyi
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/v1/getUserInfo?uid=${searchQuery}'));
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      final data = jsonDecode(response.body);
      print(data);
      return data;
    }
  }


}