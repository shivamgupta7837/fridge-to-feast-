import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
          "Profile",
          style:
              GoogleFonts.pacifico(fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), 
                color: Colors.white),
            child:  SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.separated(
               separatorBuilder: (context, index) => const Divider(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) { 
                return ListTile(
                  leading: Text("User Name: ",style: TextStyle(fontSize: 16,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                  trailing: Text("Shivam Gupta",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold)),
                  dense: true,
                );
               },
            
            ),
          ),
            
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: const Row(
                      children: [
                                Icon(Icons.logout,color: Colors.red,size: 18,),
                            SizedBox(width: 5,),
                        Text("Logout",
                            style: TextStyle(color: Colors.black,fontSize: 16)),
                      ],
                    ),
                    onPressed: () {}),
              ],
            )
        ],
      ),
    );
  }
}


   
          