import 'package:flutter/material.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/presentation/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppGoToScreen extends StatefulWidget {
  const AppGoToScreen({super.key});

  @override
  _AppGoToScreenState createState() => _AppGoToScreenState();
}

class _AppGoToScreenState extends State<AppGoToScreen> {
  final List<Map<String, String>> images = [
    {
      "image": "assets/features/feature1.jpeg",
      "title": "Save Grocery Lists",
      "description":
          "Save your grocery lists and get timely reminders when your groceries are about to expire."
    },
    {
      "image": "assets/features/feature2.jpeg",
      "title": "AI-Enabled Recipe Suggestions",
      "description":
          "Chat with our intelligent bot to get recipe suggestions tailored to your ingredients, dietary needs, and taste preferences."
    },
    {
      "image": "assets/features/feature3.jpeg",
      "title": "YouTube Recipe Search",
      "description":
          "Easily search and watch YouTube videos to find step-by-step recipes. Whether you’re looking for a quick meal."
    },
  ];

  final PageController _pageController = PageController();

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < images.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              child: Text("Skip to Continue",
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePageScreen()));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          images[index]["image"]!,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          images[index]["title"]!,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          images[index]["description"]!,
                          style: GoogleFonts.poppins(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: _currentPage == 2
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Color.fromRGBO(103, 58, 183, 1)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePageScreen()));
                      },
                      child: Text('Get Started',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Color.fromRGBO(103, 58, 183, 1)),
                      onPressed: _nextPage,
                      child: Text('Next',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
