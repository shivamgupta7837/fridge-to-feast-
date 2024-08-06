import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRecipeFullScreen extends StatelessWidget {
  final String myRecipe;
  final String title;
  const MyRecipeFullScreen({super.key,required this.myRecipe, required this.title});

  @override
  Widget build(BuildContext context) {
          
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              
        ),
      ),
      ),
      body:SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children:[
                  Text(myRecipe,textDirection: TextDirection.ltr,)
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}