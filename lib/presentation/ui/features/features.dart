import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 400),
          child: Center(
            child: CarouselView(
              itemSnapping: false,
              elevation: 2,
              itemExtent: 300,
              shrinkExtent: 300,
              children: [
                saveGroceryFeature(),
                aiEnabledFeature(),
                youtubeFeature(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding youtubeFeature() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset("assets/features/feature3.jpeg",height: 250,width:300, fit: BoxFit.cover),
          SizedBox(height: 15),
          Text(
            "Easily search and watch YouTube videos to find step-by-step recipes. Whether you’re looking for a quick meal",
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Padding aiEnabledFeature() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset("assets/features/feature2.jpeg",height: 250,width:300, fit: BoxFit.cover),
          SizedBox(height: 15),
          Text(
            "Chat with our intelligent bot to get recipe suggestions tailored to your ingredients, dietary needs, and taste preferences.",
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Padding saveGroceryFeature() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset("assets/features/feature1.jpeg",height: 250,width:300, fit: BoxFit.cover),
          SizedBox(height: 15),
          Text(
            "Save your grocery lists with real names in English and get timely reminders when your groceries are about to expire.",
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
