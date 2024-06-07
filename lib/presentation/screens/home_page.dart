import 'package:flutter/material.dart';
import 'package:fridge_to_feast/presentation/screens/ui/navigations/Kitchen_companion.dart';
import 'package:fridge_to_feast/presentation/screens/ui/navigations/grocery_items.dart';
import 'package:fridge_to_feast/presentation/screens/ui/navigations/profile.dart';
import 'package:fridge_to_feast/presentation/screens/ui/navigations/youtube.dart';
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
        backgroundColor: titleOfNavigationScreens[currentPageIndex]=="Youtube videos"?Colors.red[800]:null,
        shadowColor: Colors.black,
        elevation: 5,
        foregroundColor: Colors.black,
        title: Text(
          titleOfNavigationScreens[currentPageIndex],
          style:
              GoogleFonts.pacifico(fontSize: 18, fontWeight: FontWeight.w300,color: titleOfNavigationScreens[currentPageIndex]=="Youtube videos"?Colors.white:null),
        ),
        actions: [
          Container(
            margin:const EdgeInsets.all(10),
            child: InkWell(
              child:  const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("S"),
              ),
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>Profile())),
            ),
          )
        ],
      ),
      body: <Widget>[
         GroceryItems(),

        //! Ask from AI
        KitchenCompanion(theme: theme),

        //!Youtube
         Youtube()
      ][currentPageIndex],
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
        indicatorColor: Colors.deepPurple.shade200,
        selectedIndex: currentPageIndex,
        destinations:  <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Icon(Icons.messenger_outline_sharp),
            label: 'Kitchen Companion',
          ),
          NavigationDestination(
            selectedIcon:  Image.asset("assets/icons/youtube-filled.png",height: 32,width: 35,),
            icon: Image.asset("assets/icons/youtube.png",height: 32,width: 35,),
            label: 'Youtube',
          ),
        ]);
  }
}
