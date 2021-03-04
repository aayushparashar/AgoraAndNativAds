import 'package:appyHigh/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppyHigh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: MyHomePage(),
loadingText: Text('Welcome to our app!'),
//          title: new Text('Welcome In SplashScreen'),
          image: new Image.asset('assets/appyHigh.png'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red
      ),
    );
  }
}
