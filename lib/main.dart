import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:openstoreapp_client/screens/home_screen.dart';
import 'package:openstoreapp_client/screens/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter's Clothing",
      theme: ThemeData(

        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141),
      ),
      debugShowCheckedModeBanner: false,

      // home: HomeScreen()
      home: LoginScreen()
    );
  }
}

