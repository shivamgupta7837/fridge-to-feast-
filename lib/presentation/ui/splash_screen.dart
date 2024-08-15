import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/presentation/home_page.dart';
import 'package:fridge_to_feast/presentation/ui/auth_ui/loginpage.dart';
import 'package:fridge_to_feast/presentation/ui/features/app_goto_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logos/splash_Screen_logo.jpg",height: 300,),
      //      Text("We Focuses on managing your pantry",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
    void whereToGo() async {
    final sharePref = await SharedPreferences.getInstance();
    var isLoggedIn = sharePref.getBool(AuthKeys.LOGGEDIN);
    if (isLoggedIn != null) {
      if (isLoggedIn == true) {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  HomePageScreen())));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>  LoginPage())));
      }
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>  LoginPage())));
    }
  }
}
