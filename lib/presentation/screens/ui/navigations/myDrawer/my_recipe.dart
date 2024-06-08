import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRecipe extends StatelessWidget {
  const MyRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        elevation: 5,
        foregroundColor: Colors.black,
        title: Text(
          "My Recipies",
          style:
              GoogleFonts.pacifico(fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}