import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyTest extends StatelessWidget {
  const MyTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final db = FirebaseFirestore.instance;

                      final user = db
                          .collection(
                              "users") //L18hHpMP3rONneHMoMOY -> This path will come from user.
                          .doc("rJ9UyyN1MXooejPNEs8d");

                      //getting grocery items.
                      user.collection("GROCERY_ITEMS").get().then((event) {
                        for (var doc in event.docs) {
                          print("${doc.id} => ${doc.data()}");
                        }
                      });


                      //getting AI Conversation.
                      user.collection("KITCHEN_CAMPANION").get().then((event) {
                        for (var doc in event.docs) {
                          print("${doc.id} => ${doc.data()}");
                        }
                      });
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: Text("save")))
        ],
      ),
    );
  }
}

/*

Map data = {
    "user_name": "Ram Kumar",
    "email": "kumarram@gmail.com"
    "grocery": [
        {
            "grocery_id": 754213542367,
            "name": "Apple",
            "expiry_date": "2024-06-21T00:00:00Z"
        }
    ],
   
}

data["grocery"][0]



*/
