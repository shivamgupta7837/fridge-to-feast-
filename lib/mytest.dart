import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fridge_to_feast/Apis/grocery_barCode_scanner_api.dart';

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
            
            
              },
              child: Text("press"))
        ],
      ),
    );
  }

}
