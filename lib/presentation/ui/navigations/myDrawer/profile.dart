import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.userName, required this.email, required this.profile_url});

  final String userName;
  final String email;
  final String profile_url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        elevation: 5,
        foregroundColor: Colors.black,
        title: Text(
          "My Profile",
          style:
              GoogleFonts.pacifico(fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          
          alignment: Alignment.topCenter,
          children: [
            userDetails(context),
                      Positioned(
                        top: 50,
                        child: ClipOval(child: Image.network(profile_url.toString(),fit: BoxFit.cover,height: 170,)),
                      ),
          ],
        ),
      ),
    );
  }

  Center userDetails(BuildContext context) {
    return Center(
          child: Container(
            padding: const EdgeInsets.only(right: 10, left: 10, top: 90, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), 
                color: Colors.white),
            child:  SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            child: ListView(
              children: [
                 ListTile(
                  leading: Text("User Name: ",style: TextStyle(fontSize: 16,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                  trailing: Text(userName,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold)),
                  dense: true,
                ),
                Divider(),
                 ListTile(
                  leading: Text("Email: ",style: TextStyle(fontSize: 16,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                  trailing: Text(email,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold)),
                  dense: true,
                ),
                Divider(),
                 ListTile(
                  leading: Text("Phone number : ",style: TextStyle(fontSize: 16,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                  trailing: Text("Not Found",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold)),
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


   
          