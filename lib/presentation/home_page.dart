import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/Kitchen_companion.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/grocery_items.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/my_recipe.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/profile.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/youtube_screens/youtube.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            titleOfNavigationScreens[currentPageIndex] == "Youtube videos"
                ? Colors.red[800]
                : null,
        shadowColor: Colors.black,
        elevation: 5,
        foregroundColor: Colors.black,
        title: Text(
          titleOfNavigationScreens[currentPageIndex],
          style: GoogleFonts.pacifico(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color:
                  titleOfNavigationScreens[currentPageIndex] == "Youtube videos"
                      ? Colors.white
                      : null),
        ),
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
      drawer: Container(
        margin:const EdgeInsets.only(top:40,bottom: 400),
          width: MediaQuery.of(context).size.width * 0.2,
        child: myDrawer(context),
      ),
    );
  }

  Drawer myDrawer(BuildContext context) {
    return Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Profile())),
                child:  CircleAvatar(
                    child: Text(
                  "S",
                  style: GoogleFonts.almarai(fontSize: 22,fontWeight: FontWeight.w400),
                )),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.location_on_outlined,size: 28,)),
              const SizedBox(
                height: 2,
              ),
             GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MyRecipe()));
              },
              child:Image.asset("assets/icons/recipe.png",height: 25,),
             ),
               SizedBox(
                height: MediaQuery.of(context).size.height * 0.28
              ),
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 21,
              ),
            ],
          ),
        ),
      );
  }

  NavigationBar myNavigationBarr() {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.deepPurple.shade200,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
