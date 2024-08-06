import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/auth/auth_cubit.dart';
import 'package:fridge_to_feast/presentation/ui/auth_ui/loginpage.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/recipedetail.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile(
      {super.key,
      required this.userName,
      required this.email,
      required this.profile_url});

  final String userName;
  final String email;
  final String profile_url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.5,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipOval(
                child: Image.network(
              profile_url.toString(),
              fit: BoxFit.cover,
              height: 150,
              loadingBuilder: loadingImage,
              errorBuilder: imageError,
              filterQuality: FilterQuality.high,
            )),
            userDetails(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Logout", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),),
                IconButton(
                  onPressed: () async {
                    final result = await context.read<AuthCubit>().logoutUser();
                
                    if (result == false) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    }
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 21,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imageError(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 8),
          Text('Failed to load image', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget loadingImage(context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    } else {
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    }
  }

  Center userDetails(BuildContext context) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          child: ListView(
            children: [
              ListTile(
                leading: Text(
                  "User Name: ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(userName,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                dense: true,
              ),
              Divider(),
              ListTile(
                leading: Text(
                  "Email: ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(email,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                dense: true,
              ),
              Divider(),
              ListTile(
                leading: Text(
                  "Phone number : ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text("Not Found",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                dense: true,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
