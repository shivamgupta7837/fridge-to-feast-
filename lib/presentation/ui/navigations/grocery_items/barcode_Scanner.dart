import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/Apis/grocery_barCode_scanner_api.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BarcodeScanner extends StatelessWidget {
  BarcodeScanner({super.key});
  final _obj = GroceryBarCodeScannerAPI();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryItemsBloc, GroceryItemsState>(
      builder: (context, state) {
        return Column(
          children: [
            Image.asset(
              "assets/features/qr.png",
              height: 90,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Note: The default expiry date for Grocery is 15 days from the current date.You can update the expiry date by tapping three dotted lines",
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.red, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    "#673ab7", "Cancel", true, ScanMode.BARCODE);

                saveGroceryUsingQR(barcodeScanRes, context);
              },
              child: Text(
                "Scan QR",
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  saveGroceryUsingQR(String code, BuildContext context) async {
    String? brandName = " ";
    int quantity = 1;
    String unit = "kg";

    final date = DateTime.now();
    final expiryDate = DateTime(date.year, date.month + 1, 0);

    final data = await _obj.getResultFromApi(UpcCode: code);

    for (int i = 0; i < data!.gTINTestResults!.length; i++) {
      brandName = data.gTINTestResults![i].brandName;
    }

    context.read<GroceryItemsBloc>().add(AddGroceryItemsEvent(
        item: brandName!,
        expiryDate: expiryDate.toString().split(" ")[0].toString(),
        id: DateTime.now().millisecondsSinceEpoch,
        quantity: quantity,
        quantityMeasurementUnits: unit));
  }
}
