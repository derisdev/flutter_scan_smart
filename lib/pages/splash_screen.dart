import 'package:flutter/material.dart';
import 'package:scansmart/pages/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/splash.png",
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}
