import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/auth/auth_cubit.dart';
import 'package:fridge_to_feast/presentation/ui/auth_ui/loginpage.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/Kitchen_companion.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/grocery_items.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/my_recipe.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/profile.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/youtube_screens/youtube.dart';
import 'package:fridge_to_feast/repositary/share_preferences/user_credentials_share_preferences.dart';
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
     
        shadowColor: Colors.black,
        elevation: 5,
        foregroundColor: Colors.black,
        title: Text(
          titleOfNavigationScreens[currentPageIndex],
          style: GoogleFonts.pacifico(
              fontSize: 18,
              fontWeight: FontWeight.w300,
                      ),
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
        margin: const EdgeInsets.only(top: 40, bottom: 400),
        width: MediaQuery.of(context).size.width * 0.2,
        child: myDrawer(context),
      ),
    );
  }

  Widget myDrawer(BuildContext context) {

    return  Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Profile(
                                  userName: name.toString(),
                                  email: email.toString(),
                                  profile_url: image_url.toString(),
                                ))),
                    child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: image_url != null?   Image.network(
                          image_url.toString(),
                          height: 40,
                        ):Icon(Icons.person_2_rounded),)
                  ),
                  IconButton(
                      onPressed: () {
                        context.read<AuthCubit>().saveUserCredentiails();
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 28,
                      )),
                  const SizedBox(
                    height: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyRecipe()));
                    },
                    child: Icon(Icons.save)
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  IconButton(
                    onPressed: () async {
                      final result =
                          await context.read<AuthCubit>().logoutUser();

                      if (result == false) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      }
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 21,
                    ),
                  )
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
