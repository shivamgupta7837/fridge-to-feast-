import 'package:flutter/material.dart';
import 'package:fridge_to_feast/services/push%20notification/push_notification.dart';

class TestFeature extends StatelessWidget {
 TestFeature({super.key});
final _notificaion = Notifications();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            _notificaion.simpleNotification();
          }, child: Text("Notifications"))
        ],
      ),
    );
  }
}