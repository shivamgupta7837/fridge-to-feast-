import 'package:flutter/material.dart';
//TODO: Make features screens.
class AppFeatures extends StatelessWidget {
  const AppFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){}, child: const Text("Skip  to continue",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),))],
      ),
      body: Column(
        // mainAxisAlignment: ,
          children: [
           SizedBox(
            height: MediaQuery.of(context).size.height *0.6,
            width: MediaQuery.of(context).size.width ,
            child: Image.asset("assets/features/feature1.jpg",fit: BoxFit.cover,)),
          ],
      ),
    );
  }
}