import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:openstoreapp_client/models/cart_model.dart';
import 'package:openstoreapp_client/models/user_model.dart';
import 'package:openstoreapp_client/screens/home_screen.dart';
import 'package:openstoreapp_client/screens/login_screen.dart';
import 'package:openstoreapp_client/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, chield, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
                title: "Flutter's Clothing",
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141),
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen()),
          );
        }
      ),
    );
  }
}
