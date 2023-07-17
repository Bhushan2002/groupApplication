import 'package:conversation/auth/login_page.dart';
import 'package:conversation/helper/helper_function.dart';
import 'package:conversation/home_page.dart';
import 'package:conversation/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:conversation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 if(kIsWeb){
   // run the initialization for web
   await Firebase.initializeApp(
       options: FirebaseOptions(
         apiKey: Constants.apiKey,
           appId: Constants.appId,
           messagingSenderId: Constants.messageSenderId,
           projectId: Constants.projectId,
       ),
   );
 }
 else{
   // run the initialization for android and ios.
   await Firebase.initializeApp();
 }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
bool _isSignedIn = false;
  @override
  void initState() {


    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await HelperFunction.getLoggedInStatus().then((value) {
        setState(() {
          if(value != null) {
            _isSignedIn = value;
          }
        });

    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _isSignedIn  ?   const HomePage() :  const LoginPage(),

    );
  }
}
