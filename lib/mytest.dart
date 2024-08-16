import 'package:flutter/material.dart';
import 'package:fridge_to_feast/Apis/grocery_barCode_scanner_api.dart';
import 'package:fridge_to_feast/services/push%20notification/push_notification.dart';

class TestFeature extends StatelessWidget {
  TestFeature({super.key});
  final obj = GroceryBarCodeScannerAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async{
            
            final obj = Notifications();
            obj.showExpiryNotification();
              },
              child: Text("press"))
        ],
      ),
    );
  }

}
