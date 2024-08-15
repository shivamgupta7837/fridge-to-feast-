import 'package:flutter/material.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/kitchen_companion_ui/Kitchen_companion.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/grocery_items/grocery_items.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/recipedetail.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/profile.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/youtube_screens/youtube.dart';
import 'package:fridge_to_feast/repositary/share_preferences/user_credentials_share_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int currentPageIndex = 0;
  List<String> titleOfNavigationScreens = [
    "Grocery Items",
    "Kitchen Companion",
    "Youtube videos"
  ];

  String? name;
  String? email;
  String? image_url;
  @override
  initState() {
    super.initState();
    check();
  }

  void check() async {
    LocalRepo repo = LocalRepo();
    final details = await repo.getUserCredentials();
    name = details.name;
    email = details.email;
    image_url = details.profileUrl;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.5,
        foregroundColor: Colors.black,
        title: Text(
          titleOfNavigationScreens[currentPageIndex],
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecipeDetail()));
              },
              child: Icon(
                Icons.download_for_offline_outlined,
                size: 25,
              )),
          SizedBox(
            width: 13,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () async {
                  LocalRepo repo = LocalRepo();
                  final details = await repo.getUserCredentials();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Profile(
                                userName: details.name.toString(),
                                email: details.email.toString(),
                                profile_url: details.profileUrl.toString(),
                              )));
                },
                child: ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Icon(Icons.person))),
          ),
        ],
      ),
      body: SafeArea(
        child: <Widget>[
          GroceryItems(),
          //! Ask from AI
          KitchenCompanion(theme: theme),
          //!Youtube
          Youtube(),
        ][currentPageIndex],
      ),
      bottomNavigationBar: myNavigationBarr(),
    );
  }

  NavigationBar myNavigationBarr() {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepPurple.shade200,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Grocery Items',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Icon(Icons.messenger_outline_sharp),
            label: 'Kitchen Companion',
          ),
          NavigationDestination(
            selectedIcon: Image.asset(
              "assets/icons/youtube-filled.png",
              height: 32,
              width: 35,
            ),
            icon: Image.asset(
              "assets/icons/youtube.png",
              height: 32,
              width: 35,
            ),
            label: 'Youtube',
          ),
        ]);
  }
}
