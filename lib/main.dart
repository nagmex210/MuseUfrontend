import 'package:flutter/material.dart';
import 'package:muse_u/Models/museumModel.dart';
import 'package:muse_u/Screens/MainScreens/home.dart';
import 'package:muse_u/constants.dart';
import 'Screens/StartOfTheApp/enterance.dart';
import 'Screens/StartOfTheApp/loginScreen.dart';
import 'Screens/StartOfTheApp/registerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:muse_u/Screens/StartOfTheApp/email_verification.dart';
import 'package:muse_u/Models/auth.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'Screens/MainScreens/nonEditable/MuseumAlley.dart';
import 'package:muse_u/helpers/apiRequestMaker.dart';

bool _initialURILinkHandled = false;


 void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder:EasyLoading.init(),
      initialRoute: "/",
      routes: {
        '/': (context) => Authenticate(),
        ENTERANCE_SCREEN_ROUTE:(context)=>Enterance(),
        LOGIN_SCREEN_ROUTE :(context) => LoginScreen(),
        REGISTER_SCREEN_ROUTE:(context) => RegisterScreen(),
        HOME_SCREEN_ROUTE :(context) =>Home(),
        EMAIL_SCREEN_ROUTE:(context)=>EmailVerification()

      },
    );
  }
}



class Authenticate extends StatefulWidget {
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  Uri _initialURI;
  Uri _currentURI;
  Object _err;

  StreamSubscription _streamSubscription;

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
            _initialURI = initialURI;
          var uripath = _initialURI.path;
          uripath = uripath.substring(1);
          if( uripath != null && !uripath.contains("/"))
          {
            Map museum = await apiHandler.getActiveMuseum(uripath);
            Museum newMuseum = new Museum(name: museum["name"],
                images: museum["images"], videos: museum["videos"],
                sounds: museum["sounds"], secrets: museum["secrets"],documents: museum["documents"]);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MuseumAlley(museum: newMuseum, name: newMuseum.name)),
            );
          }
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException { // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) { // 6
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    // 1
      _streamSubscription = uriLinkStream.listen((Uri uri) async {
        debugPrint('Received URI: $uri');
          _currentURI = uri;
          _err = null;
          var uripath = _currentURI.path;
          uripath = uripath.substring(1);
          if( uripath != null && !uripath.contains("/"))
            {
              Map museum = await apiHandler.getActiveMuseum(uripath);
               Museum newMuseum = new Museum(name: museum["name"],
                   images: museum["images"], videos: museum["videos"],
                   sounds: museum["sounds"], secrets: museum["secrets"],documents: museum["documents"]);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MuseumAlley(museum: newMuseum, name: newMuseum.name)),
              );
            }
          else
            {
              EasyLoading.showError("There is a error with the link please check the link");
            }
        // 3
      }, onError: (Object err) {
        debugPrint('Error occurred: $err');
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = Auth()?.currentUser;

     if (firebaseUser != null){
      return Home();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return Enterance();
  }
}



