import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logos/splash_Screen_logo.jpg",height: 300,),
            Text("We Focuses on managing your pantry",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
